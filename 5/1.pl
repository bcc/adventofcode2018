#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);
@data = sort @data;

foreach my $line (@data) {
    say $line;
    my @line = split //, $line;

    my $pos = 0;
    say $pos, "/", $#line;
    while ( $pos < $#line ) {

        if  (($line[$pos] =~ m/[A-Z]/) && ( lc($line[$pos]) eq $line[$pos+1] ) 
                || ($line[$pos] =~ m/[a-z]/) && ( uc($line[$pos]) eq $line[$pos+1] ))  {
            
            #say "Cancelling ", $line[$pos], $line[$pos+1];

            # Urgh, this is slow. 
            if ($pos > 0) {
                @line = (@line[ 0..$pos-1 ], @line[ $pos+2 .. $#line ]);
            } else {
                @line = @line[ $pos+2 .. $#line ];
            }
            $pos--;

        } else {
            $pos++;
        }
    }
    say join("", @line);
    print ($#line + 1);
}
