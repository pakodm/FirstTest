#!/usr/bin/perl -W

use strict;
use IO::Socket::INET;

my %client_settings = (
    PeerHost => 'localhost',
    PeerPort => '2020',
    Proto => 'tcp'
);
my $client_socket;

$client_socket = IO::Socket::INET->new(%client_settings) or die "$@\n" ;

print "Client up and running\n";
while (my $inData = <$client_socket>){
    print STDERR "${inData}\n";
    
    # print $client_socket "MZX,0,6,20181001000000,ABCDEF";
}

print "Shutting down...\n";
close($client_socket);
