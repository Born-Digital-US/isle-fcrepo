FROM tomcat:8.5-jdk8

ENV CATALINA_HOME /usr/local/tomcat \
    PATH $CATALINA_HOME/bin:$PATH

## Dependencies
RUN GEN_DEP_PACKS="curl" && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends $GEN_DEP_PACKS && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Tomcat Users
# can this be a config file / rootfs (preconfigure please with .env ?)
RUN sed -i '$i<role rolename="fedoraUser"/>$i<role rolename="fedoraAdmin"/>$i<role rolename="manager-gui"/>$i<user username="testuser" password="password1" roles="fedoraUser"/>$i<user username="adminuser" password="password2" roles="fedoraUser"/>$i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>$i<user username="fedora4" password="fedora4" roles="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml

# JAVA_OPTS - Adding the Fedora Variables to JAVA_OPTS
# Should be a config file no?
# How to link back to env?

# put all fcrepo opts in here for all configs
# envs in javaopts, pick a modeshape config
RUN echo 'JAVA_OPTS="$JAVA_OPTS -Dfcrepo.modeshape.configuration=classpath:/config/'$ModeshapeConfig'/repository.json '$JDBCConfig' -Dfcrepo.home=/mnt/ingest -Dfcrepo.audit.container=/audit"' > $CATALINA_HOME/bin/setenv.sh \
	&& chmod +x $CATALINA_HOME/bin/setenv.sh

# which configs to use for islandora?
# JAVA_OPTS:  qadan
# this is file system which is not prod ready
-Dfcrepo.modeshape.configuration=file:///opt/fcrepo/config/repository.json
-Dfcrepo.home=/opt/fcrepo/data 
-Dfcrepo.spring.configuration=file:///opt/fcrepo/config/fcrepo-config.xml

# JAVA_OPTS: fcrepo4
-Dfcrepo.modeshape.configuration=classpath:/config/'$ModeshapeConfig'/repository.json '$JDBCConfig' 
-Dfcrepo.home=/mnt/ingest
-Dfcrepo.audit.container=/audit

# JAVA_OPTS: official doc instructions for config
# customize repo.json file
JAVA_OPTS="${JAVA_OPTS} -Dfcrepo.modeshape.configuration=classpath:/config/jdbc-mysql/repository.json"
JAVA_OPTS="${JAVA_OPTS} -Dfcrepo.mysql.username=<username>"
JAVA_OPTS="${JAVA_OPTS} -Dfcrepo.mysql.password=<password>"
JAVA_OPTS="${JAVA_OPTS} -Dfcrepo.mysql.host=<default=localhost>"
JAVA_OPTS="${JAVA_OPTS} -Dfcrepo.mysql.port=<default=3306>"


### Fedora Install
# https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-5.1.0/fcrepo-webapp-5.1.0.war
# write an env for version number ala ISLE 7

# Install Fedora 5
ARG FEDORA_TAG=
ARG FedoraConfig=
# https://github.com/fcrepo4/fcrepo4/tree/5.1.x-maintenance/fcrepo-configs/src/main/resources/config
ARG ModeshapeConfig=jdbc-mysql-repository
ARG JDBCConfig=


RUN cd /tmp \
	&& curl -fSL https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-$FEDORA_TAG/fcrepo-webapp-$FEDORA_TAG.war -o fcrepo.war \
	&& cp fcrepo.war /usr/local/tomcat/webapps/fcrepo.war

# Add the /opt/fcrepo directory and contents
COPY rootfs /

RUN chown -Rv tomcat:tomcat /opt/fcrepo && \  
    chmod -Rv 644  /opt/fcrepo/config && \


### ----------------- Data Mounts / Volumes  -----------------
## From Fedora docs
mkdir -p /opt/fcrepo/data/objects
^ everything is populated under

# This should be bind mounted
if using a database which one or is the database remote 
# database, file store or S3 option (not well tested)

### ----------------- SYN -----------------

ENV SYN_JAR_URL: The latest stable release of the Syn JAR from the releases page. Specifically, the JAR compiled as -all.jar is required.
wget -P /opt/tomcat/lib SYN_JAR_URL
# Ensure the library has the correct permissions.
chown -R tomcat:tomcat /opt/tomcat/lib
chmod -R 640 /opt/tomcat/lib

# Placeholder for Generating an SSL Key for Syn
# microservices and SYN use this key pair (private and public) and share it
# pregenerate key and bind mount

# shared volume = Ansible role locally passes key

# /opt/fcrepo/config/syn-settings.xml

# Placeholder for Adding the Syn Valve to Tomcat

# restart tomcat


## Volume Fedora Data
VOLUME /usr/local/fedora/data/activemq-data /usr/local/fedora/data/datastreamStore \
    /usr/local/fedora/data/fedora-xacml-policies /usr/local/fedora/data/objectStore \
    /usr/local/fedora/data/resourceIndex

EXPOSE 8080

# or is this /opt/fcrepo
WORKDIR /usr/local/tomcat 

ENTRYPOINT ["/init"]