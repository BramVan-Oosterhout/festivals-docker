#!/usr/bin/perl
use warnings;
use strict;

use Data::Dump qw(dump);

my @files = qw( festivals-website festivals-gateway 
                festivals-identity-server festivals-server
                festivals-fileserver festivals-database );

foreach my $file (@files) {
    extract_routes($file);
}
exit;

sub extract_routes {
    my ( $file ) = @_;
    print  "\n## $file\n";

    $file = '/home/bram/programs/Festivals-App-Sources/'
            . $file .'/server/server.go';
    my $pattern = '(?:\sr|\.Router)\.([^(]+)\("([^"]+)'
            . '.*?handler\.([^)]+)';
    open my $INPUT, "<", $file or die "Can't open $file for read: $!";
    while ( <$INPUT> ) {
        if ( $_ =~ m!$pattern! ) {
            my $uc = uc($1);
            print "| $uc | $2 | $3 |\n"
        }
    }
    close $INPUT;
}