#!/usr/bin/env perl

use strict;
use warnings;

use LWP::UserAgent ();
use Getopt::Long;
use Pod::Usage;

use constant {
    UA_TIMEOUT => 20,
	Offset=>12,
};

my $usr = '';
my @Repos='';
	

GetOptions(
    'user=s' => \$usr,
)
or pod2usage(1);

pod2usage(1) unless length($usr);

my $url = "https://api.github.com/users/$usr/repos";
my $ua  = LWP::UserAgent->new();

$ua->timeout( UA_TIMEOUT );


my $response = $ua->get( $url );

die "Can't get $url -- ", $response->status_line
unless $response->is_success;

my $UnparsedRepo=$response->content;
my $i=0;
while ($i<length($UnparsedRepo)-Offset){
	my $ParsedRepo='';
	if (substr ($UnparsedRepo,$i,10) eq 'full_name"'){
		$i=$i+Offset;
		while (substr($UnparsedRepo,$i,1) ne '"') {
		$ParsedRepo=$ParsedRepo.substr($UnparsedRepo,$i++,1);
		}
	push (@Repos, $ParsedRepo);
	}
	++$i;
}
foreach $i (@Repos){printf "$i\n"};
__END__

=head1 NAME

github user stats scrapper

=head1 SYNOPSIS

screpper.pl [options]

Options:
    --user=github_user
=cut
