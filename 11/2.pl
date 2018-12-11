#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

my $serial = $ARGV[0];
my $maxsize = 300;

my @sat = get_grid($serial);

# calculate summed area table
for (my $y=0; $y < $maxsize; $y++) {
    for (my $x=0; $x < $maxsize; $x++) {

        my $tmp = $sat[$y][$x];

        if (($y > 0) && ($x > 0)) {
            $tmp -= $sat[$y-1][$x-1];
        }
        if ($y > 0) {
            $tmp += $sat[$y-1][$x];
        }
        if ($x > 0) {
            $tmp += $sat[$y][$x-1];
        }
        
        $sat[$y][$x] = $tmp;
    }
}

my $biglytotal = -9999;
my $coords;
my $maxgs;

for (my $gridsize=1; $gridsize < 300; $gridsize++) {
    for (my $y=0; $y < ($maxsize-$gridsize); $y++) {
        for (my $x=0; $x < ($maxsize-$gridsize); $x++) {
            my $total = get_total(\@sat, $x, $y, $gridsize);
            if ($total > $biglytotal) {
                $biglytotal = $total;
                $coords = "result:" . ($x+2) . "," . ($y+2);
                $maxgs = $gridsize;
            }
        }
    }
}
say $coords, ",", $maxgs;


sub get_total {
    my ($table, $x, $y, $gridsize) = @_;

    return $$table[$y+$gridsize][$x+$gridsize] + $$table[$y][$x]
        - $$table[$y][$x+$gridsize] - $$table[$y+$gridsize][$x];

}

sub get_grid ($) {
    my $serial = shift;

    my @grid;
    foreach my $y (1..300) {
        my @x;
        foreach my $x (1..300) {
            my $pl = ((($x+10)*$y)+$serial)*($x+10);
            $pl = (($pl / 100) % 10)-5;
            push @x, $pl;

        }
        push @grid, \@x
    }
    return @grid;
}
