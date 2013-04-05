#!/usr/bin/perl -w
use strict;
use warnings;

use Time::HiRes qw(time);

use constant AVG_NUM     => 100;
use constant TOO_LONG    => 2;
use constant WORD_LENGTH => 5;

open(KEYS, '-|', './keylogger-X11');

my $keys_to_average_count = 0;
my $avg = 0;
my $last = undef;
while (<KEYS>) {
	my $now = time;
	my $real_avg_num = keys_to_average();
	if (defined $last) {
		my $time_since = $now - $last;
		if ($time_since < TOO_LONG) {
			$avg = (($avg * $real_avg_num) + $time_since) / ($real_avg_num + 1);
			my $wpm = 60 / ($avg * WORD_LENGTH);
			printf "%.3f seconds between keys = %.1f wpm\n", $avg, $wpm;
		}
	}
	$last = $now;
}
close KEYS;

sub keys_to_average {
	if (AVG_NUM > $keys_to_average_count) {
		return $keys_to_average_count++;
	} else {
		return AVG_NUM;
	}
}
