The festivaks-server supports the storage and retrieval of ojects in the FestivalsApp. Objects available are: festivals, events, artists, locations, places and tags.

## Operation
The festivals-server server supports the standard endpoints for server maintenance: /info, /version, /health, /update, /log, /log/trace. In addition the festivals-server supports the following endpoints to create, retrieve update and delete objects.

### Retrievals
| Operation | Endpoint | Purpose |
| === | === | === |
| GET | /festivals | GetFestivals |
| GET | /festivals/{objectID} | GetFestival |
| GET | /festivals/{objectID}/events | GetFestivalEvents |
| GET | /festivals/{objectID}/image | GetFestivalImage |
| GET | /festivals/{objectID}/links | GetFestivalLinks |
| GET | /festivals/{objectID}/place | GetFestivalPlace |
| GET | /festivals/{objectID}/tags | GetFestivalTags |
| GET | /artists | GetArtists |
| GET | /artists/{objectID} | GetArtist |
| GET | /artists/{objectID}/image | GetArtistImage |
| GET | /artists/{objectID}/links | GetArtistLinks |
| GET | /artists/{objectID}/tags | GetArtistTags |
| GET | /locations | GetLocations |
| GET | /locations/{objectID} | GetLocation |
| GET | /locations/{objectID}/image | GetLocationImage |
| GET | /locations/{objectID}/links | GetLocationLinks |
| GET | /locations/{objectID}/place | GetLocationPlace |
| GET | /events | GetEvents |
| GET | /events/{objectID} | GetEvent |
| GET | /events/{objectID}/festival | GetEventFestival |
| GET | /events/{objectID}/image | GetEventImage |
| GET | /events/{objectID}/artist | GetEventArtist |
| GET | /events/{objectID}/location | GetEventLocation |
| GET | /images | GetImages |
| GET | /images/{objectID} | GetImage |
| GET | /links | GetLinks |
| GET | /links/{objectID} | GetLink |
| GET | /places | GetPlaces |
| GET | /places/{objectID} | GetPlace |
| GET | /tags | GetTags |
| GET | /tags/{objectID} | GetTag |
| GET | /tags/{objectID}/festivals | GetTagFestivals |

Retrievals are requested by GETting is URL. In response an object is returned in JavaScript Object Notation (JSON), Typical examples are:
```
===========================================================================
   >>> https://festivals-server:10439/festivals
{
  "data": [
    {
      "festival_id": 1,
      "festival_version": "2025-09-19T08:05:02Z",
      "festival_is_valid": false,
      "festival_name": "Stemmwede (2020)",
      "festival_start": 100,
      "festival_end": 200,
      "festival_description": "Das Stemweder Open Air Festival ... stattfindet.",
      "festival_price": "Umsonst-und-DrauÃŸen"
    },
    {
      "festival_id": 2,
      "festival_version": "2025-09-19T08:05:02Z",
      "festival_is_valid": false,
      "festival_name": "Krach am Bach (2020)",
      "festival_start": 300,
      "festival_end": 400,
      "festival_description": "Krach am Bach ist ... Organisationen.",
      "festival_price": "VVK 45 â‚¬"
    },
    {
      "festival_id": 3,
      "festival_version": "2025-09-19T08:07:59Z",
      "festival_is_valid": false,
      "festival_name": "National Folk Festival",
      "festival_start": 1680739200,
      "festival_end": 1681084800,
      "festival_description": "Welcome to the ... inspire generations to come.",
      "festival_price": ""
    }
  ]
}    
===========================================================================
   >>> https://festivals-server:10439/events/1/artist
{
  "data": [
    {
      "artist_id": 1,
      "artist_version": "2025-09-19T08:05:02Z",
      "artist_name": "Menomena",
      "artist_description": "Menomena ...  Sonic Youth verglichen."
    }
  ]
}
```
The descroptions are cut in this example. The ,,, replaces the removed text. The returned information is always an array of data: { "data": [ ..., ..., ... ] }, even when only one element is returned. `server=check.sh` in the festivals-checks container provides many more examples and a place for experimentation.

The defined endpoints limit the ability to retieve the bi-directional, many-to-many relationships. The table below illustrates the endpoints implemented.
* X indicates the database mapping table. For example map_festivals_events
* P indicates the POST endpoints implemented. For example: POST /festivals/{objectID}/events/{resourceID} (See below under Modifications)
* G indicates the GET endpoints implemented. Gor example: GET /festivals/{objectID}/events

Only two retrievals are implemented in both directions:
* List all events for a festival AND List all festivals for an event
* List all tags for a festival AND List all festivals for a tag
Other relationships need to be calculated like: List all events for an artist.

| TO >| festivals | events |artists | ima G es | links | locations | places | ta G s }
| FROM v| === | === | === | === | === | === | === | === |
| festivals | | X P G | | X P G | X P G | | X P G | X P G  |
| events | G | | X P G | X P G | | X P  G | | |
| artists | | | | X P G | X P G | | | X P G  |
| images | | | | | | | |  |
| links | | | | | | | | |
| locations | | | | X P G | X P G | | X P G | |
| places| | | | | | | | |
| tags| G | | | | | | | |

### Modifications
| Operation | Endpoint | Purpose |
| === | === | === |
| POST | /festivals | CreateFestival |
| PATCH | /festivals/{objectID} | UpdateFestival |
| DELETE | /festivals/{objectID} | DeleteFestival |
| POST | /festivals/{objectID}/events/{resourceID} | SetEventForFestival |
| POST | /festivals/{objectID}/image/{resourceID} | SetImageForFestival |
| POST | /festivals/{objectID}/links/{resourceID} | SetLinkForFestival |
| POST | /festivals/{objectID}/place/{resourceID} | SetPlaceForFestival |
| POST | /festivals/{objectID}/tags/{resourceID} | SetTagForFestival |
| DELETE | /festivals/{objectID}/image/{resourceID} | RemoveImageForFestival |
| DELETE | /festivals/{objectID}/links/{resourceID} | RemoveLinkForFestival |
| DELETE | /festivals/{objectID}/place/{resourceID} | RemovePlaceForFestival |
| DELETE | /festivals/{objectID}/tags/{resourceID} | RemoveTagForFestival |
| POST | /artists | CreateArtist |
| PATCH | /artists/{objectID} | UpdateArtist |
| DELETE | /artists/{objectID} | DeleteArtist |
| POST | /artists/{objectID}/image/{resourceID} | SetImageForArtist |
| POST | /artists/{objectID}/links/{resourceID} | SetLinkForArtist |
| POST | /artists/{objectID}/tags/{resourceID} | SetTagForArtist |
| DELETE | /artists/{objectID}/image/{resourceID} | RemoveImageForArtist |
| DELETE | /artists/{objectID}/links/{resourceID} | RemoveLinkForArtist |
| DELETE | /artists/{objectID}/tags/{resourceID} | RemoveTagForArtist |
| POST | /locations | CreateLocation |
| PATCH | /locations/{objectID} | UpdateLocation |
| DELETE | /locations/{objectID} | DeleteLocation |
| POST | /locations/{objectID}/image/{resourceID} | SetImageForLocation |
| POST | /locations/{objectID}/links/{resourceID} | SetLinkForLocation |
| POST | /locations/{objectID}/place/{resourceID} | SetPlaceForLocation |
| DELETE | /locations/{objectID}/image/{resourceID} | RemoveImageForLocation |
| DELETE | /locations/{objectID}/links/{resourceID} | RemoveLinkForLocation |
| DELETE | /locations/{objectID}/place/{resourceID} | RemovePlaceForLocation |
| POST | /events | CreateEvent |
| PATCH | /events/{objectID} | UpdateEvent |
| DELETE | /events/{objectID} | DeleteEvent |
| POST | /events/{objectID}/image/{resourceID} | SetImageForEvent |
| POST | /events/{objectID}/artist/{resourceID} | SetArtistForEvent |
| POST | /events/{objectID}/location/{resourceID} | SetLocationForEvent |
| DELETE | /events/{objectID}/image/{resourceID} | RemoveImageForEvent |
| DELETE | /events/{objectID}/artist/{resourceID} | RemoveArtistForEvent |
| DELETE | /events/{objectID}/location/{resourceID} | RemoveLocationForEvent |
| POST | /images | CreateImage |
| PATCH | /images/{objectID} | UpdateImage |
| DELETE | /images/{objectID} | DeleteImage |
| POST | /links | CreateLink |
| PATCH | /links/{objectID} | UpdateLink |
| DELETE | /links/{objectID} | DeleteLink |
| POST | /places | CreatePlace |
| PATCH | /places/{objectID} | UpdatePlace |
| DELETE | /places/{objectID} | DeletePlace |
| POST | /tags | CreateTag |
| PATCH | /tags/{objectID} | UpdateTag |
| DELETE | /tags/{objectID} | DeleteTag |

Modifications can be made in three ways:
* POST - to create an object
* PATCH - to update an object
* DELETE - to delete and object

POST and PATCH need a JSON object to supply the new data. DELETE does not require data. DELETE returns an empty array. PATH and POST retun an array with a single object.

### Server implementation
The `festivals-server.cnf` file defines the bind-host as `festivals-server`. The configured certificates are for festivals-server and include the required Subject Alternate Names (SANs) in hostlist.

The festivals-server interacts with the festivals-database. The interaction is configured in the `[database]` section of the configuration file. The festivals-server use the FestivalsAppDatabaseClient certificate and key to identify itself to the festivals-database. They are stored inthe database-client.crt and database-client.key files.

The festivals-server.yml file defines the environment for the festivals-server container:
* start from the my/festivals-server image
* name the container as the festivals-server hostname
* add the alias for each alternative name
* connect to the backend festivals-network

Use the following command to build and start the festivals-server server from the command line in the `festivals-docker/festivals-server` directory:
```
sudo make base server up
```

The Makefile targets perform the following actions:

| Target | Purpose |
| === | === |
| base | Retrieves the `install.sh` script from github and executes the script. The image is tagged with my/festivals-server-base. |
| server | Adds the configuration details to the ...-base image. The image is tagged with my/festivals-server. |
| up | Starts the festivals-server container, |
| down | Stops the festivals-server container. |

Tge `install.sh` script does all the work to retrieve, install and configure a workable system. There is no post processing required.




