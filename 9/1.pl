#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

my $players = $ARGV[0];
my $score = $ARGV[1];
say "players: $players, score: $score";

my $marble = 0;
my $currentplayer = 0;
my $currentpos = 0;
my @board;
my %score;

# the splice approach isn't efficient, but it's fine for part 1.
# it takes a couple of hours to solve part 2, but I was short of time to rewrite...

while ($marble <= $score) {
    if ($marble > 0 && ($marble % 23 == 0)) {
        $score{$currentplayer} += $marble;
        $currentpos = $currentpos - 8;
        if ($currentpos < 0) {
            $currentpos += (scalar @board);
        }
        #say "KEEP $currentplayer $marble ", $board[$currentpos];
        $score{$currentplayer} += $board[$currentpos];
        splice(@board,$currentpos,1);
        $currentpos = ($currentpos+1) % (scalar @board);
    } else {
        splice(@board, $currentpos+1, 0, $marble);
        
        $currentpos = ($currentpos+2) % (scalar @board);
    }
    $marble++;
    
    
    #say "player: $currentplayer, pos: $currentpos, board: ", join ",", @board;


    $currentplayer = ($currentplayer + 1) % $players;
}
say Dumper \%score;
my @keys = sort { $score{$b} <=> $score{$a} } keys %score;
say $score{$keys[0]};
