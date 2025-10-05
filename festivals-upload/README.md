The files in the festivals-upload directory support the upload of data to the FestivalsAoo. The input data is a spreadsheet workbook with four sheets:
* Festivals - provides data to define the festival covered in this workbook
* Locations - presents the data for the locations where events are held
* Artists - presents the data for each artist performing at the festival
* Events - presents the data for each event at the festival

## Supported fields for each sheet 
The sheets provide the data for the database fields in the tables as follow:

| Festivals | Locations | Artists | Events |
| --- | --- | --- | --- |
| name | name | name | namee |
| description | description | description | location |
| start | | image_url | start_date |
| end | | featured | end_date |
| | | status | status |
| | | category | profile |
| | | | tag |

`demo.xls` contains a complete workbook to upload to the Festivals-App,

To upload the data to the Festivals-App use the command:
```
./festivals-upload.pl
```

For details of the implementation and operation see [DOCUMENTATION](https://github.com/BramVan-Oosterhout/festivals-docker/blob/main/festivals-upload/DOCUMENTATION.md).


