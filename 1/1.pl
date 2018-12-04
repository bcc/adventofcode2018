#!/usr/bin/perl

use strict;

my $start = 0;

while (<>) {
chomp;

$start += $_;

}
print $start . "\n";
