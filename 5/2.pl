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

    my $min = length($line);
    foreach my $c ('a'..'z') {
        my $test = $line;
        say $test . " " . length($test);
        my $pre = $c . "|" . uc($c);

        $test =~ s/($pre)//ge;
        while ( $test =~ s/($remove)//ge ) {
        }
        if (length($test) < $min) {
            $min = length($test);
        }
        say $pre . " " . $test . " " . length($test);
    }
    say $min;
}
