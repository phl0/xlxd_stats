#!/usr/bin/perl -w
#

use strict;
use warnings;
use experimental 'smartmatch';

use IO::Socket;
use JSON;
use RRDTool::OO;

$| = 1;

my $remote = "localhost";
my $port = 10001;
my $proto = "udp";
my $rrdfile = "/usr/share/xlxd/statistics.rrd";

my $rrd = RRDTool::OO->new(file => $rrdfile );

my $socket = IO::Socket::INET->new(PeerAddr => $remote,
                                   PeerPort => $port,
                                   Proto    => $proto,
                                   Type     => SOCK_DGRAM)
             or die "Connection to $remote:$port failed; $@\n";

$socket->blocking(1);
$socket->send("hello\n");

my $datagram;
my $json;

while ($socket->recv($datagram, 65535)) {
   $json = $datagram;
   if ($datagram =~ "}]}") {
      last;
   }
}

$socket->send("bye\n");
close ($socket);

my $decoded = decode_json($json);

my @nodes = @{ $decoded->{'nodes'} };
my $i = 0;
my @peers;
foreach my $n ( @nodes ) {
   if ($n->{'module'} =~ '\w') {
      $i++;
   }
   if ($n->{'module'} =~ ' ') {
      unless ($n->{'callsign'} ~~ @peers) {
         push @peers, $n->{'callsign'};
      }
   }
}

$rrd->update(values => { "nodes" => $i,
                         "peers" => scalar @peers
                       });


exit 0;
