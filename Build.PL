use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Redis::Class',
    license             => 'perl',
    dist_author         => q{Mike Beasterfeld <mike.beasterfeld@gmail.com>},
    dist_version_from   => 'lib/Redis/Class.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
        'Moose' => 0,
        'namespace::autoclean' => 0,
    },
    add_to_cleanup      => [ 'Redis-Class-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
