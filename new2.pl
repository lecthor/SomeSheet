#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent ();
use Getopt::Long;
use Pod::Usage;

use constant {
    UA_TIMEOUT => 20,
};
my @arr;
my $s;
my $st;
my $i;
my $url;
my $response;
my $browser = LWP::UserAgent->new;
my $usr = '';

GetOptions(
    'user=s' => \$usr,
)
or pod2usage(1);

pod2usage(1) unless length($usr);

my $ua = LWP::UserAgent->new();
$ua->timeout( UA_TIMEOUT );
$url="https://api.github.com/users/".$usr."/repos";

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
foreach $i (@arr) {printf "$i\n"};

__END__

=head1 NAME

github user stats scrapper

=head1 SYNOPSIS

screpper.pl [options]

Options:
    --user github_user
=cut