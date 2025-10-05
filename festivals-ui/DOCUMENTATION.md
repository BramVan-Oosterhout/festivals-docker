festivals-ui implements a user interface to the FestivalsApp backend using the open source Enterprise wiki [Foswiki](https://foswiki.org). This interdace was build as an experiment in using the FestivalsApp and is not mant to be a front end. 

festivals-ui does all web page building at the back end, sending a fully formatted page to the browser for rendering. As a consequence, there is no local storage at the front end and all processing requires a request/response round trip to the server.

Foswiki implements a web page through the specification of macros on a page. Many macros are predefined, and the festivals-ui uses several of those. %IMAGE( ... )% to display images and %FORMATLIST{ ... }%  to format a list of data.

The interface to the FestivalsApp is implemented in a plugin, the FestivalsPlugin. The plugin defines a collection of Foswiki macros, that retrieve data from the FestivalsApp and return the data as strings. A typical example is the combination 
```
%FORMATLIST{ "%EVENTS_LIST{ festivals_id="3"}%" {formatting instructions} }%
```
The FestivalsPlugin defines the following Foswiki macros:

| Macro | Invocation  | Purpose |
| --- | --- | --- |
| FESTIVALS_LIST | %FESTIVALS_LIST% | List all festivals |
| EVENTS_LIST | %EVENTS_LIST{ festival_id="3" }% | List all events for festival_id 3 |
| ARTISTS_LIST | %ARTISTS_LIST{ festival_id="3" }% | List all artists for festival id 3 |
| ARTIST_EVENTS | %ARTIST_EVENTS{ festival_id="3" artist_id="42" }% | List all events for artist_id 42 at festival_id 3 |
| ARTIST_NAME | %ARTIST_NAME{ artist_id="42" }% | Show the name of artist_id 42 |
| ARTIST_IMAGE | %ARTIST_IMAGE{ artist_id="42" }% | Show the image of artist_id 42 |
| ARTIST_DESCRIPTION | %ARTIST_DESCRIPTION{ artist_id="42" }% | Show the description of artist_id 42 |
| ARTIST_TAGS | %ARTIST_TAGS{ artist_id="42" }% | List the tags for artist_id 42 |

This list illustrates one of the shortcomings in the thinking behind the implementation of the plugin. Currently each macro creates a new instance of the FestivalsPlugin and therefore each macro needs to access retrieve the data from the database. The access to the database provides one endpoint for the artist data: `/artist/42` which returns both the artist_name and the artist_description. So the ARTIST_NAME and ARTIST_DESCRIPTION could be implemented with a single FestivalsApp access, followed by appropriate formatting  to render the FestivalsArtist page. If the FestivalsPlugin is developed further, the approach need to be refined.

## Server implementation
The image created in base.dck from the `timlegge/docker-foswiki:latest` image is further configured in configure.dck. The FestivalsPlugin needs to be added to the installed plugins. 
```
COPY --chown=nginx:nginx FestivalsPlugin* .
RUN    perl tools/extension_installer FestivalsPlugin -r -enable install 
```


## Operation
Use the following command to build and start the festivals-ui server from the command line in the `festivals-docker/festivals-ui` directory:
```
sudo make base server up
```
The container is accessible  on port 8765 on localhost with: `https:/localhost:8765`. Youcan login as user: `admin` and password `insecure`. The password is configured with:
```
RUN    tools/configure -save -set {Password}='insecure'
```

The Makefile for festivals-ui follows the same patters as the Makefile of the festivals-{servers}.

| Target | Purpose |
| --- | --- |
| base | retrieves the `timlegge/docker-foswiki:latest` image from the docker image store for further configuration. |
| server | stops the foswiki-ui server and removes the foswiki-www volume. Then the image is reconfigured. This sequence is necessary, because the foswiki container mounts the volume on top of the reconfigured image. As a consequence the new configuration is not available. By removing the volume, the new configuration is copied to the freshly mounted empty nolume. A docker quirk. |
| up | starts the foswiki-ui container from the my/foswiki-ui image. The container is accessible  on port 8765 on localhost with: `https:/localhost:8765`. 



