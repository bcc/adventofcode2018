#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);
@data = sort @data;

my @remove;
foreach my $c ('a'..'z') {
    push @remove, ($c . uc($c)), (uc($c) . $c);
}
my $remove = join("|", @remove);

foreach my $line (@data) {
    say $line;

    while ( $line =~ s/($remove)//ge ) {

    }
    say $line . " " . length($line);
}
