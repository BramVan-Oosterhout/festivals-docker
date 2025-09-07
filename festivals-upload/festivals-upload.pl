#!/usr/bin/perl
use warnings;
use strict;

use Data::Dump qw(dump);
use Spreadsheet::Read;
use lib '.';
use FestivalsAgent;

my $fa = FestivalsAgent->new('festivals-gateway');

my $fileName = '/home/bram/programs/Festivals-App/festivals-docker/festivals-upload/Test001.ods';

my $spreadsheetMap = spreadsheet_mapping();
my $wb = Spreadsheet::Read->new( $spreadsheetMap->{workbook} );
my $a = upload_artists( $wb, $fa, $spreadsheetMap->{artists} );
exit;

my $locations = post_objects( $wb, $fa, 'Locations' );
#print 'LOCATIONSS: ',dump($locations), "\n===\n";

my $artists = post_objects( $wb, $fa, 'Artists' );
#print 'ARTISTS: ',dump($artists), "\n===\n";
exit;

sub upload_artists {
    my ( $wb, $fa, $map ) = @_;

    my @sheets = $wb->sheets();
    my $ss = $wb->sheet("Artists");

    my $fields = get_column_numbers($ss, $map->{columns});
    #print 'FIELDS: ', dump($fields), "\n";
    my %allTags = ();
    foreach my $tag ( @{$fa->get_url( '/tags' )->{data}} ) {
        $allTags{$tag->{tag_name}} = $tag->{tag_id};
    }
    #print 'TAGSHASHED: ', dump(%allTags), "\n";

    for ( my $r = 2; $r <= $ss->maxrow; $r++ ) {
my $counter = ($r % 10) ? '.' : '+';
print $counter;

        my %dbArtist = ();
        my @artistTag = ();
        my @artistImage = ();

        my @row = $ss->cellrow($r);
        #print 'ROW: ', join('#', @row). "\n";
        # First loop to get artist detail
        # post artist and get ref number
        # 2. Loop for the rest and create (if necessary - tags may exist)
        # post the associations with the artist

        while( my ($k, $v) = each %{$map->{columns}} ) {
            $dbArtist{$v}= $row[$fields->{$k}]
                             unless ( $v =~ m!\A#! ) ;
        }
        my $artist = $fa->new_post_object( \%dbArtist, '/artists' )->{data}[0];
        while( my ($k, $v) = each %{$map->{columns}} ) {
           if ( $v eq '#tag' ) {
                next unless $row[$fields->{$k}];
                my $tag = $k . '::' . $row[$fields->{$k}];
                push @artistTag, {'tag_name' => $tag };
                next;
            }
            if ( $v eq '#imageurl' ) {
                push @artistImage, { image_ref =>  $row[$fields->{$k}],
                                     image_comment => $dbArtist{artist_name}};
                next;
            }
        }
#print 'DBARTIST: ', dump(%dbArtist), "\n";
#print 'artistTag: ', dump(@artistTag), "\n";
#print 'ARTISTIMAGE: ', dump(@artistImage), "\n";

        if ( scalar @artistTag ) {
            add_tags_and_associate( $fa, $artist->{artist_id}, \@artistTag, \%allTags );
        }
        if ( scalar @artistImage ) {
            add_image_url_and_associate( $fa, $artist->{artist_id}, \@artistImage );
        }
    }
}

sub add_image_url_and_associate {
    my ( $fa, $artist_id, $artistImage ) = @_;

    foreach my $i ( @$artistImage) {
        my $image = $fa->new_post_object( $i, '/images' )->{data}[0]; 
        #print 'IMAGE:_', dump($image), "\n";
        my $associationEndpoint =join '/', 'artists', $artist_id, 
                                           'image', $image->{image_id}; 
        #print "ENDPOINT: ", $associationEndpoint, "\n"; 
        my $a = $fa->new_post_object( {}, '/'.$associationEndpoint );
        #print 'ASSOCIATION: ', dump($a), "\n";

    }
}

sub add_tags_and_associate {
    my ($fa, $artist_id, $artistTag, $allTags ) = @_;
    #print "ARTISTID: $artist_id\nartistTag: ", dump($artistTag), "\n";
    my %associations = ();
    my $associationEndpoint;
    foreach my $t ( @$artistTag ) {
#print 'USING TAG: ', dump($t), ' with alltags(t)- ', $allTags->{$t->{tag_name}}, "\n";
        if ( $allTags->{$t->{tag_name}} ) {
            $associationEndpoint = join '/', 'artists', $artist_id, 
                                             'tags', $allTags->{$t->{tag_name}};
#print "Found alltags t: $t = ",$allTags->{$t->{tag_name}},"\n    with endpoint: $associationEndpoint\n";

        } else {
#print 'POSTING new object: ', dump($t), "\n";
            my $tag = $fa->new_post_object( $t, '/tags' )->{data}[0]; 
#print 'TAG: ', dump($tag), "\n";
#print 'TAGNAME: ',$tag->{tag_name}, "\n";
#print 'TAGID: ',$tag->{tag_id}, "\n";
            $allTags->{"$tag->{tag_name}"} = $tag->{tag_id};
            $associationEndpoint = join '/', 'artists', $artist_id, 
                                             'tags', $tag->{tag_id}; 

#print "New tag t: ", dump($t),"\n    with endpoint: $associationEndpoint\n";

        }
        my $a = $fa->new_post_object( {}, '/'.$associationEndpoint );
        #print 'ASSOCIATION: ', dump($a), "\n";
    } 

}

sub get_column_numbers {
    my ($ss, $map ) = @_;
    my %columnNumber;
    my @header = $ss->cellrow(1);

    for ( my $c = 0; $c < scalar @header; $c++ ) {
        if ( exists $map->{$header[$c]}) {
            $columnNumber{$header[$c]} = $c;
        }
    }
    return \%columnNumber;
}

sub post_objects {
    my ($wb, $fa, $objects ) = @_;
    my $ss = $wb->sheet($objects);
    my %object_hash;
    my $object = lc($objects);
    chop($object);
    my $fields = get_collumn_names( $ss );
    #print 'FIELDS: ', dump($fields), "\n";

    for ( my $r = 2; $r <= $ss->maxrow; $r++ ) {
        my $object_data = get_row_data($ss, $r);
        my $response = $fa->post_object( $object_data,
                                         '/'.lc($objects),
                                         $object.'_' )->{data}[0];;
        #print 'RESPONSE: ', dump($response), "\n";
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

sub spreadsheet_mapping {
    my $map = {
        workbook => 'prepArtists2023.ods',
        artists => {
            sheet => 'Artists',
            columns => {
                name => 'artist_name',
                description => 'artist_description',
                image_url => '#imageurl',
                featured => '#tag',
                status => '#tag',
                category => '#tag'
            }
        }
     };
     return $map;
}
__END__
