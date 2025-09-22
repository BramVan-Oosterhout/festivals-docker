The festivaks-website presents a portal to the FestivalsApp.The portal is avalable at (localhost:10443)[https://localhost:10443].

Note: Firefox (version 142) insisted on telling me "Error code: SEC_ERROR_UNKNOWN_ISSUER" even though the CA certificate for the athority in festivals-certificates is available in the servers certificate store.I tried various answers from the internet, but eventually installed another browser: epiphany-browser.

## Operation
The festivals-website-node (sidecar) server supports the standard endpoints for server maintenance: /info, /version, /health, /update, /log, /log/trace. 

The `festivals-website.cnf` file defines the bind-host as `festivals-website`. The configured certificates are for festivals-website and include the required Subject Alternate Names (SANs) in the hostlist.

Tge websitr itself is accessed through nginx and is configured in `configure.dck`. `install.sh` configures mginx with certificates managed by certbot  from (Let's Encrypt)]https://letsencrypt.org/about/]. That is overkill for this toy implementation, so the configuration uses the festivals-website self-signed certificates (The same certificates that are used for the festivals-website sidecar).

The festivals-website.yml file defines the environment for the festivals-website container:
* start from the my/festivals-website image
* name the container as the festivals-website hostname
* add the alias for each alternative name
* connect to the backend festivals-network

Note that the entrypoint.sh container startup starts both the serber AND nginx.

Use the following command to build and start the festivals-website server from the command line in the `festivals-docker/festivals-website` directory:
```
sudo make base server up
```

The Makefile targets perform the following actions:

| Target | Purpose |
| === | === |
| base | Retrieves the `install.sh` script from github and executes the script. The image is tagged with my/festivals-website-base. |
| server | Adds the configuration details to the ...-base image. The image is tagged with my/festivals-website. |
| up | Starts the festivals-website container, |
| down | Stops the festivals-website container. |

Tge `install.sh` script does all the work to retrieve, install and configure a workable system. There is no post processing required.




