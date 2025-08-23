#!/bin/sh

# define host names for the servers

# start servers
systemctl start festivals-website-node

# Keeps the container alive 
while true; do sleep 1s; done