#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

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

#122,79, grid serial number 57: power level -5.
#my @grid=get_grid(57);
#say $grid[78][121];

#217,196, grid serial number 39: power level  0.
#@grid=get_grid(39);
#say $grid[195][216];

#101,153, grid serial number 71: power level  4.
#@grid=get_grid(71);
#say $grid[152][100];
my $serial = $ARGV[0];
my @grid = get_grid($serial);

my $biglytotal = -9999;
my $coords;
for (my $y=2; $y < 299; $y++) {
    for (my $x=2; $x < 299; $x++) {
        my $total = $grid[$y-1][$x-1] + $grid[$y-1][$x] + $grid[$y-1][$x+1] + 
                    $grid[$y][$x-1] + $grid[$y][$x] + $grid[$y][$x+1] + 
                    $grid[$y+1][$x-1] + $grid[$y+1][$x] + $grid[$y+1][$x+1];
        if ($total > $biglytotal) {
            $biglytotal = $total;
            $coords = "$x,$y";
        }
    }
}
say $coords;


