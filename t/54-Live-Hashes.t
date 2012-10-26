#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Redis::Class' ) || print "Bail out!\n";
}

diag( "Testing Redis::Class $Redis::Class::VERSION, Perl $], $^X" );

# HSET key field value
# Set the string value of a hash field

# HGET key field
# Get the value of a hash field

# HEXISTS key field
# Determine if a hash field exists

# HMSET key field value [field value ...]
# Set multiple hash fields to multiple values

# HMGET key field [field ...]
# Get the values of all the given hash fields

# HGETALL key
# Get all the fields and values in a hash

# HDEL key field [field ...]
# Delete one or more hash fields

# HINCRBY key field increment
# Increment the integer value of a hash field by the given number

# HINCRBYFLOAT key field increment
# Increment the float value of a hash field by the given amount

# HKEYS key
# Get all the fields in a hash

# HLEN key
# Get the number of fields in a hash

# HSETNX key field value
# Set the value of a hash field, only if the field does not exist

# HVALS key
# Get all the values in a hash

