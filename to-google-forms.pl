#!/usr/bin/perl -w
use strict;
use warnings;

use local::lib;

use LWP::UserAgent;
use Time::Format qw(%time);

use constant MIN_KEYS       => 100;
use constant FORM_URL       => 'https://docs.google.com/forms/d/1aVXl6Nzobm3mGYhUUHUeetmm0SM0zSK7GqXVQgwX7RI/formResponse';
use constant TIMESTAMP_NAME => 'entry.500527300';
use constant WPM_NAME       => 'entry.2080196239';

open(DAT, '-|', './stats.pl -p');

my $keys = 0;
while (<DAT>) {
	my $now = time;
	if ($keys >= MIN_KEYS) {
		my ($chr, $wpm) = split /\s/;
		submit("$time{'yyyy/mm/dd hh:mm:ss', $now}", $wpm);
		$keys = 0;
	} else {
		$keys++;
	}
}
close DAT;

sub submit {
	my ($timestamp, $wpm) = @_;

	my %form = (
		TIMESTAMP_NAME() => $timestamp,
		WPM_NAME()       => $wpm,
	);
	my $ua       = LWP::UserAgent->new();
	my $response = $ua->post(FORM_URL, Content => \%form);
	if ($response->is_error) {
		printf STDERR
			"HTTP error '%s' while submitting data\n",
			$response->status_line;
		return 0;
	} else {
		printf "Submitted WPM of %s at %s\n", $wpm, $timestamp;
	}
	return 1;
}