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

my $locations = post_objects( $wb, $fa, 'Locations' );
print 'LOCATIONSS: ',dump($locations), "\n===\n";

my $artists = post_objects( $wb, $fa, 'Artists' );
print 'ARTISTS: ',dump($artists), "\n===\n";
exit;

sub post_objects {
    my ($wb, $fa, $objects ) = @_;
    my $ss = $wb->sheet($objects);
    my %object_hash;
    my $object = lc($objects);
    chop($object);
    my $fields = get_collumn_names( $ss );
    print 'FIELDS: ', dump($fields), "\n";

    for ( my $r = 2; $r <= $ss->maxrow; $r++ ) {
        my $object_data = get_row_data($ss, $r);
        my $response = $fa->post_object( $object_data,
                                         '/'.lc($objects),
                                         $object.'_' )->{data}[0];;
        print 'RESPONSE: ', dump($response), "\n";
        $object_hash{$response->{$object.'_name'}} = $response->{$object.'_id'};
    }
    return \%object_hash;
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
__END__
