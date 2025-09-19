festivals-upload.pl is a perl program to upload data for a single festival to the Festivals-App back end. I use perl 5.34. The program depends on the the module FestivalsAgent.pm and following perl modules, available from cpan.

| Module | cpan |
| === | === |
| Data::Dump | Data::Dump |
| Spreadsheet::Read | Spreadsheet::Read |
| Getopt::Long | Getopt::Long |
| LWP::UserAgent| LWP::UserAgent |
| HTTP::Request | HTTP::Request |
| HTTP::Request::Common; | HTTP::Request::Common |
| JSON | JSON |
| Cwd | Cwd |
| Try::Tiny | Try::Tiny |

If (some of) these modules are missing on your server, they can be downloaded with:
```
cpan install <moduke name>
```
The Makefile has a target upload that will execute `festivals-upload.pl` with all defaults. The defaults expect `festivals-upload.pl`, `FestivalsAgent.pm` and `demo.xlsx` to be in the same direcory. If that is not the case and `FestivalsAgent,pm` is in directory <agent path> and `demo.xlsx` in directory <demo path>, the following command can be used:
```
perl -I <agent path> festivals-upload.p --inputfile <demo path>/demo.xlsx
```

## Mapping collumns to database fields
`festivals-upload.pl` maps columns from the spreadsheet to fields in the database. The mapping is defined in subroutine `spreadsheet_mapping` and takes the form:

```
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
                featured => '#tag::featured',
                status => '#tag::status',
                category => '#tag::category'
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
    
```

Special processing is performed for fields mapped to a name starting with a #.

| name | processing |
| === | === |
| #imageurl | The cell value is a URL and is mapped to an object in the images table with the `image_ref=URL` and the `image_comment=(artist_name|event_name)` |
| #location | The cell value is a `location_name` and is mapped to the matching, existing `location_id` in the locations table. |
| #artist | The cell value is an `artist_name` and is mapped to the matching, existing `artist_id` in the artists table. |
| #tag::<type> | The cell value is the value associated with the <type>. It is stored as `tag_name=<type>::value` and mapped to the artist or event, If the tag with `tag_name=<type>::value` already exists, only the mappin is inserted in the nap_... table. |

See (festivals-database)[festivals-database] for information on the database struvture.

## The docker container
The ffestivals-upload docker image is used for the demo target. The image resolves  the perl dependecies and makes the upload independent of the host configuration. It may be of interest as an example, but the image is of little use once the host is configured appropriately.

`base.dck` creates a ubuntu image with perl installed.