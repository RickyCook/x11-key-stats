#!/usr/bin/perl -w
use strict;
use warnings;

use local::lib;

use WWW::Mechanize;

use constant MIN_WAIT    => 1;
use constant FORM_URL    => 'https://docs.google.com/forms/d/1aVXl6Nzobm3mGYhUUHUeetmm0SM0zSK7GqXVQgwX7RI/viewform';

open(DAT, '-|', './stats.pl -p');

my $last = 0;
while (<DAT>) {
	my $now = time;
	if (($now - $last) >= MIN_WAIT) {
		my ($chr, $wpm) = split /\s/;
	}
	$last = time;
}
close DAT;