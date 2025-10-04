The festivaks-gateway server provides routing and load balancing services for the FestivalsApp. The server routes access to different services on their respective servers, depending on the sub-domain provided when accessing the festivals-gateway.

The information about services available is provided by the `discovery` sub-domain at the /services endpoiny,
```
---------------------------------------------------------------------------
   >>> https://discovery.festivals-gateway/services
{
  "data": [
    {
      "Type": "festivals-fileserver",
      "Location": "https://festivals-fileserver:1910",
      "LastSeen": "2025-09-19T07:32:15.990364513Z"
    },
    {
      "Type": "festivals-identity-server",
      "Location": "https://festivals-identity-server:22580",
      "LastSeen": "2025-09-19T07:32:16.131718478Z"
    },
    {
      "Type": "festivals-database-node",
      "Location": "mysql://festivals-database:3306",
      "LastSeen": "2025-09-19T07:32:16.413227613Z"
    },
    {
      "Type": "festivals-database-node",
      "Location": "https://festivals-database:22397",
      "LastSeen": "2025-09-19T07:32:16.41325199Z"
    },
    {
      "Type": "festivals-server",
      "Location": "https://festivals-server:10439",
      "LastSeen": "2025-09-19T07:32:16.675650987Z"
    },
    {
      "Type": "festivals-website-node",
      "Location": "https://festivals-website:1910",
      "LastSeen": "2025-09-19T07:32:14.679790428Z"
    },
    {
      "Type": "festivals-gateway",
      "Location": "https://gateway.festivals-gateway:443",
      "LastSeen": "2025-09-19T07:32:15.335572104Z"
    }
  ]
}
---------------------------------------------------------------------------
```

This information is maintained by the respective servers when they post to
```
https://discovery.festivals-gateway/loversear

```
## Operation
The festivals-gateway server supports the standard endpoints for server maintenance: /info, /version, /health, /update, /log, /log/trace. 

The festivals-gateway server is accessible via six domains defined in the hostlist file: `festivals-gateway`, `gateway.festivals-gateway`, `discovery.festivals-gateway`,`api.festivals-gateway`, `files.festivals-gateway`, `database.festivals-gateway`.

The `festivals-gateway.cnf` file defines the bind-host as `festivals-gatewau`. The configured certificates are for festivals-gateway and include the required Subject Alternate Names (SANs).

The festivals-gateway.yml file defines the environment for the festivals-gateway container:
* start from the my/festivals-gateway image
* name the container as the festivals-gateway hostname
* add the alias for each alternative name
* connect to the backend festivals-network

Use the following command to build and start the festivals-gateway server from the command line in the `festivals-docker/festivals-gateway` directory:
```
sudo make base server up
```

The Makefile targets perform the following actions:

| Target | Purpose |
| --- | --- |
| base | Retrieves the `install.sh` script from github and executes the script. The image is tagged with my/festivals-gateway-base. |
| server | Adds the configuration details to the ...-base image. The image is tagged with my/festivals-gateway. |
| up | Starts the festivals-gateway container, |
| down | Stops the festivals-gateway container. |

The `install.sh` script does all the work to retrieve, install and configure a workable system. There is no post processing required.