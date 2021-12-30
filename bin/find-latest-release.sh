#!/bin/bash

# https://github.com/hypergraphql/hypergraphql/releases/latest
DEFAULT_URL=https://github.com/DrSnowbird/UltraGraphQL-docker/releases

if [ $# -lt 1 ]; then
    echo ">> ERROR: missing input argment, RELEASE_URL and/or LATEST_RELEASE_URL"
    echo "Usage:"
    echo "$(basename $0) <RELEASE_URL> [ <LATEST_RELEASE_URL> ]"
    echo "e.g."
    echo "    $(basename $0) ${DEFAULT_URL} ${DEFAULT_URL}/latest"
    echo
    exit 1
fi
# e.g. https://github.com/hypergraphql/hypergraphql/releases
GIT_BASE=https://github.com

RELEASE_URL=${1:-${DEFAULT_URL}} 
LATEST_RELEASE_URL=${2:-${RELEASE_URL}/latest}

DEFAULT_VERSION=0.0.0
LATEST_VERSION=$DEFAULT_VERSION
ARCHIVE_PATTERN=".jar|.zip|.tar.gz|.tgz"
function get_latest_release_url() {
    #REGEX_VERSION="^.*\/releases\/tag\/([0-9]+\.[0-9]+\.[0-9]+)\".*$"
    REGEX_VERSION="^.*\/releases\/tag\/(.+)\".*$"
    ## -- possibly: need to modify line below to match the latest download URL specifically -- ##
    LATEST_JAR=${GIT_BASE}`curl --silent ${RELEASE_URL} | grep -E "${ARCHIVE_PATTERN}"| grep href | head -n 1 | cut -d'"' -f2`
    [[ `curl --silent ${LATEST_RELEASE_URL}` =~ ${REGEX_VERSION} ]] && LATEST_VERSION=${BASH_REMATCH[1]}
}
get_latest_release_url
echo "LATEST_JAR= ${LATEST_JAR}"
echo "LATEST_VERSION= ${LATEST_VERSION}"

#CONFIG_FILE=./Dockerfile
#CONFIG_KEY="PRODUCT_VERSION"
#CONFIG_VALUE=${LATEST_VERSION}
#### ---- Replace target Files: e.g., Dockerfile, .env, etc. ---- ####
function replaceValueInConfig() {

    FILE=${1}
    KEY=${2}
    VALUE=${3}
    #sed -i 's#^ENV[[:blank:]]*'$KEY'[[:blank:]]*=.*/ENV '$KEY'='$VALUE'#gm' $FILE
    #sed -i 's#^ARG[[:blank:]]*'$KEY'[[:blank:]]*=.*#ARG '$KEY'='$VALUE'#gm' $FILE
    sed -i 's#^\(ARG\|ENV\)[[:blank:]]*'$KEY'[[:blank:]]*=.*#\1 '$KEY'='"$VALUE"'#gm' $FILE
    echo "results (after replacement) with new value:"
    cat $FILE |grep "${CONFIG_KEY}"
}
#replaceValueInConfig ${CONFIG_FILE} ${CONFIG_KEY} ${CONFIG_VALUE}
#make build

echo -e ${LATEST_VERSION} ${LATEST_JAR}
