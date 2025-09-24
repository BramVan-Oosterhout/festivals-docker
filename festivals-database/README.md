The festivals-database server provides storage for the data of the festivals supported by FestivalsApp. The objects stored areL

| Object | Main attributes |
| --- | --- |
| festivals | The festival name, description, start and end date |
| events | The event name, description, start and end |
| artists | The artist name and description |
| locations, places, links, tags, images | Additional attributes that can be associated with festivals, events and artists. |

Access to this database is provided via the festivals-server. The access endpoints are described there.

The festivals-database server supports the standard maintenance endpoints: /info, /version, /health, /update, /log and /log/trace.

For further details see [DOCUMENTATION](https://github.com/BramVan-Oosterhout/festivals-docker/blob/main/festivals-database/DOCUMENTATION.md)
