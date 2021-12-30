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

# Run (recommended for easy-start)
```
./run.sh
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
