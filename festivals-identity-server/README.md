The festivaks-identity-server supports the storage of user related information, in particular user email amd  password. The festivals-identity-server maintains its own database of user information and user related festival details.

Users are created by POSTing their details to the `/users/signup` endpoint. A list of registered users is obtained by GETting the `/users` endpoint. Users can login and obtain a Java Web Token (JWT) by supplying basic authorization (username:password) with GET `/users/login`.

See the [DOCUMENTATION](https://github.com/BramVan-Oosterhout/festivals-docker/blob/main/festivals-identity-server/DOCUMENTATION.md) for a list of endpoints and other information.