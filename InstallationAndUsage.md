# Introduction #

This program allows you to send randomly created DNS requests from random IP adresses and random source ports. You can test your anti-ddos solution with this perl script.


# Required Packages #

  * Net::RawIP
  * Net::DNS::Packet/Net/DNS/Packet.pm
  * Getopt::Long/Long.pm
  * Threaded Perl

# Details #

# Defaults #

  * domain-name is "example.com"
  * source-port is 1453
  * Randomize domain-name is disabled
  * Randomize source port is disabled
  * Randomize source address is disabled
  * count is 10000.
  * Random-id is disabled.
  * thread-count is 2.

# Usage Guidelines #
  * domainname parameter is ignored if random-name parameter is specified.
  * random-source-address parameter is ignored if source-addr is specified.
  * random-source-port parameter is ignored if source-port is specified.
  * random-id is ignored if random-name is specified.


# Warnings and Disclaimers #
  * Educational purpose only.
  * Flooding third-party hosts or networks is commonly considered a criminal activity.
  * Flooding your own hosts or networks is usually a bad idea.
  * Higher-performace flooding solutions should be used for stress/performance tests.
  * Use primarily in lab environments for DDoS tests.

# Examples #
### Example 1 ###
  * Randomize source address
  * Randomize source port
  * Send 1000 requests per thread
  * Use 8 threads.

# time ./tdnsflood.pl --domain-name=mydomain.dom --random-source-address --random-source-port --count=1000 --thread-count=8 my\_DNS\_Server-IP

Output:
```

Dest DNS Server IP: 10.10.10.10
Domain Name: mydomain.com
Source IP: Random Port: Random
Count: 8 x 1000 = 8000


Done...
```

On my test server (Quad Core Xeon 3.80Ghz), RHEL running this command takes
```
real    0m1.213s
user    0m3.031s
sys     0m0.212s
```
Tcpdump Output:
```
12:59:45.751785 IP 231.56.230.68.44855 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.751999 IP 0.200.235.180.45258 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.752213 IP 212.75.237.207.48360 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.752432 IP 229.110.28.105.11062 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.752647 IP 2.53.65.60.60835 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.752862 IP 16.5.7.207.52674 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.753075 IP 29.5.33.4.31257 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.753290 IP 194.174.65.179.51205 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
12:59:45.753657 IP 14.232.88.203.12678 > 10.10.10.10.53:  *51661*+ A? *mydomain.com*. (32)
```

### Example 2 ###
  * Randomize source address
  * Randomize source port
  * Randomize DNS query ID
  * Send 1000 requests per thread
  * Use 8 threads

# time ./tdnsflood.pl --domain-name=mydomain.com --random-id --random-source-address --random-source-port --count=1000 --thread-count=8 10.10.10.10

this command takes
```
real    0m2.141s
user    0m6.455s
sys     0m0.263s
```

tcpdump output:

```
16:16:38.693244 IP 249.102.166.151.8586 > 10.10.10.10.53:  812+ A? *mydomain.com*. (32)
16:16:38.693890 IP 219.178.18.194.35050 > 10.10.10.10.53:  49612+ A? *mydomain.com*. (32)
16:16:38.694566 IP 53.2.91.192.25436 > 10.10.10.10.53:  45012+ A? *mydomain.com*. (32)
16:16:38.695211 IP 141.191.155.191.5425 > 10.10.10.10.53:  33609+ A? *mydomain.com*. (32)
16:16:38.695880 IP 157.129.35.186.58334 > 10.10.10.10.53:  60595+ A? *mydomain.com*. (32)
16:16:38.696538 IP 163.226.221.96.8135 > 10.10.10.10.53:  54834+ A? *mydomain.com*. (32)
16:16:38.697371 IP 127.255.97.118.48338 > 10.10.10.10.53:  22558+ A? *mydomain.com*. (32)
16:16:38.698019 IP 87.247.9.70.40412 > 10.10.10.10.53:  44244+ A? *mydomain.com*. (32)
16:16:38.698694 IP 169.201.76.30.35742 > 10.10.10.10.53:  64919+ A? *mydomain.com*. (32)
```

### Example 3 ###
  * Randomize source address
  * Randomize source port
  * Randomize DNS query ID
  * Send 2000 requests per thread
  * Use 4 threads.

```
# time ./dnsfloodt_v3.pl --domain-name=mydomain.com --random-id --random-source-address --random-source-port --count=2000 --thread-
count=4 10.10.10.10
Dest DNS Server IP: 10.10.10.10
Domain Name: mydomain.com
Source IP: Random Port: Random
Count: 4 x 2000 = 8000


Done...


real    0m2.335s
user    0m6.328s
sys     0m0.207s

```
### Example 4 ###
  * Send 2000 requests per thread
  * Use 4 thread
```
# time ./tdnsfloodt.pl --domain-name=mydomain.com    --count=2000 --thread-count=4 10.10.10.10
Dest DNS Server IP: 10.10.10.10
Domain Name: mydomain.com
Source IP:  Port: 1453
Count: 4 x 2000 = 8000


Done...

real    0m0.374s
user    0m0.494s
sys     0m0.091s
```

# Contact #
Talo Pien
talopien {at} gmail dot com

# Thanks #
Special thanks to **dnsflood.pl** owner.