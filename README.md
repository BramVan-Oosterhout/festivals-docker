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


