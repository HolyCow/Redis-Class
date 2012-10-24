#!perl

use Test::More;
use Try::Tiny;
use File::Slurp;

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

my $conf_template = read_file( 't/testing_files/redis.conf' );

$conf_template =~ s{%%HOST%%}{$ENV{'REDIS_TEST_HOST'}};
$conf_template =~ s{%%PORT%%}{$ENV{'REDIS_TEST_PORT'}};

write_file( 't/testing_files/redis-test.conf', $conf_template );

$pid = fork();
if ( defined $pid && $pid == 0 ) {
    # child
    exec('redis-server t/testing_files/redis-test.conf');
    exit 0;
}

sleep 5;

my $redis_class = undef;

isa_ok( $redis_class = Redis::Class->new( $ENV{'REDIS_TEST_HOST'} . ':' . $ENV{'REDIS_TEST_PORT'} ), 'Redis::Class' );

my $key = $redis_class->key( 'TestString' );

# EXISTS key
# Determine if a key exists

is( $key->exists, undef, 'Key does not exist because it has not been set' );

$key->redis->set( 'TestString', 'TestValue' );

is( $key->exists, 1, 'Key does exist' );

# DEL key [key ...]
# Delete a key

ok( $key->delete, 'Key delete successful' );

is( $key->exists, undef, 'Key does not exist because we deleted it' );

# DUMP key
# Return a serialized version of the value stored at the specified key.
# 2.6.0

#EXPIRE key seconds
#Set a key's time to live in seconds

$key->redis->set( 'TestString', 'TestValue' );

ok( $key->expire( 600 ), 'Expire set without error' );

#TTL key
#Get the time to live for a key

cmp_ok( $key->ttl, '<=',  600, 'Expire is within limits' );
cmp_ok( $key->ttl, '>',  0, 'Expire is within limits' );

#EXPIREAT key timestamp
#Set the expiration for a key as a UNIX timestamp

#PERSIST key
#Remove the expiration from a key

ok( $key->persist, 'Expire removed' );

is( $key->ttl, undef, 'No TTL set now' );

$key->expire( 600 );

ok( $key->expire( 0 ), 'Expire set to zero successfully' );

is( $key->ttl, undef, 'No TTL set now' );

#PEXPIRE key milliseconds
#Set a key's time to live in milliseconds

#PEXPIREAT key milliseconds-timestamp
#Set the expiration for a key as a UNIX timestamp specified in milliseconds

#PTTL key
#Get the time to live for a key in milliseconds

#RENAMENX key newkey
#Rename a key, only if the new key does not exist

#TYPE key
#Determine the type stored at key

is( $key->type, 'string', 'Type is string' );

END{
    kill 9, $pid if $pid;
}

done_testing;

END{
    unlink 't/testing_files/redis-test.conf' if -e 't/testing_files/redis-test.conf';
}

