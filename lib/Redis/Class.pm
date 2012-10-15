package Redis::Class;

use 5.006;
use strict;
use warnings;

use Moose;
use namespace::autoclean;

use Redis::Class::Backend;
use Redis::Class::Keys;
use Redis::Class::Keys::String;

use Carp;

has 'backend' => (
    is => 'rw',
    isa => 'Str',
);

has 'host' => (
    is => 'rw',
    isa => 'Str',
    default => sub {
        return '127.0.0.1';
    },
);

has 'port' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
        6379;
    },
);

has 'socket' => (
    is => 'rw',
    isa => 'Str',
);

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
 
    if ( @_ == 1 && ! ref $_[0] ) {
        if ( $_[0] =~ m{^([^:]+):([0-9]+$)} ) {
            my ($host, $port) = ($1, $2);
            return $class->$orig( host => $host, port => $port );
        } else {
            return $class->$orig( host => $_[0] );
        }
    } else {
        return $class->$orig(@_);
    }
};

has 'redis' => (
    is  => 'ro',
    isa => 'Redis::Class::Backend',
    lazy_build => 1,
);

sub _build_redis {
    my $self = shift;

    return Redis::Class::Backend->new(
        host    => $self->host,
        port    => $self->port,
        backend => $self->backend,
    );
}
 
=head1 NAME

Redis::Class - The great new Redis::Class!

=head1 VERSION

Version 0.0001

=cut

our $VERSION = '0.0001';


=head1 SYNOPSIS

Quick summary of what the module does.

    use Redis::Class;

    my $redis_class = Redis::Class->new({ 
        host => '127.0.0.1', 
        port => 6379
    });
    
    $redis_class = Redis::Class->new( '127.0.0.1:6380' );

    $redis_class = Redis::Class->new( '127.0.0.1' );

=head1 SUBROUTINES/METHODS

=head2 new

Creates the Redis::Class object. Accepts a hashref of settings or a set of ordered arguments.

TODO: Backend (which Redis module to use to connect)
TODO: Socket (Connect through unix socket)
TODO: Authentication
TODO: Timeout
TODO: Database (Choose database, defaults to 0 for now)
TODO: UTF8 (Encode to UTF8 to server, decode from UTF8 from server)
TODO: Lazy (RedisDB setting, doesn't connect until command sent)
TODO: Reconnect/Every (Redis.pm setting, how long to try to reconnect/how often)

=cut

=head2 Key

Returns a Redis::Class::Key object.

=cut

sub key {
    my $self = shift;
    my $name = shift;
    
    return Redis::Class::Keys->new({
        name  => $name,
        redis => $self->redis,
    });
}

=head2 string

Returns a Redis::Class::Key::String object.

=cut

sub string {
    my $self = shift;
    my $name = shift;
    
    return Redis::Class::Keys::String->new({
        name  => $name,
        redis => $self->redis,
    });
}

=head1 AUTHOR

Mike Beasterfeld, C<< <mike.beasterfeld at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-redis-class at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Redis-Class>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Redis::Class


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Redis-Class>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Redis-Class>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Redis-Class>

=item * Search CPAN

L<http://search.cpan.org/dist/Redis-Class/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Mike Beasterfeld.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Redis::Class
