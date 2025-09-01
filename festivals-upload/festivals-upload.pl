#!/usr/bin/perl
use warnings;
use strict;

use Data::Dump qw(dump);
use Spreadsheet::Read;
use lib '.';
use FestivalsAgent;

my $fa = FestivalsAgent->new('festivals-gateway');

my $fileName = '/home/bram/programs/Festivals-App/festivals-docker/festivals-upload/Test001.ods';

my $wb = Spreadsheet::Read->new( $fileName );

my $locations = post_locations( $wb, $fa );
print 'LOCATIONS: ',dump($locations), "\n===\n";

sub post_locations {
    my ( $wb, $fa ) = @_;
    my $ss = $wb->sheet("Locations");
    my %locations;
    my $fields = get_collumn_names( $ss );

    for ( my $r = 2; $r <= $ss->maxrow; $r++ ) {
        my $location = get_row_data($ss, $r);
        my $response = $fa->post_location( $location )->{data}[0];;
        #print 'RESPONSE: ', dump($response), "\n";
        $locations{$response->{location_name}} = $response->{location_id};
    }
    return \%locations;
}

sub get_row_data {
    my ( $ss, $index ) = @_;
    my $fields = get_collumn_names( $ss );
    my @row = $ss->cellrow( $index );
    #print dump(@row), "\n";

    my %row_data;

    while ( my ($name, $collumnNumber) = each %$fields ) {
        $row_data{$name} = $row[$collumnNumber];
    }
    #print dump(%row_data), "\n";
    return \%row_data;
}

sub get_collumn_names {
    my ( $ss ) = @_;

    my %names;
    my @row = $ss->cellrow(1);
    for ( my $i = 0; $i < scalar @row; $i++ ) {
        $names{$row[$i]} = $i;
    }
    return \%names;
}