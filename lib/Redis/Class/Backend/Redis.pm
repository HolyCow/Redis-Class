package Redis::Class::Backend::Redis;

use 5.006;
use strict;
use warnings;

use Moose;
use namespace::autoclean;

use Redis;

has 'redis' => (
    is => 'rw',
    isa => 'Redis',
    lazy_build => 1,
);

sub _build_redis {
    my $self = shift;

    return Redis->new(
        server => $self->host . ':' . $self->port,
        reconnect => 60,
    );
}

has 'host' => (
    is => 'rw',
    isa => 'Str',
);

has 'port' => (
    is => 'rw',
    isa => 'Int',
);

=head1 NAME

Redis::Class::Backend::Redis - Redis::Class Interface to Redis.pm

=head1 VERSION

Version 0.0001

=cut

our $VERSION = '0.0001';


=head1 SYNOPSIS


=head1 SUBROUTINES/METHODS

=head2 get

=cut

sub get {
    my ( $self, $name ) = @_;
    
    return $self->redis->get( $name );
}

=head2 set

=cut

sub set {
    my ( $self, $name, $value ) = @_;
    
    $self->redis->set( $name, $value );
    
    return 1;
}

=head2 exists

=cut

sub exists {
    my ( $self, $name ) = @_;
    
    return 1 if $self->redis->exists( $name );
    
    return;
}

=head2 delete

=cut

sub delete {
    my ( $self, $name ) = @_;
    
    $self->redis->del( $name );
    
    return 1;
}

=head2 expire

=cut

sub expire {
    my ( $self, $name, $value ) = @_;
    
    return $self->redis->expire( $name, $value );
}

=head2 ttl

=cut

sub ttl {
    my ( $self, $name ) = @_;
    
    return $self->redis->ttl( $name );
}

=head2 persist

=cut

sub persist {
    my ( $self, $name ) = @_;
    
    return $self->redis->persist( $name );
}

=head2 type

=cut

sub type {
    my ( $self, $name ) = @_;
    
    return $self->redis->type( $name );
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
