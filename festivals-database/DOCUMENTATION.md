The festivals-database server provides storage for the data of the festivals supported by Festivals-App, as well as functionality to maintain the server.

The database tables are defined in the [create_database.sql](https://github.com/Festivals-App/festivals-database/blob/main/database/create_database.sql) script in the Festivals-App repo. The database is highly normalised. There are eight objects and fourteen mappings between the objects supported. These are tabulated below.  An `X`in the cell indicates that a mapping record of the form
```
tag_id object1_id object2_id:
```
is defined. For example, the `X` in the events row and artists column indicates a mapping exists of the form:
```
tag_id event_id artist_id
```

|     |artists | events | festivals | images | links | locations | places | tags |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| artists | | | | X | X | | | X  |
| events | X | | | X | | X | | |
| festivals | | X | | X | X | | X | X  |
| images | | | | | | | | |
| links | | | | | | | | |
| locations | | | | X | X | | X | |
| places | | | | | | | | |
| tags   | | | | | | | | |

From a database point of view, these mappings are bi-directional. If event E is mapped to artist A, then artist A is mapped to event E. 

## Operation
The festivals-database server supports the standard endpoints for server maintenance: /info, /version, /health, /update, /log, /log/trace. Access to the data stored in the database is provided by the festivals-server.

The festivals-database server is accessible via two domains defined in the hostlist file: `festivals-database` and `database.festivals-gateway`.

The `festivals-database-node.cnf` file defines the bind-host as `festivals-database`. The configured certificates are for festivals-database-node.

The `configure.dck` file provides the configuration for the mysql database. In particular:
* the certificates are placed in in `/etc/mysql` 
+ the bind-address is set to `0.0.0.0` in `/etc/mysqld/mysql.conf.d/mysqld.cnf`
* the SSL settings are defined in `/etc/mysql/mysql.conf.d/festivals-mysqld.cnf`

The festivals-database.yml file defines the environment for the festivals-database container:
* start from the my/festivals-database image
* name the container as the festivals-database hostname
* add the alias database.festivals-gateway
* connect to the backend festivals-network

Use the following command to build and start the festivals-database server from the command line in the `festivals-docker/festivals-database` directory:
```
sudo make base server up
```

The Makefile targets perform the following actions:

| Target | Purpose |
| --- | --- |
| base | Retrieves the `install.sh` script from github and executes the script. The image is tagged wit my/festivals-database-base. |
| server | Adds the configuration details to the my/festivals-database-base image. The image is tagged with my/festivals-database. |
| up | Starts the festivals-database container, |
| down | Stops the festivals-database container. |

Tge `install.sh` script does all the work to retrieve, install and configure a workable system. `install.sh` defines two database users with:
```
mysql -e "CREATE USER 'festivals.api.reader'@'%' IDENTIFIED BY '$read_only_password' REQUIRE SUBJECT '/CN=Festivals-App Database Client';"
mysql -e "CREATE USER 'festivals.api.writer'@'%' IDENTIFIED BY '$read_write_password' REQUIRE SUBJECT '/CN=Festivals-App Database Client';"
```

The Makefile generating the certificates does not handle spaces in the Common Name (CN), so I generated a certificate for 'FestivalsAppDatabaseClient'. The update is performed in configure.dck.