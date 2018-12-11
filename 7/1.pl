#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

chomp (my @data = <STDIN>);

my %deps;
my %steps;
foreach my $line (sort @data) {
    my ($dep, $step) = ($line =~ /Step (\S+) must be finished before step (\S+) can begin\./);
    say "$dep, $step";
    if (exists $deps{$step}) {
        my $t =  $deps{$step};
        push @$t, $dep;
        $deps{$step} = $t;
    } else {
        my @add = ($dep);
        $deps{$step} = \@add;
    }
    $steps{$dep}=0;
    $steps{$step}=0;
}

my @final;
while (my @doable = find_nextsteps(\%deps) )  {
    my $first = $doable[0];
    mark_complete($first, \%deps);
    push @final, $first;
}

say join "", @final;


sub mark_complete {
    my ($step, $deps) = @_;

    # complete task.
    $steps{$step} = 1;
    # remove from dep list.
    foreach my $s (sort keys %$deps) {
        my @tasks = @{$$deps{$s}};
        @tasks = grep {!/$step/} @tasks;
        if ($#tasks > -1) {
            $$deps{$s} = \@tasks;
        } else {
            delete $$deps{$s};
        }
    }
}

sub find_nextsteps {
    my ($deps) = @_;

    # find next.
    my @doable;
    foreach my $s (sort keys %steps) {
        next if ($steps{$s} == 1);
        if (!$$deps{$s}) {
            push @doable, $s;
        }
    }

    return sort @doable;
}