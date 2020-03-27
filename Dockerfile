FROM borndigital/isle-fcrepo-base:mvp3-alpha

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

#ENV TOMCAT_MAJOR=${TOMCAT_MAJOR:-8} \
#    TOMCAT_VERSION=${TOMCAT_VERSION:-8.5.53}
#
#RUN cd /tmp && \
#    curl -O -L "http://apache.mirrors.pair.com/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz" && \
#    tar xzf /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
#    cp -Rv /tmp/apache-tomcat-$TOMCAT_VERSION/webapps/ROOT /usr/local/tomcat/webapps/ && \
#    cp -Rv /tmp/apache-tomcat-$TOMCAT_VERSION/webapps/host-manager /usr/local/tomcat/webapps/ && \
#    cp -Rv /tmp/apache-tomcat-$TOMCAT_VERSION/webapps/manager /usr/local/tomcat/webapps/ && \
#    rm -rf /tmp/apache-tomcat-$TOMCAT_VERSION

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