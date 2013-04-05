#!/usr/bin/perl -w
use strict;
use warnings;

use Time::HiRes qw(time);

use constant AVG_NUM => 100;

open(KEYS, '-|', './keylogger-X11');

my $keys_to_average_count = 0;
my $avg = 0;
my $last = undef;
while (<KEYS>) {
	my $now = time;
	if (defined $last) {
		my $time_since = $now - $last;
		my $real_avg_num = keys_to_average();
		$avg = (($avg * $real_avg_num) + $time_since) / ($real_avg_num + 1);
		printf "%.3f seconds between keys (average %s)\n", $avg, $real_avg_num;
	} else {
		$keys_to_average_count++;
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
