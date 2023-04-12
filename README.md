# UltraGraphQL-docker (Based upon UltraGraphQL)
* A UltraGraphQL-docker Container with `no root access` (except using `sudo ...` and you can remove it using `sudo apt-get remove sudo` to protect your Container). 
```
If [ you are looking for such a common requirement as a base Container ] and 
   [ UltraGraphQL inside the container ]:
   Then [ this one may be for you ]
```
# Optional RDF Docker Services to work together:
* Apache Jena Fuseki: e.g. [openkbs/jena-fuseki-docker](https://github.com/DrSnowbird/jena-fuseki-docker) (verified! and recommended!)
* Eclipse RDF4J: e.g., [openkbs/rdf4j-docker](https://github.com/DrSnowbird/rdf4j-docker) (Not verified!)
* UCO SHACL Validator: e.g., [uco-shacl-validator-docker](https://github.com/DrSnowbird/uco-shacl-validator-docker)

# Components:
* UltraGraphQL
* No root setup: using /home/developer 
  * It has sudo for dev phase usage. You can "sudo apt-get remove sudo" to finalize the product image.
  * Note, you should consult Docker security experts in how to secure your Container for your production use!)
* Gradle: v7.3.3
* Java: v11

# Release
* This is also a fix to mitigate the Log4Shell vulnerability.
   * update to the latest versions to avoid the Log4Shell vulnerability

# Build (do this first!)
```
./build.sh
```


# Build (Optional, when encountering GIT SSL issues)
* If your Docker is located inside corporate SSL firewall, the build might fail.
* To workaround, you want to use the 'Dockerfile-copy-jar' instead, do the followings:
```
cp Dockerfile Dockerfile.ORIG
cp Dockerfile-copy-jar Dockerfile

make build
```


# (optional) Run (manual setup and run)
* You can manually go into the container to play around, setup differently, and run - if you like to.
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
2. First, you modify the 'config/config.json' file to provide specific remote SPARQL Endpoint URL: 
   You need to modify "url" value for your actual SPARQL Endpoint URL, e.g., 
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

# Related Projects
* UltraGraphQL:
   * [UltraGraphQL-Upstream](https://git.rwth-aachen.de/i5/ultragraphql)
   * [UltraGraphQL](https://github.com/DrSnowbird/UltraGraphQL)
   * [UltraGraphQL-docker](https://github.com/DrSnowbird/UltraGraphQL-docker)
* HyperGrahQL:
   * [HyperGraphQL-Upstream](https://github.com/hypergraphql/hypergraphql)
   * [HyperGraphQL](https://github.com/DrSnowbird/HyperGraphQL)
   * [HyperGraphQL-docker](https://github.com/DrSnowbird/HyperGraphQL-docker)


# ==== README.md from Original UltraGrapQL ====
### Note: Docker version Guide (see above)
### The following is for reference only
### Source: [UltraGraphQL](https://git.rwth-aachen.de/i5/ultragraphql/-/blob/master/README.md) 
# [<img src="./docs/figures/HyperGraphQL.png" width="30">](hypergraphql-logo.svg) UltraGraphQL

UltraGraphQL is a [GraphQL](https://graphql.org/) interface for querying and modifying RDF data on the Web.
It extends [HyperGraphQL](https://www.hypergraphql.org/) by providing a automatic bootstrapping phase of the service and a more feature rich schema support with additional support for GraphQL mutations.
Because it is based on HyperGraphQL features like the support of federated querying and exposing data from multiple linked data services using GraphQL query language and schemas were maintained and extended.
The core of the response is a JSON-LD object, which extends the standard JSON with the JSON-LD context enabling semantic disambiguation of the contained data.

![](./docs/figures/ugql_linked_data_access.png)

## Table of Contents
* [Features](#features)
   * [Bootstrapping](#bootstrapping-optional)
   * [Queries](#queries)
   * [Mutations](#mutations)
* [Examples](#examples)
* [Getting started](#getting-started)
* [Documentation](#documentation)
* [Differences to HyperGraphQL](#differences-to-hypergraphql)
* [Licence note](#license-note)

## Features

### Bootstrapping (OPTIONAL)
> Only needs to be done if the schema is not known or was updated

> Requirements: All service of the type SPARQLEndpointService **MUST** allow *SPARQL 1.1* queries and the runtime limitation **SHOULD** be deactivated because the schema summarization can have a long execution time on large datasets.

If the schema extraction is enabled in the configuration, no schema is required to start UGQL.
UGQL will summarize the RDF schema from the defined services and map the summarized schema to a corresponding UGQL schema as shown in the Figure.
The default [extraction query](./docs/schema_extraction_query.md) and [schema vocabulary](./docs/schema_mapping.md) used to summarize the schema are by [Gleim et. al.](https://jbiomedsem.biomedcentral.com/articles/10.1186/s13326-020-00223-z) ([PDF](https://jbiomedsem.biomedcentral.com/track/pdf/10.1186/s13326-020-00223-z)) and can be configured if needed.
This [example](./examples/extended_mapping/README.md) shows how to configure the schema vocabulary and the effect those changes.
If multiple service are defined in the configuration the schema is summarized on all services and then mapped to one unified schema

![Abstract example of the schema summarization and mapping](./docs/figures/bootstrapping_example.png  "Abstract overview of the bootstrapping phase")

### Queries
For each object type of the provided or extracted schema a query field is generated.
To query for specific IRIs (IDs in UGQL) the argument **_id** can be used to filter for the provided IRIs.
A detailed description of the query translation and is provided [here](./docs/translation_phase.md) and an overview of all possible query modifiers is provided [here](./docs/query_modifiers.md).
To test the different features of UGQL the provided [examples](examples/README.md) can be used to write and test the query features.

> Note: The service MUST not be defined in the query. Based on the UGQL schema (UGQLS) the different services will be queried accordingly.

[![](./docs/figures/ugql_query_schematic.png)](./docs/figures/ugql_query_schematic.svg)

### Mutations
Insert and delete mutations are [generated](./docs/translation_phase.md#mutation-translation) for each object type of the UGQLS which corresponds to the output type of the mutation allowing to directly query the modified data.
The mutation actions are only performed on one service of the services defined in the configuration.

As shown in the examples the mutations allow to insert and delete object data.
In case of the delete mutation the performed action depends on the provided information.
Allowing deletions based on matching criterions.
Detailed information about the mutations can be found [here](docs/mutations.md).

```graphql
mutation{
    insert_ex_Person(_id: "https://example.org/Bob", ex_name: "Bob", ex_age: "42", ex_relatedWith: {_id: "https://example.org/Alice"}){
        _id
        ex_name
        ex_relatedWith{
            ex_name
        }
    }
}
```
```graphql
mutation{
    delete_ex_Person(_id: "https://example.org/Bob", ex_name: "Bob", ex_age: "42", ex_relatedWith: {_id: "https://example.org/Alice"}){
        _id
        ex_name
        ex_relatedWith{
            ex_name
        }
    }
}
```
## Examples
A set of examples is avaliable [here](examples/README.md), featuring different use cases and features of UGQL.

## Getting Started
You may find prebuilt nightly binaries [here](https://git.rwth-aachen.de/i5/ultragraphql/-/jobs/artifacts/master/browse/build/libs/?job=build).

### Building from Source
To build an executable UGQL jar run
```bash
gradle clean build shadowJar
```
This will generate the two jars:
- ultragraphql-< version >.jar
  - e.g. ultragraphql-1.0.0.jar
- ultragraphql-< version >-exe.jar
  - e.g. ultragraphql-1.0.0-exe.jar

A UGQL instance can then be started with the command
```bash
java -jar build/libs/<exe-jar> --config <path to config>
```

For example UGQL service setups look into the [examples](examples/README.md) and their configurations.


## Documentation
A detailed documentation about the endpoint configuration, query writing and internal query translation is provided [here](./docs/README.md).

-----------------------------------------

## Differences to HyperGraphQL
- Automatic bootstrapping phase (through schema summarization)
  - Configurable summarization querying
  - Configurable mapping vocabulary
- Mutation support
  - Insert and delete mutation fields are generated for all objects in the schema
  - Mutation action is limited to one service (MUST be LocalModelSPARQLService or SPARQLEndpointService)
- Support for [multiple services](./docs/multiple_service_feature.md) per schema entity
- Support of equivalence relations in the schema and during querying
- [Interafaces](./docs/interface.md) and [Unions](./docs/union.md) supported in the schema
- Filter options now also avaliable for fields (prior only avaliable for the root query fields)
- Simplified query naming schema
- Additional web server framework to host the UltraGraphQL instance to allow multiple instances running on the same system
- Simplified and more efficient result transformation (v1.1.0 or higher)

### License note:
 This software is a further development of HyperGraphQL which has been developed and is maintained by [Semantic Integration Ltd.](http://semanticintegration.co.uk). It is released under Apache License 2.0. See [LICENSE.TXT](https://github.com/semantic-integration/hypergraphql/blob/master/LICENSE.TXT) for more infromation.
