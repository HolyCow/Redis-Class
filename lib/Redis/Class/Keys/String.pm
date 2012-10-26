package Redis::Class::Keys::String;

use 5.006;
use strict;
use warnings;

use Moose;
use namespace::autoclean;

extends 'Redis::Class::Keys';

=head1 NAME

Redis::Class::Keys::String - The great new Redis::Class::Keys::String!

=head1 VERSION

Version 0.0001

=cut

our $VERSION = '0.0001';


=head1 SYNOPSIS

Provides interface to keys that are strings.

    use Redis::Class::Keys::String;

=head1 SUBROUTINES/METHODS

=head2 new

Creates the Redis::Class object. Accepts a hashref of settings or a set of ordered arguments.

=cut

=head2 set

Sets the value of a key to a string.

=cut

sub set {
    my ( $self, $value ) = @_;
    
    $self->redis->set( $self->name, $value );
#    $self->expires;
#    $self->initialized(1);
    
    return 1;
}

=head2 get

Returns the value of a string.

=cut

sub get {
    my $self = shift;
    
#    $self->init;
    
    return $self->redis->get( $self->name );
}

=head2 increment

Increments a string value by one.

=cut

sub increment {
    my $self = shift;
    
    $self->redis->incr( $self->name ) if ! $self->init;
    $self->expires;

    return 1;
}

=head2 decrement

Decrements a string value by one.

=cut

sub decrement {
    my $self = shift;
    
    $self->redis->decr( $self->name ) if ! $self->init;
    $self->expires;

    return 1;
}

=head2 init

Initializes the value of the string if it has expired or has not been initialized before and has a builder coderef.

=cut

sub init {
    my $self = shift;

    if ( ( ! $self->initialized || ! $self->exists ) && $self->has_builder_coderef ) {
        $self->delete if $self->exists;
        $self->set( &{ $self->builder_coderef } );
        return 1;
    }
    
    return;
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

__PACKAGE__->meta->make_immutable;

1; # End of Redis::Class

