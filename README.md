festivals-docker is a docker implementation of the "Festivals-App" developed and maintained by Simon Gaus.

## What is festivals-docker?
festivals-docker is an experiment to see if I could make it work. festivals-docker is a devekopers project, rough and ready, used to explore and experiment the components of the application. It is __not__ an implementation that can be used in production.

festivals-docker does demonstrate a fully operational backend for  Festivals-App as documented by in the Festivals-App repository. In addition festivals-docker has a data upload facility and a web front end demonstrating the possible implementation to support attendees at the uploaded festival.

## How is this repository organised?
This repository consists of a top level directory and subdiretories for each component of the application. Documentation (when it exists) DOCUMENTATION.md file in each directory. In each of these files there is a section "Operation" that describes how to use the services provided by that module.

## How do I get started?
To get started you can clone this repository, change to the cloned directory and fype make. Depending on your installation and rights, you may require `sudo` for some commands.
```
	git clone git@github.com:BramVan-Oosterhout/festivals-docker.git
    cd festivals-docker
    make
```
This will take about 10 minutes. make creates aff images and starts all containers, displays their status, uploads a festival as test data and provides a web page to access the data at https://localhost. 

Remember that festivals-docker is a developers implementation. Your software configuration may be different and some dependencies may be absent in your configuration
You must have the following as 
a minimum:
*   Linux (I use Ubuntu 24)
*   docker (I use Docker version 27.0.3, build 7d4bcd8)
*   perl (I use perl 5.34)

Further dependencies are documented in DOCUMENTATION.md for each component.

## Interested? Want to help?
Your comments, issues and pull requests are welcome. 


