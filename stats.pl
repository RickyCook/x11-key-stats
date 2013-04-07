#!/usr/bin/perl -w
use strict;
use warnings;

use Time::HiRes qw(time);
use List::MoreUtils qw(none any);

use constant AVG_NUM     => 100;
use constant TOO_LONG    => 2;
use constant WORD_LENGTH => 5;

use constant KEEPALIVE_MATCH => qw(
	BackSpace
);
use constant IGNORED_MATCH => qw(
	Up
	Down
	Left
	Right
	Insert
	Home
	End
	Prior
	Next
	Pause
	Scroll_Lock
	Print
);

my $parseable = defined $ARGV[0] && $ARGV[0] eq '-p';
my $out_message = $parseable ?
	"%.3f %.1f\n" :
	"%.3f seconds between keys = %.1f wpm\n";

$| = 1;

open(KEYS, '-|', './keylogger-X11');

my $keys_to_average_count = 0;
my $avg = 0;
my $last_alive;
my $last_tracked;
while (my $k  = <KEYS>) {
	chomp $k;

	if(any { $k =~ /$_/ } IGNORED_MATCH) {
		if (!$parseable) {
			print "Ignored matched: $k\n";
		}
		next;
	}

	my $now = time;
	my $real_avg_num = keys_to_average();

	if (none { $k =~ /$_/ } KEEPALIVE_MATCH) {
		if (defined $last_alive) {
			my $time_since_alive = $now - $last_alive;
			my $time_since_tracked = $now - $last_tracked;
			if ($time_since_alive < TOO_LONG) {
				$avg = (($avg * $real_avg_num) + $time_since_tracked) / ($real_avg_num + 1);
				my $wpm = 60 / ($avg * WORD_LENGTH);
				printf $out_message, $avg, $wpm;
			}
		}
		$last_tracked = $now;
	} elsif (!$parseable) {
		print "Keepalive matched: $k\n";
	}

	$last_alive = $now;
}
close KEYS;

sub keys_to_average {
	if (AVG_NUM > $keys_to_average_count) {
		return $keys_to_average_count++;
	} else {
		return AVG_NUM;
	}
}
