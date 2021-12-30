#!/bin/bash

# https://github.com/hypergraphql/hypergraphql/releases/latest
#DEFAULT_URL=https://github.com/hypergraphql/hypergraphql/releases
DEFAULT_URL=https://github.com/DrSnowbird/UltraGraphQL-docker/releases

function usage() {
    echo "Usage:"
    echo "$(basename $0) -f <CONFIG_FILE> -k <CONFIG_KEY> -r <RELEASE_URL> [ -l <LATEST_RELEASE_URL> ]"
    echo "e.g."
    echo "    $(basename $0) -f ./Dockerfile -k HGQL_VERSION_LATEST -r ${DEFAULT_URL}"
    echo "    $(basename $0) -f ./Dockerfile -k HGQL_VERSION_LATEST -r ${DEFAULT_URL} -l ${DEFAULT_URL}/latest"
    echo "    $(basename $0) -f ./.env -k HGQL_VERSION_LATEST -r ${DEFAULT_URL}"
    echo "    $(basename $0) -f ./.enve -k HGQL_VERSION_LATEST -r ${DEFAULT_URL} -l ${DEFAULT_URL}/latest"
    echo
}

CONFIG_FILE=
CONFIG_KEY=
CONFIG_VALUE=

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -r|--releaseURL)
      RELEASE_URL=$2
      shift 2
      ;;
    -l|--latestURL)
      LATEST_RELEASE_URL=$2
      shift 2
      ;;
    -f|--configFile)
      CONFIG_FILE=$2
      shift 2
      ;;
    -k|--keyword)
      CONFIG_KEY=$2
      shift 2
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      usage
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

echo "remiaing args:"
echo $@


if [ "${CONFIG_FILE}" != "" ] && [ "${CONFIG_KEY}" != "" ] && [ "${RELEASE_URL}" != "" ]; then
    echo "CONFIG_KEY=${CONFIG_KEY}"
    echo "CONFIG_FILE=${CONFIG_FILE}"
    echo "RELEASE_URL=${RELEASE_URL}"
    echo "... OK to proceed"
else
    echo -e "*** ERROR: missing one of the arguments, CONFIG_FILE, CONFIG_KEY, RELEASE_URL"
    echo -e "*** ABORT!"
    usage
    exit 2
fi
# e.g. https://github.com/hypergraphql/hypergraphql/releases
GIT_BASE=https://github.com

RELEASE_URL=${RELEASE_URL:-${DEFAULT_URL}} 
LATEST_RELEASE_URL=${LATEST_RELEASE_URL:-${RELEASE_URL}/latest}

DEFAULT_VERSION=
ARCHIVE_PATTERN=".jar|.zip|.tar.gz|.tgz"

#ARCHIVE_PATTERN=".jar"
function get_latest_release_url() {
    #REGEX_VERSION="^.*\/releases\/tag\/([0-9]+\.[0-9]+\.[0-9]+)\".*$"
    REGEX_VERSION="^.*\/releases\/tag\/(.+)\".*$"
    ## -- possibly: need to modify line below to match the latest download URL specifically -- ##
    LATEST_JAR=${GIT_BASE}`curl --silent ${RELEASE_URL} | grep -E "${ARCHIVE_PATTERN}"| grep href | head -n 1 | cut -d'"' -f2`
    [[ `curl --silent ${LATEST_RELEASE_URL}` =~ ${REGEX_VERSION} ]] && LATEST_VERSION=${BASH_REMATCH[1]}
}
get_latest_release_url
echo "LATEST_JAR    =${LATEST_JAR}"
echo "LATEST_VERSION=${LATEST_VERSION}"


#### ---- Replace target Files: e.g., Dockerfile, .env, etc. ---- ####
CONFIG_VALUE=${LATEST_VERSION}
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
if [ "${LATEST_VERSION}" != "" ]; then
    replaceValueInConfig ${CONFIG_FILE} ${CONFIG_KEY} ${CONFIG_VALUE}
    #make build
else 
    echo "*** ERROR: can't find LATEST_VERSION from the given release URL: ${RELEASE_URL}"
    echo "*** ABORT!"
    usage
    exit 3
fi

echo -e {CONFIG_FILE} ${CONFIG_KEY} ${CONFIG_VALUE}
echo -e ${LATEST_VERSION} ${LATEST_JAR}

