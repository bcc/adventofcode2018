#!/usr/bin/perl

use strict;

chomp (my @data = <STDIN>);

my ($ck2, $ck3);
foreach my $w (@data) {
	my ($r2, $r3) = checksum($w);
	#print "$r2, $r3\n";
	$ck2 += $r2;
	$ck3 += $r3;
}
print $ck2 * $ck3 . "\n";


sub checksum {
	my $word = shift;
	
	my %seen;
	foreach my $letter (split //, $word) {
		$seen{$letter}++
	}

	my $twos = 0;
	my $threes = 0;
	foreach my $k (keys %seen) {
		# print "$k $seen{$k}\n";
		$twos=1 if ($seen{$k} == 2);
		$threes=1 if ($seen{$k} == 3);
	}

	return ($twos, $threes);

}
