#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Redis::Class' ) || print "Bail out!\n";
}

diag( "Testing Redis::Class $Redis::Class::VERSION, Perl $], $^X" );
