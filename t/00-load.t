#!/usr/bin/env perl -w

use strict;
use Test::More tests => 2;
use Test::NoWarnings;

BEGIN {
	use_ok( 'AnyEvent::Object' );
}

diag( "Testing AnyEvent::Object $AnyEvent::Object::VERSION, Perl $], $^X" );
