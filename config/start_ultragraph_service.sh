#!/bin/bash -x

env
whoami

env|grep -i UGQL
env|grep -i HOST

UGQL_VERSION=${UGQL_VERSION:-1.1.4}
UGQL_CONFIG=${UGQL_CONFIG:-${HOME}/app/}

echo -e ">>> UGQL_VERSION: ${UGQL_VERSION}"
echo -e ">>> UGQL_CONFIG: ${UGQL_CONFIG}"

cd ${UGQL_CONFIG}

echo -e ">>> HOST_IP: ${DOCKER_HOST_IP}"
echo -e ">>> HOST_NAME: ${DOCKER_HOST_NAME}"

SPARQL_ENDPOINT=`cat config.json|grep http|grep url`
if [ "${SPARQL_ENDPOINT}" != "" ]; then
    sed "s/0\.0\.0\.0/${DOCKER_HOST_IP}/g" config.json | tee config.json.tmp
else
    echo -e "Local TTL Sparql config.json ..."
    cp config.json config.json.tmp
fi
echo -e ">>> config.json Contents:\n"
cat config.json.tmp

# java -jar ${HOME}/app/UltraGraphQL/build/libs/ultragraphql-1.1.4-exe.jar --config config.json
java -jar ${HOME}/app/UltraGraphQL/build/libs/ultragraphql-${UGQL_VERSION}-exe.jar --config config.json.tmp
