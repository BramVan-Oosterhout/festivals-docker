The festivaks-fileserver supports the storage and retrieval of files in the FestivalsApp. 

Files are uploaded by POSTing them to the `/images/upload` endpoint. A list of available files is obtained by GETting the `/files` endpoint and  individuual files are retrieved with GET `/images/{image_id}`.

See the [DOCUMENTATION](https://github.com/BramVan-Oosterhout/festivals-docker/blob/main/festivals-fileserver/DOCUMENTATION.md) for a list of endpoints and other information.