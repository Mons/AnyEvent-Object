package AnyEvent::Object;

use 5.008008;
use AnyEvent 5;
BEGIN { AnyEvent::common_sense(); };m{
use strict;
use warnings;
};
use Carp;
use Scalar::Util 'weaken';

=head1 NAME

AnyEvent::Object - Parent class for AnyEvent-based objects

=cut

our $VERSION = '0.01'; $VERSION = eval($VERSION);

=head1 SYNOPSIS

    package Sample;
    use 'parent' AnyEvent::Object;

    ...
    
    my $s = Sample->new();
    
    $s->periodic(1, sub { ... });
    $s->after(3, sub { ... });
    
    $s->destroy;

=head1 DESCRIPTION

    ...

=cut


=head1 METHODS

=over 4

=item ...()

...

=back

=cut


sub new {
	my $pk = shift;
	my $self = bless {@_},$pk;
	$self->init();
	$self;
}

# Timers bound to object life

sub periodic_stop;
sub periodic {
	weaken( my $self = shift );
	my $interval = shift;
	my $cb = shift;
	#warn "Create periodic $interval";
	$self->{timers}{int $cb} = AnyEvent->timer(
		after => $interval,
		interval => $interval,
		cb => sub {
			local *periodic_stop = sub {
				warn "Stopping periodic ".int $cb;
				delete $self->{timers}{int $cb}; undef $cb
			};
			$self or return;
			$cb->();
		},
	);
	defined wantarray and return AnyEvent::Util::guard(sub {
		delete $self->{timers}{int $cb};
		undef $cb;
	});
	return;
}

sub after {
	weaken( my $self = shift );
	my $interval = shift;
	my $cb = shift;
	#warn "Create after $interval";
	$self->{timers}{int $cb} = AnyEvent->timer(
		after => $interval,
		cb => sub {
			$self or return;
			delete $self->{timers}{int $cb};
			$cb->();
			undef $cb;
		},
	);
	defined wantarray and return AnyEvent::Util::guard(sub {
		delete $self->{timers}{int $cb};
		undef $cb;
	});
	return;
}

sub destroy {
	my ($self) = @_;
	$self->DESTROY;
	my $pk = ref $self;
	defined &{$pk.'::destroyed::AUTOLOAD'} or *{$pk.'::destroyed::AUTOLOAD'} = sub {};
	bless $self, "$pk::destroyed";
}

sub DESTROY {
	my $self = shift;
	warn "(".int($self).") Destroying $self" if $self->{debug};
	%$self = ();
}

=head1 AUTHOR

Mons Anderson <mons@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright 2012 Mons Anderson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

=cut

1;
