Rge festivaks-gateway server provides routing and load balancing services for the FestivalsApp. Access from the network is provided in five sub-domains, each providing a particular set of services.  

| Sub-domain | Services provided |
| === | === |
| gateway | This sub-dpmain is routed to the festivals-gateway server abd offers the regular maintenance endpoints: /info, /version, /health, /log, /log/trace and /update. |
| discovery | This sub-domain services the discovery endpoint: /loversear for the servers to announce their availability and the /services endpoint to support the discovery of those services by clients. |
| api | This sub-domain services the requests to be routed to the festivals-server. See the festivals-server documentation for more information. |
| database | TODO |
| files | This sub-domain services the requests to be routed to the fedtivals-fileserver. See the festivals-fileserver documentation for more information. |
