#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);

my (@cx, @cy, @vx, @vy);

foreach my $line (@data) {
    # position=< 9,  1> velocity=< 0,  2>

    my ($x, $y, $vx, $vy) = 
        ($line =~ m/position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>/);
    say "$x,$y - $vx,$vy";
    push @cx, $x;
    push @cy, $y;
    push @vx, $vx;
    push @vy, $vy;
}

my $count = 0;
my $triggered = 0;
while () {
    $count++;
    my %sumY;
    for (my $i = 0; $i <= $#cx; $i++) {
        $cx[$i] += $vx[$i];
        $cy[$i] += $vy[$i];
        $sumY{$cy[$i]}++;
        #say "$i $cx[$i],$cy[$i]";
    } 
    my @most = sort { $sumY{$b} <=> $sumY{$a} } keys %sumY;

    if ($sumY{$most[0]} > 14 || $triggered) {
        say "count: $count";
        $triggered = 1;
        sleep 1;
        my $minx = 999999999;
        my $miny = 999999999;
        my $maxx = 0;
        my $maxy = 0;
        for (my $i = 0; $i <= $#cx; $i++) {
            ($minx = $cx[$i]) if ($cx[$i] < $minx);
            ($miny = $cy[$i]) if ($cy[$i] < $miny);
            ($maxx = $cx[$i]) if ($cx[$i] > $maxx);
            ($maxy = $cy[$i]) if ($cy[$i] > $maxy);
        }
        my %render;
        for (my $i = 0; $i <= $#cx; $i++) {
            $cx[$i] -= $minx;
            $cy[$i] -= $miny;
            #say "$cx[$i], $cy[$i]";
            $render{"$cx[$i],$cy[$i]"}=1;

        }
        for (my $y = 0; $y <= ($maxy-$miny); $y++) {
            for (my $x = 0; $x <= ($maxx-$minx); $x++) {
                if ($render{"$x,$y"}) {
                    print "#";
                } else {
                    print " ";
                }
            }
            print "\n";
        }


    }

}