ARG BASE=${BASE:-openkbs/java11-nonroot-docker}
FROM ${BASE}

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

#########################
#### ---- App:  ---- ####
#########################
USER ${USER:-developer}
WORKDIR ${HOME:-/home/developer}

ENV APP_HOME=${APP_HOME:-$HOME/app}
ENV APP_MAIN=${APP_MAIN:-setup.sh}
COPY --chown=$USER:$USER ./app $HOME/app

#########################################
##### ---- Setup: Entry Files  ---- #####
#########################################
COPY --chown=${USER}:${USER} docker-entrypoint.sh /
COPY --chown=${USER}:${USER} ${APP_MAIN} ${APP_HOME}/setup.sh
RUN sudo chmod +x /docker-entrypoint.sh ${APP_HOME}/setup.sh 

#########################################
##### ---- Docker Entrypoint : ---- #####
#########################################
ENTRYPOINT ["/docker-entrypoint.sh"]

#####################################
##### ---- user: developer ---- #####
#####################################
WORKDIR ${APP_HOME}
USER ${USER}

#####################################
##### ---- UltraGraphQL:   ---- #####
#####################################
# ref: 
# - paper:   http://ceur-ws.org/Vol-2722/quweda2020-paper-2.pdf
# - gitlab:  https://git.rwth-aachen.de/i5/ultragraphql
# - jar-exe: https://git.rwth-aachen.de/i5/ultragraphql/-/jobs/1662119/artifacts/browse/build/libs

#### ---- (Build jar / exe) ---- ####
#ARG UGQL_GIT=https://git.rwth-aachen.de/i5/ultragraphql.git
ARG UGQL_GIT=https://github.com/DrSnowbird/UltraGraphQL.git
RUN git clone ${UGQL_GIT} && cd $(basename ${UGQL_GIT%%.git}) && git pull --ff && \
    gradle clean build shadowJar && ls -al $(find ./build -name "*.jar")

#### ---- (download both UGQL & HGQL jar files to support run-demo.sh) ---- ####
#ARG HGQL_GIT=https://github.com/hypergraphql/hypergraphql.git
ARG HGQL_GIT=https://github.com/DrSnowbird/HyperGraphQL.git
RUN git clone ${HGQL_GIT} && cd $(basename ${HGQL_GIT%%.git}) && git pull --ff && \
    gradle clean build shadowJar && ls -al $(find ./build -name "*.jar")

#ARG HGQL_VERSION_LATEST=3.0.2
#ARG HGQL_JAR=https://github.com/hypergraphql/hypergraphql/releases/download/${HGQL_VERSION_LATEST}/hypergraphql-${HGQL_VERSION_LATEST}-exe.jar
#RUN wget -q --no-check-certificate ${HGQL_JAR}
    
#ARG UGQL_VERSION_LATEST=1.1.4
#ARG UGQL_JAR=https://git.rwth-aachen.de/i5/ultragraphql/-/jobs/1662119/artifacts/file/build/libs/ultragraphql-1.1.3-exe.jar
#RUN wget -q --no-check-certificate ${UGQL_JAR}

#### ---- (Script for Evaluation demo): ---- ####
COPY --chown=${USER}:${USER} run-demo.sh .

######################
#### (Test only) #####
######################
CMD ["/bin/bash"]
######################
#### (RUN setup) #####
######################
#CMD ["setup.sh"]

