#!/bin/sh

# define host names for the servers

# start servers
systemctl start festivals-server
# Keeps the container alive 
while true; do sleep 1s; done