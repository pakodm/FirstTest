package BaseServer;

use strict;
use warnings;

use base qw(Net::Server::Multiplex);

our %currentProcess = ();

sub mux_input {
    my ($self, $mux, $fh, $dataRef) = @_;
    my $inputData = $$dataRef;
    print STDERR "${inputData}\015\012";
    
    my ($uuid, $taskId) = split(/,/,$inputData);
    $currentProcess{$uuid}{'status'} = 0;
    print executeTask($taskId);

    if ($inputData eq 'close') {
        close(STDOUT);
    } 
}

sub getCurrentLoad {
    my $self = shift;
    my $load = `uptime`;
    return ($load =~ /(\d+\.\d+)/) ? $1 : 0.01;
}

sub getTaskStatus {
    my ($self, $uuid) = @_;
    if (exists $currentProcess{$uuid}) {
        return $currentProcess{$uuid}{'status'};
    }
    return undef;
}

sub executeTask {
    my ($self, $taskId) = @_;
    if ($taskId == 0) {
        return getCurrentLoad();
    }
}

sub cleanUpProcess {
    # Need to hold incoming connections while cleaning
    my %tempProcess = ();
    foreach my $task (keys $currentProcess) {
        if ($currentProcess{$uuid}{'status'} == 0) {
            $tempProcess{$uuid} = $currentProcess{$uuid};
        }
    }
    $currentProcess = $tempProcess;
}

sub mux_connection {
    my ($self, $mux, $fh) = @_;
}

sub mux_close {
    my ($self, $mux, $fh) = @_;
}

1;