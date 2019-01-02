#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
my @arr;
my $s;
my $st;
my $i;
my $url;
my $response;
my $username="arthurnn";
my $browser = LWP::UserAgent->new;
$url="https://api.github.com/users/".$username."/repos";

$response = $browser->get( $url );
die "Can't get $url -- ", $response->status_line
unless $response->is_success;
$s=$response->content;
$i=0;
while ($i<length($s)-13){
	$st='';
		if (substr ($s,$i,10) eq 'full_name"'){
		$i=$i+12;
		while (substr($s,$i,1) ne '"') {
		$st=$st.substr($s,$i++,1);
		}
	push (@arr, $st);
	}
	++$i;
}