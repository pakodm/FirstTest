package BalanceServer;

use strict;
use warnings;

use base qw(Net::Server::Multiplex);

our %hosts = ( #TODO: Move this structure to a config file
    server1 => {
        host => "localhost:2021",
        load => 0.01,
        tasks => {}
    },
    server2 => {
        host => "localhost:2022",
        load => 0.01,
        tasks => {}
    },
    server3 => {
        host => "localhost:2023",
        load => 0.01,
        tasks => {}
    }
);

sub mux_input {
    my ($self, $mux, $fh, $dataRef) = @_;
    my $inputData = $$dataRef;
    my %task = ();
    print STDERR "${inputData}\015\012";

    my $uuid = getUUID();
    print STDERR "Gen: ${uuid}";
    $task{$uuid} = (
        status => 0,
        result => undef
    );

    print "${inputData} - ${uuid}\015\012";
    if ($inputData eq 'close') {
        close(STDOUT);
    } 
}

sub mux_connection {
    my ($self, $mux, $fh) = @_;
    print "Welcome\015\012";
}

sub mux_close {
    my ($self, $mux, $fh) = @_;
    print "Bye\015\012";
}

sub getUUID {
    my $self = shift;
    my $uuid = `uuidgen`;
    while (!checkUUID($uuid)){
        $uuid = `uuidgen`;
    }
    return $uuid;
}

sub checkUUID {
    my ($self, $uuid) = @_;
    my $uuidOK = 1;
    foreach my $server ( keys %hosts ) {
        foreach my $tasks (keys $hosts{$server}{'tasks'}) {
            if (exists $hosts{$server}{'tasks'}{$uuid}) {
                $uuidOK = 0;
                last;
            }
        }
        last unless $uuidOK;
    }
    return $uuidOK;
}

sub getTaskStatus {
    my ($self, $uuid) = @_;
    my $destination;
    foreach my $server ( keys %hosts ) {
        foreach my $tasks (keys $hosts{$server}{'tasks'}) {
            if (exists $hosts{$server}{'tasks'}{$uuid}) {
                if ($hosts{$server}{'tasks'}{$uuid}{'status'} == 0) {
                    $destination = $hosts{$server}{'host'};
                } else {

                }
                last;
            }
        }
    }

}

sub redirectTaskToServer {
    my ($self, $task) = @_;
    my $destination;
    my $currentLoad = 100;
    foreach my $server ( keys %hosts ) {
        if ($hosts{$server}{'load'} < $currentLoad){
            $destination = $hosts{$server}{'host'};
            $currentLoad = $hosts{$server}{'load'};
        }
    }
}

1;