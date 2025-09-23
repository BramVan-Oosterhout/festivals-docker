The festivaks-server supports the storage and retrieval of ojects in the FestivalsApp. Objects available are: festivals, events, artists, locations, places and tags.

Objects are uploaded by POSTing them to the availabke endpoints. Retrievals areperformed by GETting the equivalent endpoint. All responses are in JavaScript Object Notation (JSON).

Typical retrievals are:
* GET /festivals - to retrieve a list of festivals
* GET /events - to retrieve a list of events
* GET /festivals/{festivals_id}/events - to retrieve the list of events for the festival with ID=festival_id
* GET /events/{event_id} - to retrieve the events with ID=event_id.

Typical insertions are:
* POST /festivals - to create a festival
* POST /events - to create an event
* POST /festivals/{festival_id}/events/{event_id} - to associate event ID=event_id to festival ID=festival_id.

See the (DOCUMENTATION) for a list of endpoints and other information.