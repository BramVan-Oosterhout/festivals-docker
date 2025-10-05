fesyivals-ui implements a user interface to the Festivals-App backend using the open source Enterprise wiki [Foswiki](https://foswiki.org). This interface was build as an experiment in using the Festivals-App and is not meant to be a front end. 

The current implementation is far from optimal. On the positve side, the implementation does illustrate the capabilities of the Festivals-App back-end. Four views have been implemented, represented by their web page name_

| View | Purpose |
| --- | --- |
| Festivals-App | A list of festivals available for perusal with the date(s) they are held and the number of events and performances on offer. |
| FestivalsEventsByDAy | A list of events for the selected festival, sorted by date and time |
| FestivalsArtistsAtoZ | A list of the artists performing at the festival, sorted by name. |
| FestivalsArtist | The information avalable for an artist and the date(s) they are performing. |

For details on the implementation see the [DOCUMENTATION](https://github.com/BramVan-Oosterhout/festivals-docker/blob/main/festivals-ui/DOCUMENTATION.md) page.