#!/usr/bin/perl

use strict;
use v5.10;
use Data::Dumper;

my $timeoffset = 60;
my $workers = 5;

# set up time delay...
my %time;
foreach my $n ('A'..'Z') {
    $time{$n} = $timeoffset + ord($n)-64;
}

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

my %workercurrent;
my %workertime;

my $totaltime = 0;
while ( !check_complete() )  {

    my @doable = find_nextsteps(\%deps);

    foreach my $w (1...$workers) {
        say "worker $w, $workercurrent{$w} $workertime{$w}";

        if ($workertime{$w} <= 1 && $workercurrent{$w}) {
           mark_complete($workercurrent{$w}, \%deps);
           push @final, $workercurrent{$w};
           $workercurrent{$w} = undef;
        }

        if (!$workercurrent{$w}) {
                if (my $next = pop @doable) {
                    say "adding... w:$w t:$next";
                    $steps{$next} = 2;
                    $workercurrent{$w} = $next;
                    $workertime{$w} = $time{$next};
                }
        }
        $workertime{$w}--;
    }
    $totaltime++;
    
}
say join "", @final;
say $totaltime;

sub check_complete {
    foreach my $k (keys %steps) {
        say "check: $k $steps{$k}";
        if ($steps{$k} != 1) {
            return 0;
        }
    }
    return 1;
}

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
        next if ($steps{$s} > 0);
        if (!$$deps{$s}) {
            push @doable, $s;
        }
    }

    return sort @doable;
}