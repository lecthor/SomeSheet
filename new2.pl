#!/usr/bin/env perl

use strict;
use warnings;
use feature 'postderef';
no warnings qw(experimental::postderef);

use LWP::UserAgent ();
use Getopt::Long;
use Pod::Usage;
use Try::Tiny;
use JSON;

use constant {
    REQUEST_TIMEOUT => 20,
};

my $usr = '';

GetOptions(
    'user=s' => \$usr,
)
or pod2usage(1);

pod2usage(1) unless length($usr);

my $url = "https://api.github.com/users/$usr/repos";
my $ua  = LWP::UserAgent->new();

$ua->timeout( REQUEST_TIMEOUT );

my $response = $ua->get( $url );

die "Can't get $url -- ", $response->status_line
unless $response->is_success;

my $repos;

try {
    $repos = from_json $response->content;
}
catch {
    die "Can't parse json string: $_";
};

foreach my $repo ( $repos->@* ) {
    print "$repo->{name}\n";
}

__END__

=head1 NAME

github user stats scrapper

=head1 SYNOPSIS

screpper.pl [options]

Options:
    --user=github_user
=cut
