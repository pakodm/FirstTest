#!/usr/bin/perl -W

use strict;
use BalanceServer;

BalanceServer->run(port => 2020, host => "localhost", ipv => 4);

=begin NOTUSED
use IO::Socket;

my %server_settings = (
    LocalAddr => 'localhost',
    LocalPort => '2020',
    Proto => 'tcp',
    Listen => 10,
    ReuseAddr => 1,
    Blocking => 1,
);

my $balance_socket;
my %connected_clients;

$balance_socket = IO::Socket::INET->new(%server_settings) or die "Can't start server: $@\n";

print "Balancer up and running\n";
while (my $task = $balance_socket->accept()){
    $task->autoflush(1);
    while (<$task>){
        print "Connected: ${task}";
        my $origin = $task->peerhost().':'.$task->peerport();
        print "${origin}";
    }
}

print "Shutting down...\n";
close($balance_socket);
=end NOTUSED
=cut
