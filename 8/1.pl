#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);

foreach my $line (@data) {
    my @list = split / /, $line;
    say join ",", @list;

    my $pos = 0;
    my ($p, $m) = do_process(\@list, $pos);
    say "$p, $m";
}

# 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# A----------------------------------
#     B----------- C-----------
#                      D-----

sub do_process {
    my ($list, $pos) = @_;

    my $children = $$list[$pos++];
    my $metadata = $$list[$pos++];

    my $mdsum;

    for (my $c=0; $c<$children; $c++) {
        say "child $c";
        my ($p, $m) = do_process($list, $pos);
        $pos = $p;
        $mdsum += $m;
    }

    for (my $m=$pos; $m<$pos+$metadata; $m++) {
        $mdsum += $$list[$m];
        say "metadata: ", $$list[$m];
    }
    $pos += $metadata;

    return ($pos, $mdsum)

}