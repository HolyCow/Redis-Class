#!perl

use Test::More;

BEGIN {
    use_ok( 'Redis::Class' ) || print "Bail out!\n";
}

diag( "Testing Redis::Class $Redis::Class::VERSION, Perl $], $^X" );


use Redis;
use Data::Dumper;

my $pid = fork();
if (defined $pid && $pid == 0) {
    # child
    exec('redis-server t/testing_files/redis.conf');
    exit 0;
}

sleep 5;

my $redis = Redis->new( server => '127.0.0.1:6380' );

my $redis_class = Redis::Class->new({
    redis_server => $redis,
});


END{
    kill 9, $pid;
}

done_testing();


