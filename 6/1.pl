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

my %infinite;
my %count;
for ( my $y = $minY; $y <= $maxY; $y++ ) {
    for ( my $x = $minX; $x <= $maxX; $x++ ) {
        # work out distances
        
        my $closest = closest($x, $y, \@data);
        $count{$closest}++;
        #say "$x, $y, ", $closest;

        # establish 'infinite' areas
        if ( $closest && (($x == $minX) || ($x == $maxX)
             || ($y == $minY) || ($y == $maxY)) ) {
            $infinite{$closest}++
        }
    }
}

my @best = sort { $count{$b} <=> $count{$a} } keys %count; 
foreach my $b (@best) { 
    if ($infinite{$b}) {
        next;
    } else {
        say "$b $count{$b}";
        exit;
    }
}


sub closest($$$) {
    my ($x, $y, $coords) = @_;
    my %result;

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

        $result{$c} = ($xdiff + $ydiff);        
    }

    my @best = sort { $result{$a} <=> $result{$b} } keys %result; 
    if ($result{$best[0]} == $result{$best[1]}) {
        return undef;
    } else {
        return $best[0];
    }

}