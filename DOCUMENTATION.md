The festivals-docker directory contains the subdirectories defining the components of the application and makefiles of a general nature.

## The directories
### festivals-...
festivals-identiry-server, festivals-gateway, festivals-database, festivals-server, festivals-fileserver and festivals-website contain the dockerisation for the [Festivals-App](https://github.com/Festivals-App), Their purpose is well documented in that repository.

festivals-network has the definition of the internal docker network connecting the containers of the Festivals-App.

festivals-checks has the definition of a container and shell scripts that test the access variousthe Festivals-App containers.

festivals-upload has a perl script and the data to load the test festival into the festivals-database.

festivals-UI has the definition of the container that provides access to the the Festivals-App

festivals-certificates has the definition of the SSL certificates required for the access to the servers in the Festivals-App.

## The makefiles
Makefile defines targets of a general nature to build the images and run the containers for the Festivals-App. Most targets are delegated to Makefiles in the subdirectories;

| Target | Delegated | Action |
| === | === | === |
| ubuntu | N | create the ubuntu image for all containers |
| certificates | Y | create the certificates for the servers of the Festivals-App |
| checks | Y | create the festivals-checks image and start the container |
| festivals% | Y | create the image for the festivals-... servers and start the containers |

allservers.mk defines targets to configure/start and stop all containers. All specifies all Festivals-App servers. 

| Target | Delegated | Action |
| === | === | === |
| all | Y | creates all images and starts each container |
| allup | Y | starts all containers |
| alldown | Y | stops all containers |
| allservers | Y | (re)configures all servers, but does not start the containers. |

develop.mk defines helpful targets whilst in the Festivals-App server directories. 

| Target | Action |
| === | === | 
| enter | enter the container |
| rmapp | remove the container |
| reup | restart the container and enter it |
| reconfigure | reconfigure the image, restart the container and enter it |
| net-up | start the internal container network |

# Operation
If you don't use one of the shortcuts above, then you need to create the ubuntu image that is the base for all other inages in festivals-docker.

```
make ubuntu
```

