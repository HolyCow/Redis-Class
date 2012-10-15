package Redis::Class::Keys;

use 5.006;
use strict;
use warnings;

use Moose;
use namespace::autoclean;

has 'name' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
);

has 'redis' => (
    is => 'rw',
    isa => 'Redis::Class::Backend',
    required => 1,
);

has 'expire' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 0 },
);

has 'builder_coderef' => (
    is => 'rw',
    isa => 'CodeRef',
    predicate => 'has_builder_coderef',
);

has 'initialized' => (
    is => 'rw',
    isa => 'Bool',
    default => sub { 0 },
);

sub delete {
    my $self = shift;
    
    return $self->redis->delete( $self->name );
}

sub exists {
    my $self = shift;
    
    return $self->redis->exists( $self->name );
}

sub expires {
    my $self = shift;
    
    return 1 if ! $self->expire;
    
    return $self->redis->expire( $self->name, $self->expire );
}
 
=head1 NAME

Redis::Class::Data

=head1 VERSION

Version 0.0001

=cut

our $VERSION = '0.0001';

=head1 SYNOPSIS

Quick summary of what the module does.

    use Redis::Class;

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

