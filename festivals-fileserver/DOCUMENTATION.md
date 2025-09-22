The festivaks-fileserver supports the storage and retrieval of files in the FestivalsApp. 

## Operation
The festivals-fileserver server supports the standard endpoints for server maintenance: /info, /version, /health, /update, /log, /log/trace. In addition the festivals-fileserver supports the following endpoints to create, retrieve and update files.

| Operation | Endpoint | Purpose |
| === | === | === |
| GET | /files | GetFileList |
| GET | /images/{imageIdentifier} | Download |
| GET | /pdf/{pdfIdentifier} | DownloadPDF |
| POST | /images/upload | MultipartUpload |
| POST | /pdf/upload | MultipartPDFUpload |
| PATCH | /images/{imageIdentifier} | Update |
| PATCH | /pdf/{pdfIdentifier} | UpdatePDF |

The `festivals-fileserver.cnf` file defines the bind-host as `festivals-fileserver`. The configured certificates are for festivals-fileserver and include the required Subject Alternate Names (SANs).

The festivals-fileserver.yml file defines the environment for the festivals-fileserver container:
* start from the my/festivals-fileserver image
* name the container as the festivals-fileserver hostname
* add the alias for each alternative name
* connect to the backend festivals-network

Use the following command to build and start the festivals-fileserver server from the command line in the `festivals-docker/festivals-fileserver` directory:
```
sudo make base server up
```

The Makefile targets perform the following actions:

| Target | Purpose |
| === | === |
| base | Retrieves the `install.sh` script from github and executes the script. The image is tagged with my/festivals-fileserver-base. |
| server | Adds the configuration details to the ...-base image. The image is tagged with my/festivals-fileserver. |
| up | Starts the festivals-fileserver container, |
| down | Stops the festivals-fileserver container. |

Tge `install.sh` script does all the work to retrieve, install and configure a workable system. There is no post processing required.




