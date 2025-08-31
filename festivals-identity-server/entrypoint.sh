#!/bin/sh

# define host names for the servers

# start servers
systemctl start mysql
systemctl start festivals-identity-server
# Keeps the container alive 
while true; do sleep 1s; done