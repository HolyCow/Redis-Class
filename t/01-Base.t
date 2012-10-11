#!perl -T

use Test::More;

use Redis::Class;
use Redis::Class::Backend;



isa_ok( Redis::Class::Backend->new()->redis, 'Redis::Class::Backend::Redis' );

isa_ok( Redis::Class::Backend->new({ backend => 'Redis' })->redis, 'Redis::Class::Backend::Redis' );

#isa_ok( Redis::Class::Backend->new({ backend => 'RedisDB' })->redis, 'Redis::Class::Backend::RedisDB' );



done_testing;

