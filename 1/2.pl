#!/usr/bin/perl

use strict;

my $freq = 0;
my %seen;

chomp (my @data = <STDIN>);

while () {
	foreach (@data) {
		$freq += $_;
		if ($seen{$freq} == 1) {
			print $freq . "\n";
			exit;
		}
		$seen{$freq}++;
	}
}
