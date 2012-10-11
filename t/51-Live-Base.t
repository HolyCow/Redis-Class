#!perl

use Test::More;
use Try::Tiny;
use Data::Dumper;

use Redis::Class;

my $pid = undef;

my $redis_pm = try {
    require Redis;
    1;
};

if ( ! $ENV{'REDIS_TEST_HOST'} && ! $ENV{'REDIS_TEST_PORT'} && $redis_pm ) {
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

my $redis = Redis->new( server => $ENV{'REDIS_TEST_HOST'} . ':' . $ENV{'REDIS_TEST_PORT'} );

my $redis_class = undef;

isa_ok( $redis_class = Redis::Class->new( $ENV{'REDIS_TEST_HOST'} . ':' . $ENV{'REDIS_TEST_PORT'} ), 'Redis::Class' );

is( $redis_class->host, $ENV{'REDIS_TEST_HOST'}, 'Hostname correct' );
is( $redis_class->port, $ENV{'REDIS_TEST_PORT'}, 'Port correct' );

isa_ok( $redis_class = Redis::Class->new( $ENV{'REDIS_TEST_HOST'} ), 'Redis::Class' );

is( $redis_class->host, $ENV{'REDIS_TEST_HOST'}, 'Hostname correct' );
is( $redis_class->port, '6379', 'Port correct' );

isa_ok( $redis_class = Redis::Class->new({ host => $ENV{'REDIS_TEST_HOST'}, port => $ENV{'REDIS_TEST_PORT'} }), 'Redis::Class' );

is( $redis_class->host, $ENV{'REDIS_TEST_HOST'}, 'Hostname correct' );
is( $redis_class->port, $ENV{'REDIS_TEST_PORT'}, 'Port correct' );

ok( $redis_class->redis, 'Connects to Redis server' );

END{
    kill 9, $pid if $pid;
}

done_testing();


