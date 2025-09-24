The festivaks-identity-server supports the storage of user related information for the FestivalsApp. This information is maintained on the server, separate from the festivals information stored at the festivals-datavase server.


## Operation
The festivals-identity-server server supports the standard endpoints for server maintenance: /info, /version, /health, /update, /log, /log/trace. In addition the festivals-identity-server supports the following endpoints to create, retrieve and update iser related information.

### Access and Aythorisation services
| Operation | Endpoint | Purpose |
| === | === | === |
| POST | /users/signup | Signup |
| GET | /users/login | Login |
| GET | /users/refresh | Refresh |
| GET | /users | GetUsers |
| POST | /users/{objectID}/change-password | ChangePassword |
| POST | /users/{objectID}/suspend | SuspendUser |
| GET | /validation-key | GetValidationKey |
| GET | /api-keys | GetAPIKeys |
| POST | /api-keys | AddAPIKey |
| DELETE | /api-keys | DeleteAPIKey |
| GET | /service-keys | GetServiceKeys |
| POST | /service-keys | AddServiceKey |

* /user/signon - allows a user to register by POSTing a user object as JSON: '{ "email": "me@mail.local", "password": "insecure" }'
* /users/login - returns a Java Web Token (JWT) when a registered user GETs the endpoint with the Authentication Basic me@home.local:insecure

### Endpoints not understood
| Operation | Endpoint | Purpose |
| === | === | === |
| POST | /users/{objectID}/role/{resourceID} | SetUserRole |
| POST | /users/{objectID}/festival/{resourceID} | SetFestivalForUser |
| POST | /users/{objectID}/artist/{resourceID} | SetArtistForUser |
| POST | /users/{objectID}/location/{resourceID} | SetLocationForUser |
| POST | /users/{objectID}/event/{resourceID} | SetEventForUser |
| POST | /users/{objectID}/link/{resourceID} | SetLinkForUser |
| POST | /users/{objectID}/image/{resourceID} | SetImageForUser |
| POST | /users/{objectID}/place/{resourceID} | SetPlaceForUser |
| POST | /users/{objectID}/tag/{resourceID} | SetTagForUser |
| DELETE | /users/{objectID}/festival/{resourceID} | RemoveFestivalForUser |
| DELETE | /users/{objectID}/artist/{resourceID} | RemoveArtistForUser |
| DELETE | /users/{objectID}/location/{resourceID} | RemoveLocationForUser |
| DELETE | /users/{objectID}/event/{resourceID} | RemoveEventForUser |
| DELETE | /users/{objectID}/link/{resourceID} | RemoveLinkForUser |
| DELETE | /users/{objectID}/image/{resourceID} | RemoveImageForUser |
| DELETE | /users/{objectID}/place/{resourceID} | RemovePlaceForUser |
| DELETE | /users/{objectID}/tag/{resourceID} | RemoveTagForUser |

The `festivals-identity-server.cnf` file defines the bind-host as `festivals-identity-server`. The configured certificates are for festivals-identity-server and include the required Subject Alternate Names (SANs).

The database is installed with the default configuration for mysql. There is no requirement for certificates, because the database server will only accept requests at localhost.

The [jwt] section specifies the certificates used for Java Web Token (JWT) generation. They must be in PEM format. The Makefile converts the festivaks-identity-server certificates to the correct format. 

The festivals-identity-server.yml file defines the environment for the festivals-identity-server container:
* start from the my/festivals-identity-server image
* name the container as the festivals-identity-server hostname
* add the alias for each alternative name
* connect to the backend festivals-network

Use the following command to build and start the festivals-identity-server server from the command line in the `festivals-docker/festivals-identity-server` directory:
```
sudo make base server up
```

The Makefile targets perform the following actions:

| Target | Purpose |
| === | === |
| base | Retrieves the `install.sh` script from github and executes the script. The image is tagged with my/festivals-identity-server-base. |
| server | Adds the configuration details to the ...-base image. The image is tagged with my/festivals-identity-server. |
| up | Starts the festivals-identity-server container, |
| down | Stops the festivals-identity-server container. |

Tge `install.sh` script does all the work to retrieve, install and configure a workable system. There is no post processing required.




