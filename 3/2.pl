#!/usr/bin/perl

use strict;

chomp (my @data = <STDIN>);
my %seen;
my %area;
my %overlapped;

foreach my $line (@data) {
    # #1 @ 1,3: 4x4
    #print $line . "\n";
    my ($id, $sx, $sy, $w, $h) = ($line =~ m/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/);
    $overlapped{$id} = 1;

    foreach my $r (expand_area($sx, $sy, $w, $h)) {
        #print "A: $r\n";
        $seen{$r}++;
        $area{$r}->{$id}++;
    }

}

my $count = 0;
foreach my $k (keys %seen) {
    #print "F: $k $seen{$k}\n";
    if ($seen{$k} > 1) {
        $count++
    }
}
print $count . "\n";

foreach my $k (keys %area) {
    my $h = $area{$k};
    my @a = keys %$h;
    if ($#a >= 1) {
        foreach my $o (keys %$h) {
            delete $overlapped{$o} 
        }
    }
}
use Data::Dumper;
print Dumper \%overlapped;


sub expand_area ($$$$) {
    my @r;
    my ($sx, $sy, $w, $h) = @_;
    for (my $i = 0; $i < $w; $i++) {
        for (my $j = 0; $j < $h; $j++) {
            my $s = (($sx+$i) . "," . ($sy+$j));
            push @r, $s;
        }
    }
    return @r;
}
