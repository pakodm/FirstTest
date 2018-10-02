#!/usr/bin/perl -W

use strict;
use BaseServer;

BaseServer->run(port => 2021, host => "localhost", ipv => 4);
