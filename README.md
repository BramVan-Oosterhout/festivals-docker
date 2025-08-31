full upgrade to ubuntu 24 and festivals app July 24

Creating a top level Makefile and use recursive make for the rest.

ubuntu creates a ubuntu24 image
base crates the installed application image
server creates the configured application image
up statrt the application
down stops the application

There are separate makefiles in the application server directory

Docker netwotking does not play well with firewalls inside the container.
There are many warnings on the internet.
Dince 'install.sh' configures a firewall for each server, I disable 'ufw'
with `echo '#!/usr/bin/sh' > /usr/sbin/ufw`

Install.sh configures a user 'admin@email.com/ with passworf 'we4711'
by inserting a recoed into table 'festivals-identity-database.users'
The record contains a hard coded encryptiom of 'we4711', so
one cannoy chanfe the passworf un yhe configuration

festivals-gateway
=================
There is code in festivals-gateway/server/server.go (lines 79-80)
thqtvtreats servers with cport 8o or 443 configures as special.
It expects urls of the form xxx.<bindhost>
That in turn would require special certificates!

The Festivals-App backend is implemented with 5 servers:
* festovals-identity-server
* festivals-server
* festivals-database
* festivals-fileserver
* festivals-gateway

The purpose of each xerver is described in the ARCHITECTURE document.

The Docker implementation creates an image for each server with rhe image name: my/<server name>. 
The Makefiles provided start a container with container name: <server name>

Each server is identified by an SSL certificate issued by a Certification Authority (CA). This Docker implementation uses self signed certificates. For each <server name> the certificates/Makefile  generates a set of <server name>.crt and <server name>.key files to beused in the configuration of each server.

The configured server wirll start with the `docker compose up --detach` command. But they will not be accessible. To access a server a user must be iogged in. To get started a default user and password have been created:
user name: `admin@email.com` with password: `we4711`

With this user name and password you can login to the `festivals-identity-server` which will return a JSON Web Token (JWT).

The servers will honour requests for information that are accompanied by the JWT. For example, the following code 
1 logs in and gets the JWT token
2 request the server information 
### TODO what is the function of the TEST_API_KEY?
