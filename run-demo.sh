#!/bin/bash -x

set -e

whoami
id

env |grep -i gql|sort

#### ---------------------------------------------------------------------- ####
#### ---- Per APP or Config specifics => Change the following          ---- ####
#### ---------------------------------------------------------------------- ####
#### ---- <<< Change below >>> ---- ####
#### ---- Config directory:    ---- ####
PRODUCT_CONFIG_DIR=${UGQL_CONFIG:-$HOME/app/config}
echo "--->>> PRODUCT_CONFIG_DIR=${PRODUCT_CONFIG_DIR}"

#### ---- <<< Change below >>> ---- ####
#### ---- Update the UGQL_VERSION to whatever specifics (TO-DO for customization per app): ---- ####
#### ---- (Changed UGQL_VERSION to specific target product version variable for specific customization): ---- ####
PRODUCT_VERSION=${UGQL_VERSION}
GIT_URL=https://github.com/DrSnowbird/UltraGraphQL.git

#### ====================================================================== ####
#### ==== Mostly, you don't need to modify below (generic code below): ==== ####
#### ====================================================================== ####
PRODUCT=`echo $(basename ${GIT_URL%%.git}) | tr '[:upper:]' '[:lower:]' `
echo "--->>> PRODUCT=${PRODUCT}"

# `./find-latest-release.sh https://github.com/DrSnowbird/UltraGraphQL/releases|grep LATEST_VERSION|cut -d'=' -f2`
PRODUCT_VERSION_LATEST=`$HOME/bin/find-latest-release.sh ${GIT_URL%%.git}/releases|grep LATEST_VERSION|cut -d'=' -f2`
PRODUCT_VERSION=${PRODUCT_VERSION:-PRODUCT_VERSION_LATEST}
echo ">>> PRODUCT_VERSION_LATEST=${PRODUCT_VERSION_LATEST}"
echo ">>> PRODUCT_VERSION=${PRODUCT_VERSION}"

# e.g.
#   https://github.com/DrSnowbird/UltraGraphQL/releases/download/1.1.4/ultragraphql-1.1.4-exe.jar
JAR_URL=${GIT_URL%%.git}/releases/download/${PRODUCT_VERSION}/${PRODUCT}-${PRODUCT_VERSION}-exe.jar
      
#### ---- Setup for running: ---- ####
cd ${APP_HOME:-$HOME/app}

## -- build from DrSnowbird GIT source: --- ##
GIT_DIR=$(basename ${GIT_URL%%.git})
JAR_EXE=$(basename ${JAR_URL})
JAR_EXE_PATH=${APP_HOME}/${GIT_DIR}/build/libs/${JAR_EXE}
function download_and_build_git() {
    git clone ${GIT_URL}
    if [ ! -s ${GIT_DIR} ]; then
        cd ${GIT_DIR}
        gradle clean build shadowJar
        ls -al $(find ./build -name "*.jar")
        if [ ! -s ./build/libs/${JAR_EXE} ]; then
             echo -e "*** ERROR: can't find  ${APP_HOME}/${GIT_DIR}/${JAR_EXE}"
             echo -e "--- Abort now!"
             exit 1
        fi
    else
        echo "*** ERROR: can't find GIT local directory: ${GIT_DIR}"
        exit 1
    fi
    if [ -s ${APP_HOME}/${GIT_DIR}/build/libs/${JAR_EXE} ]; then
         echo -e "*** ERROR: can't find  ${APP_HOME}/${GIT_DIR}/build/libs/${JAR_EXE}"
         echo -e "--- Abort now!"
         exit 1
    fi
    JAR_EXE_PATH=${APP_HOME}/${GIT_DIR}/build/libs/${JAR_EXE}
}

# -- build/download GIT and jar: -- ##
function download_git_and_jar() {
    if [ ! -s ${APP_HOME}/${GIT_DIR} ]; then
        cd ${APP_HOME}
        git clone ${GIT_URL}
        cd ${GIT_DIR} 
        wget -cq ${JAR_URL}
        ls -al $(find . -name "*.jar")
    else
        echo "*** ERROR: can't find GIT local directory: ${GIT_DIR}"
        exit 1
    fi
    if [ ! -s ${APP_HOME}/${GIT_DIR}/${JAR_EXE} ]; then
         echo -e "*** ERROR: can't find  ${APP_HOME}/${GIT_DIR}/${JAR_EXE}"
         echo -e "--- Abort now!"
         exit 1
    fi
    JAR_EXE_PATH=${APP_HOME}/${GIT_DIR}/${JAR_EXE}
}

if [ ! -s ${JAR_EXE_PATH} ]; then
    echo -e "*** ERROR: can't find  ${JAR_EXE_PATH}"
    echo -e "--- Abort now!"
    exit 1
else
    echo ">>> Ready to run: --> JAR_EXE_PATH=${APP_HOME}/${GIT_DIR}/build/libs/${JAR_EXE}"
fi
    
echo ">>> Run demo_services:"
echo ">>>"

CONFIG_JSON_FILES=""
function multi_config_subdirs() {
    cd ${PRODUCT_CONFIG_DIR}
    #### ---- Loop to find subdir in the PRODUCT_CONFIG_DIR: ---- ####
    for conf_dir in `ls -d ${PRODUCT_CONFIG_DIR}/`; do
        for conf_file in `ls ${conf_dir}config*.json `; do
            CONFIG_JSON_FILES="${CONFIG_JSON_FILES} ${conf_file}"
        done
    done
}
multi_config_subdirs

java -jar ${JAR_EXE_PATH} -config ${CONFIG_JSON_FILES}

