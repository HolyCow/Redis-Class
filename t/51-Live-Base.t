#!perl

use Test::More;
use Redis;
use Data::Dumper;

use Redis::Class;

my $pid = undef;

if ( ! $ENV{'REDIS_LIVE'} ) {
    plan skip_all => 'Live Redis test';
    done_testing;
    exit;
}

$pid = fork();
if ( defined $pid && $pid == 0 ) {
    # child
    exec('redis-server t/testing_files/redis.conf');
    exit 0;
}

sleep 5;

my $redis = Redis->new( server => '127.0.0.1:6380' );

my $redis_class = Redis::Class->new({
    redis_server => $redis,
});

ok(1);

END{
    kill 9, $pid if $pid;
}

done_testing();


