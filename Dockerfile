FROM islandora/isle-fcrepo-base:sp4-alpha

ENV CATALINA_HOME=/usr/local/tomcat \
    PATH=$CATALINA_HOME/bin:$PATH \
    FCREPO_AUTH_HEADER_NAME=X-Islandora \
    JMS_BROKER_URL=tcp://activemq:61616 \
    JAVA_MAX_MEM=${JAVA_MAX_MEM:-2G} \
    JAVA_MIN_MEM=${JAVA_MIN_MEM:-512M} \
    JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true' \
    FCREPO_VERSION=${FCREPO_VERSION:-5.1.0} \
    FCREPO_HOME=/opt/fcrepo/data \
    FCREPO_CONFIG_DIR=/opt/fcrepo/config \
    # jdbc-mysql, jdbc-postgresql, file-simple
    FCREPO_MODESHAPE_TYPE=jdbc-mysql \
    FCREPO_AUDIT_CONTAINER=audit \
    FCREPO_SPRING_CONFIG=fcrepo-config.xml \
    FCREPO_NAMESPACES=claw \
    FCREPO_DB_TYPE=mysql \
    FCREPO_DB=fcrepo_db \
    FCREPO_DB_USER=fedora \
    FCREPO_DB_PASSWORD=fedora_pw \
    FCREPO_DB_HOST=mariadb \
    FCREPO_DB_PORT=3306 \
    FCREPO_USER=fedoraUser \
    FEDORA_USER_PASSWORD=fedoraUser_pw \
    FEDORA_ADMIN=fedoraAdmin \
    FEDORA_ADMIN_PASSWORD=fedoraAdmin_pw


## Install Tomcat admin

# Official tomcat docker image doesn't enable these by default
# https://github.com/docker-library/tomcat/issues/184
RUN cp -rv /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/manager && \
    cp -rv /usr/local/tomcat/webapps.dist/host-manager /usr/local/tomcat/webapps/host-manager && \
    cp -rv /usr/local/tomcat/webapps.dist/ROOT /usr/local/tomcat/webapps/ROOT && \
    sed -i 's/<Valve/<\!\-\-\ \n \<Valve/' /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    sed -i 's/0:1" \/>/0:1\" \/> \n \-\->/' /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    sed -i 's/<Valve/<\!\-\-\ \n \<Valve/' /usr/local/tomcat/webapps/host-manager/META-INF/context.xml && \
    sed -i 's/0:1" \/>/0:1\" \/> \n \-\->/' /usr/local/tomcat/webapps/host-manager/META-INF/context.xml


### ----------------- SYN -----------------

ENV SYN_VERSION=${SYN_VERSION:-1.1.0}

# The latest stable release of the Syn JAR from the releases page. Specifically, the JAR compiled as -all.jar is required.
RUN cd /usr/local/tomcat/lib/ && \
    curl -O -L "https://github.com/Islandora/Syn/releases/download/v$SYN_VERSION/islandora-syn-$SYN_VERSION-all.jar" && \
    chmod -Rv 640 /usr/local/tomcat/lib

ARG FCREPO_CONFIG_DIR
ARG FCREPO_HOME

COPY rootfs /

EXPOSE 8080

WORKDIR /opt/fcrepo 

CMD ["catalina.sh", "run"]