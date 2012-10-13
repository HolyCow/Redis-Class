#!perl -T

use Test::More;
use Test::Exception::LessClever;

use Redis::Class;
use Redis::Class::Backend;



isa_ok( Redis::Class::Backend->new()->redis, 'Redis::Class::Backend::Redis' );

isa_ok( Redis::Class::Backend->new({ backend => 'Redis' })->redis, 'Redis::Class::Backend::Redis' );

#this is not going to work if RedisDB is installed
throws_ok { Redis::Class::Backend->new({ backend => 'RedisDB' })->redis } qr{Specified module RedisDB cannot be found at accessor}, 'Module could not be loaded';



done_testing;

