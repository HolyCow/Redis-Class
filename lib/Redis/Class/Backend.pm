package Redis::Class::Backend;

use 5.006;
use strict;
use warnings;

use Moose;
use namespace::autoclean;

use Carp;
use Try::Tiny;

has 'backend' => (
    is => 'rw',
    isa => 'Str',
);

has 'host' => (
    is => 'rw',
    isa => 'Str',
);

has 'port' => (
    is => 'rw',
    isa => 'Int',
);

has 'socket' => (
    is => 'rw',
    isa => 'Str',
);

has 'redis' => (
    is => 'rw',
    lazy_build => 1,
);

has 'backends' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub {
        [ 'Redis', 'RedisDB' ]
    },
);

sub _build_redis {
    my $self = shift;
    
    my $backend = undef;
    
    if ( $self->backend ) {
        $backend = $self->backend;
        eval "require $backend" or croak( "Specified module $backend cannot be found" );
    } else {
        foreach my $redis_module ( @{ $self->backends } ) {
            next if $backend;
            
            eval "require $redis_module" or next;
            
            $backend = $redis_module;
        }
    }
    
    croak ( 'No supported Redis modules found. Searched for ' . join ', ',  @{ $self->backends } )
        if ! $backend;
        
    my $backend_class = "Redis::Class::Backend::$backend";
    
    eval "require $backend_class" or croak( 'Redis module ' . $backend . ' found but ' . $backend_class . ' not loaded' );
    
    my $eval_string = "$backend_class->new({";

    $eval_string .= " host => '" . $self->host . "'," if $self->host;
    $eval_string .= " port => '" . $self->port . "'," if $self->port;
    
    $eval_string .= "})";

    eval $eval_string or croak( 'Could not create backend object' );
}

=head1 NAME

Redis::Class::Backend - Determines backend to use for Redis::Class

=head1 VERSION

Version 0.0001

=cut

our $VERSION = '0.0001';


=head1 SYNOPSIS


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
