# UltraGraphQL-docker  
* A UltraGraphQL-docker Container with `no root access` (except using `sudo ...` and you can remove it using `sudo apt-get remove sudo` to protect your Container). 
```
If [ you are looking for such a common requirement as a base Container ] and 
   [ UltraGraphQL inside the container ]:
   Then [ this one may be for you ]
```
# Requirements:
* Gradle: v7.3.3
* Java: v11

# Components:
* UltraGraphQL
* No root setup: using /home/developer 
  * It has sudo for dev phase usage. You can "sudo apt-get remove sudo" to finalize the product image.
  * Note, you should consult Docker security experts in how to secure your Container for your production use!)
  
# Release
* This is also a fix to mitigate the Log4Shell vulnerability.
   * update to the latest versions to avoid the Log4Shell vulnerability

# Related Projects
* UltraGraphQL:
   * [UltraGraphQL-Upstream](https://git.rwth-aachen.de/i5/ultragraphql)
   * [UltraGraphQL](https://github.com/DrSnowbird/UltraGraphQL)
   * [UltraGraphQL-docker](https://github.com/DrSnowbird/UltraGraphQL-docker)
* HyerGrahQL:
   * [HyberGraphQL-Upstream](https://github.com/hypergraphql/hypergraphql)
   * [HyberGraphQL](https://github.com/DrSnowbird/HyperGraphQL)
   * [HyberGraphQL-docker](https://github.com/DrSnowbird/HyperGraphQL-docker)

# Build (do this first!)
```
./build.sh
```

# Run
* Use the command below to enter the Container:
```
./run.sh bash
```
* Default, this will bring you into the Container /home/developer/app folder. From there you can manually do your experiment.
```
cd ~/app/examples/one-service
java -jar $HOME/app/UltraGraphQL/build/libs/ultragraphql-1.1.4-exe.jar --config config.json
```

# Run (demo with default setup)
1. Don't start the Container yet.
2. Modify the 'config/config.json' file to provide specific remote SPARQL Endpoint URL: 
   You need to modify "url" value for your actual SPARQL Endpoint URL.
```
{
  "name": "query-persons-and-cars",
  "extraction": true,
  "server": {
    "port": 8000,
    "graphql": "/graphql",
    "graphiql": "/graphiql"
  },
  "services": [
    {
      "id": "dataset",
      "type": "SPARQLEndpointService",
      "url": "http://192.168.0.124:13030/persons_and_cars/",
      "graph": "",
      "user": "",
      "password": ""
    }
  ]
}
```
3. Then, run the container:
```
./run.sh
```
* You will see something like the output below:
```
    | | | | | |_ _ __ __ _ / ___|_ __ __ _ _ __ | |__  / _ \| |
    | | | | | __| '__/ _` | |  _| '__/ _` | '_ \| '_ \| | | | |
    | |_| | | |_| | | (_| | |_| | | | (_| | |_) | | | | |_| | |___
     \___/|_|\__|_|  \__,_|\____|_|  \__,_| .__/|_| |_|\__\_\_____|
                                          |_|
----------------------------------------------------------------------

18:40:48 INFO  Application :: Starting controller...
HGQL service name: query-persons-and-cars
GraphQL server started at: http://localhost:8000/graphql
GraphiQL UI available at: http://localhost:8000/graphiql
```

* And, then use your web-browser to access the URLs above. Note the ports, default, is mapped to 48000. Hence, you need to access URL as
```
GraphQL server started at: http://<your-docker-host-IP>:48000/graphql
GraphiQL UI available at: http://<your-docker-host-IP>:48000/graphiql
e.g.,
http://localhost:48000/graphiql
```

# Pull image from Docker Repository

```
docker pull openkbs/ultragraphql-docker
```

# Create your own image from this

```
FROM openkbs/ultragraphql-docker
```

# Quick commands
* build.sh - build local image
* logs.sh - see logs of container
* run.sh - run the container
* shell.sh - shell into the container
* stop.sh - stop the container
