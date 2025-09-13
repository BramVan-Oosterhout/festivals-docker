#!/usr/bin/perl
use warnings;
use strict;

use Data::Dump qw(dump);
use Spreadsheet::Read;
use lib '.';
use FestivalsAgent;
use Time::Piece;
use Getopt::Long;

my $inputFile = 'demo.xlsx';
my $insideContainer = 0;
GetOptions( "inputfile=s" => \$inputFile,
            "inside" => \$insideContainer )
  or die "Invalid parameter passed. Valid parameters: 'inputfile, inside'";


my $fa = FestivalsAgent->new('festivals-gateway');

my $fileName = $inputFile;

my $spreadsheetMap = spreadsheet_mapping();
my $wb = Spreadsheet::Read->new( $spreadsheetMap->{workbook} );

my $f = upload_festival( $wb, $fa, $spreadsheetMap->{festival} );
#print "FESTIVAL($festival_id)): ", dump($f), "\n";
my $l = upload_locations( $wb, $fa, $spreadsheetMap->{locations} );
#print 'LOCATIONS: ', dump($l), "\n";
my $a = upload_artists( $wb, $fa, $spreadsheetMap->{artists} );
#print 'ARTISTS: ', dump($a), "\n";
my $e = upload_events( $wb, $fa, $spreadsheetMap->{events} );
#print 'EVENTS: ', dump($e), "\n";
exit;

my $locations = post_objects( $wb, $fa, 'Locations' );
#print 'LOCATIONSS: ',dump($locations), "\n===\n";

my $artists = post_objects( $wb, $fa, 'Artists' );
#print 'ARTISTS: ',dump($artists), "\n===\n";
exit;

sub upload_festival {
    my ( $wb, $fa, $map ) = @_; 

    my $festivals_list = $fa->get_api_endpoint( '/festivals' );
    #print 'FESTIVALSLIST: ', dump($festivals_list),"\n";

    #print 'MAP: ',dump($map),"\n";
    my $ss = $wb->sheet($map->{sheet});
    #print 'SS: ', dump($ss), "\n";
    my %dbFestival = ();
    for ( my $r = 1; $r <= $ss->maxrow; $r++ ) {
        my @row = $ss->cellrow($r);
    #print 'ROW: ', dump(@row), ' maps to ', $map->{rows}{$row[0]}, "\n";
        $dbFestival{$map->{rows}{$row[0]}} = $row[1]
            if $map->{rows}{$row[0]};
    }
    #print 'FIELDS: ', dump(%dbFestival),"\n";
    foreach my $f (@{$festivals_list->{data}}) {
        if ( $dbFestival{festival_name} eq $f->{festival_name}) {
            print "Festival $dbFestival{festival_name} already exists. Exiting...\n";
## ALLOW DUPLICATES            exit;
        }
    }

    my $t = Time::Piece->strptime($dbFestival{festival_start},
                                    '%Y-%m-%d'); 
    $dbFestival{festival_start} = $t->epoch;                              
    $t = Time::Piece->strptime($dbFestival{festival_end},
                                    '%Y-%m-%d'); 
    $dbFestival{festival_end} = $t->epoch; 
    my $festival = $fa->new_post_object( \%dbFestival, '/festivals' );
    #print 'FESTIVAL: ', dump($festival), "\n";
    return $festival->{data}[0]
        if ref $festival eq 'HASH';
    return $festival;
}

sub upload_locations{
    my ( $wb, $fa, $map ) = @_;
    my $ss = $wb->sheet($map->{sheet});#print 'SS: ', dump($ss), "\n";#print 'SS: ', dump($ss), "\n";
    #print 'SS: ', dump($ss), "\n";
    my $fields = get_column_numbers($ss, $map->{columns});
    #print 'FIELDS: ', dump($fields), "\n";

    my @locations = ();
    for ( my $r = 2; $r <= $ss->maxrow; $r++ ) {
        my %dbLocation = ();
        while( my ($k, $v) = each %{$map->{columns}} ) {
            my @row = $ss->cellrow($r);
            $dbLocation{$v}= $row[$fields->{$k}]
        }
        my $location = $fa->new_post_object( \%dbLocation, 
                                             '/locations' );
    #print 'LOCATION: ', dump($location), "\n";
        if (ref $location eq 'HASH') {
            push @locations, $location->{data}[0]
        } else {
            push @locations, $location;
        }
    }
    return \@locations;
}

sub upload_events {
    my ( $wb, $fa, $map ) = @_;
    print 'Events ';

    my $ss = $wb->sheet("Events");

    my $fields = get_column_numbers($ss, $map->{columns});
    #print 'FIELDS: ', dump($fields), "\n";
    my %allTags = ();
    foreach my $tag ( @{$fa->get_url( '/tags' )->{data}} ) {
        $allTags{$tag->{tag_name}} = $tag->{tag_id};
    }
    #print 'TAGSHASHED: ', dump(%allTags), "\n";
    my %allLocations = ();
    foreach my $location ( @{$fa->get_url( '/locations' )->{data}} ) {
        $allLocations{$location->{location_name}} = 
                                        $location->{location_id};
    }
    #print 'LOCATIONSHASHED: ', dump(%allLocations), "\n";
    my $allArtists = get_all( $fa, 'artist' );

    for ( my $r = 2; $r <= $ss->maxrow; $r++ ) {
        my %dbEvent = ();
        my @eventTag = ();
        my @eventLocation = ();
        my @eventArtist = ();

        my @row = $ss->cellrow($r);
        while( my ($k, $v) = each %{$map->{columns}} ) {
            $dbEvent{$v}= $row[$fields->{$k}]
                             unless ( $v =~ m!\A#! ) ;
        } 
        $dbEvent{event_start} = 
                convert_to_epoch($dbEvent{event_start},
                                '%m/%d/%Y %H:%M %p');
        $dbEvent{event_end} = 
                convert_to_epoch($dbEvent{event_end},
                                '%m/%d/%Y %H:%M %p');
        #print 'EVENT: ', dump(%dbEvent), "\n";
        my $event = $fa->new_post_object( \%dbEvent, '/events' )->{data}[0];
        #print 'EVENTRESPONSE: ',dump($event),"\n";
        associate($fa, 
                'festivals', $f->{festival_id },
                'events', $event->{event_id});

        while( my ($k, $v) = each %{$map->{columns}} ) {
           if ( $v =~ m!\A#tag! ) {
                next unless $row[$fields->{$k}];
                my ( $tagType ) = ( $v =~ m!\A#tag::(.*)! ); 
                my $tag = $tagType . '::' . $row[$fields->{$k}];
                push @eventTag, {'tag_name' => $tag };
                next;
            }
            if ( $v eq '#location' ) {
                push @eventLocation, $row[$fields->{$k}];
            }
            if ( $v eq '#artist' ) {
                push @eventArtist, $row[$fields->{$k}];
            }
        }
        #print 'EVENTTAG: ',dump(@eventTag), "\n";
        #print 'EVENTLOCATION: ',dump(@eventLocation), "\n";
        #print 'EVENTARTIST: ',dump(@eventArtist), "\n";

### SMELL: CANNOT TAG EVENTS!!!
#        if ( scalar @eventTag ) {
#            add_tags_and_associate_generic( 
#                $fa, 'events', 
#                $event->{event_id}, \@eventTag, \%allTags );
#        }
        if ( scalar @eventLocation ) {
            foreach my $l (@eventLocation) {
                if ( $allLocations{$l}) {
                associate_location($fa, 'events', 
                    $event->{event_id}, $allLocations{$l} )
                } else {
                    print "\nLocation $l not found (Event - $event->{event_name})\n";
                }

            }
        }
        if ( scalar @eventArtist ) {
            foreach my $a (@eventArtist) {
                if ( $$allArtists{$a}) {
                associate($fa, 
                    'events', $event->{event_id}, 
                    'artist', $$allArtists{$a} )
                } else {
                    print "\nArtist $a not found (Event - $event->{event_name})\n";
                }
            }
        }
my $counter = ($r % 10) ? '.' : '+';
$| = 1;
print $counter;        #exit;
    }
    print "\n";
}

sub get_all {
    my ($fa, $type) = @_;
    my %all = ();
    foreach my $object ( @{$fa->get_url( '/'.$type.'s' )->{data}} ) {
        $all{$object->{$type.'_name'}} = 
                    $object->{$type.'_id'};
    }
    return \%all;
}

sub convert_to_epoch {
    my ( $dateString, $format ) = @_;

    my $t = Time::Piece->strptime( $dateString, $format );
    return $t->epoch;
}

sub associate {
    my ($fa, $source, $sourceId, $target, $targetId ) = @_;

    return unless $sourceId;
    my $associationEndpoint = 
        join '/', $source, $sourceId, $target, $targetId;
    #print 'ENDPOINT: ', $associationEndpoint, "\n";
    my $a = $fa->new_post_object( {}, '/'.$associationEndpoint );
    #print 'ASSOCIATION: ', dump($a), "\n";
}
sub associate_location {
    my ($fa, $type, $id, $locationId ) = @_;

    my $associationEndpoint = 
        join '/', $type, $id, 'location', $locationId;
    #print 'ENDPOINT: ', $associationEndpoint, "\n";
    my $a = $fa->new_post_object( {}, '/'.$associationEndpoint );
    #print 'ASSOCIATION: ', dump($a), "\n";
}

sub upload_artists {
    my ( $wb, $fa, $map ) = @_;

    print 'Artists ';

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
$| = 1;
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
    print "\n";
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

sub add_tags_and_associate_generic {
    my ($fa, $type, $id, $tag, $allTags ) = @_;
    #print "ARTISTID: $artist_id\nartistTag: ", dump($artistTag), "\n";
    my %associations = ();
    my $associationEndpoint;
    foreach my $t ( @$tag ) {
        print 'USING TAG: ', dump($t), ' with alltags(t)- ', $allTags->{$t->{tag_name}}, "\n";
        if ( $allTags->{$t->{tag_name}} ) {
            $associationEndpoint = 
                join '/', $type, $id,'tags', 
                          $allTags->{$t->{tag_name}};
print "Found alltags t: $t = ",$allTags->{$t->{tag_name}},"\n    with endpoint: $associationEndpoint\n";

        } else {
print 'POSTING new object: ', dump($t), "\n";
            my $newTag = $fa->new_post_object( $t, '/tags' )->{data}[0]; 
print 'TAG: ', dump($newTag), "\n";
print 'TAGNAME: ',$newTag->{tag_name}, "\n";
print 'TAGID: ',$newTag->{tag_id}, "\n";
            $allTags->{"$tag->{tag_name}"} = $tag->{tag_id};
            $associationEndpoint = 
                join '/', $type, $id, 'tags', $tag->{tag_id}; 

print "New tag t: ", dump($t),"\n    with endpoint: $associationEndpoint\n";

        }
        my $a = $fa->new_post_object( {}, '/'.$associationEndpoint );
        print 'ASSOCIATION: ', dump($a), "\n";
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
        festival => {
            sheet => 'Festival',
            rows => {
                name => 'festival_name',
                start => 'festival_start',
                end => 'festival_end',
                description => 'festival_description',
            }
        },
        locations => {
            sheet => 'Locations',
            columns => {
                name => 'location_name',
                description => 'location_description'
            }
        },
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
        },
        events => {
            sheet => 'Events',
            columns => {
                name => 'event_name',
                status => '#tag::status',
                start_date => 'event_start',
                end_date => 'event_end',
                location_label => '#location',
                profile_name => '#artist',
                tag => '#tag::category'
            }
        }
     };
     return $map;
}
__END__
