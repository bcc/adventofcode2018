#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);
@data = sort @data;

my (@x, @y);
foreach my $coord (@data) {
    my ($x, $y) = split /, /, $coord;
    push @x, $x;
    push @y, $y;
}
@x = sort { $a <=> $b } @x;
@y = sort { $a <=> $b } @y;

my $minX = $x[0];
my $minY = $y[0];
my $maxX = $x[$#x];
my $maxY = $y[$#y];

my $count;
for ( my $y = $minY; $y <= $maxY; $y++ ) {
    for ( my $x = $minX; $x <= $maxX; $x++ ) {
        # work out distances
        
        my $closest = closest($x, $y, \@data);
        # this assumes there's only a single region, but that seems to be the case here.
        if ($closest < 10000) {
            $count++;
        }
    }
}

say $count;


sub closest($$$) {
    my ($x, $y, $coords) = @_;
    my $result;

    foreach my $c (@$coords) {
        my ($cx, $cy) = split /, /, $c;

        my ($xdiff, $ydiff);
        if ($x < $cx) {
            $xdiff = $cx - $x;
        } else {
            $xdiff = $x - $cx;
        }

        if ($y < $cy) {
            $ydiff = $cy - $y;
        } else {
            $ydiff = $y - $cy;
        }

        $result += ($xdiff + $ydiff);        
    }
    return $result;

}