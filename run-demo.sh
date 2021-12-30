#!/bin/bash -x

set -e

cd ${APP_HOME:-$HOME/app}

GIT_URL=https://git.rwth-aachen.de/i5/ultragraphql.git
JAR_URL=https://git.rwth-aachen.de/i5/ultragraphql/-/jobs/1662119/artifacts/file/build/libs/ultragraphql-1.1.3-exe.jar

GIT_DIR=$(basename ${GIT_URL%%.git})
JAR_EXE=$(basename ${JAR_URL})
if [ ! -s ${APP_HOME}/${GIT_DIR} ]; then
    cd ${APP_HOME}
    git clone ${GIT_URL}
    cd ${GIT_DIR} 
    wget -cq ${JAR_URL}
    ls -al
fi
if [ ! -s ${APP_HOME}/${GIT_DIR}/${JAR_EXE} ]; then
     echo -e "*** ERROR: can't find  ${APP_HOME}/${GIT_DIR}/${JAR_EXE}"
     echo -e "--- Abort now!"
     exit 1
fi

echo ">>> To build locally: gradle clean build shadowJar"
echo ">>> Run demo_services:"
echo ">>>"

cd ${APP_HOME}/ultragraphql/src/test/resources
java -jar ${APP_HOME}/${GIT_DIR}/${JAR_EXE} -config \
    ${APP_HOME}/${GIT_DIR}/src/test/resources/demo_services/config1.json \
    ${APP_HOME}/${GIT_DIR}/src/test/resources/demo_services/config2.json \
    ${APP_HOME}/${GIT_DIR}/src/test/resources/demo_services/config3.json \
    ${APP_HOME}/${GIT_DIR}/src/test/resources/demo_services/config4.json
