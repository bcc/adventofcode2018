#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);
@data = sort @data;

my %sleeps;
my %most;
my $currentguard = -1;
my $sleeptime = -1;

foreach my $line (@data) {
    say $line;
    if ( my ($date, $hour, $min, $guard) = 
        ($line =~ 
        m/\[(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})\] Guard #(\d+) begins shift/) ) {
            $currentguard = $guard;
        }
    elsif ( my ($date, $hour, $min) = 
        ($line =~ 
        m/\[(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})\] falls asleep/) ) {
            $sleeptime = $min;
        }
    elsif ( my ($date, $hour, $min) = 
        ($line =~ 
        m/\[(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})\] wakes up/) ) {
            foreach my $mt ($sleeptime .. $min-1) {
                $sleeps{$currentguard}->{$mt}++;
                $most{$currentguard}++;
            }
        }
    else {
        say "no match"
    }
}

my @most = sort { $most{$b} <=> $most{$a} } keys %most; 
say $most[0] . " most, with " . $most{$most[0]};

my $result = $sleeps{$most[0]};
my @best = sort { $$result{$b} <=> $$result{$a} } keys %$result; 

say $best[0] . " best minute";
say ($best[0] * $most[0]);