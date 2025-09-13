#!/bin/sh

# define host names for the servers

# start servers
cd /home/build;
./festivals-upload.pl --inside > /tmp/festivals-upload.log
# Keeps the container alive 
while true; do sleep 1s; done