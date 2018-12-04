#!/usr/bin/perl

use strict;

chomp (my @data = <STDIN>);

foreach my $w (@data) {
	print checksum($w, @data);
}



sub checksum ($@) {
	my $word = shift;
	my @list = @_;

	my @word = split //, $word;
	
	foreach my $w (@list) {
		
		my @w = split //, $w;
		# word lengths are all equal.

		my $diff = 0;
		my $common;
		for (my $i = 0; $i <= $#word; $i++) {
			if ($word[$i] ne $w[$i]) {
				$diff++
			} else {
				$common .= $w[$i];
			}
		}
		if ($diff == 1) {
			print "$word, $w, $diff, $common\n";
			exit;
		}

	}

}
