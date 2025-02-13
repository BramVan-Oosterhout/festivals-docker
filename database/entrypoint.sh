#!/bin/sh

# define host names for the servers
sed -e '/172.20/s/$/\tfestivals-database/' /etc/hosts

# start servers
systemctl start mysql
systemctl start festivals-database-node
# Keeps the container alive 
while true; do sleep 1s; done