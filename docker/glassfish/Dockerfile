FROM  debian:11.8-slim
MAINTAINER pollochang

################################################################################

RUN apt update;  \
	apt upgrade -y; \
  apt install -y curl libfreetype6; \
  apt-get -y clean all; \
  dpkg remove -y apt; \
	rm -rf /var/lib/apt/lists/*;

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Due to JDK version bug we need a specific version of openjdk6
ADD jdk1.6.0_45.tar.gz /usr/lib/jvm/
ENV JAVA_VERSION 6u45
ENV JAVA_HOME /usr/lib/jvm/jdk1.6.0_45
ENV PATH=$PATH:$JAVA_HOME/bin

# Configure ENV variables for glassfish and ant
ENV GLASSFISH_HOME /usr/lib/glassfish
ENV ANT_VERSION 1.6.5
ENV ANT_HOME $GLASSFISH_HOME/lib/ant
ENV PATH=$PATH:$GLASSFISH_HOME/bin:$ANT_HOME/bin

ADD glassfish-installer-v2.1.1-b31g-linux.jar /usr/lib

WORKDIR /usr/lib

RUN \
  echo A | java -jar glassfish-installer-v2.1.1-b31g-linux.jar && \
  # remove jar to save space
  rm -f glassfish-installer-v2.1.1-b31g-linux.jar && \
  cd $GLASSFISH_HOME && \
  # Remove Windows .bat and .exe files to save space
  find . -name '*.bat' -delete && \
  find . -name '*.exe' -delete && \
  # configure executables and run setup
  chmod -R +x lib/ant/bin && \
  lib/ant/bin/ant -f setup.xml && \
  chmod a+x bin/asadmin && \
  # remove expired key from certificate (SEC5054 Certificate has expired error)
  # solution from: https://stackoverflow.com/a/19591433/1700053
  keytool -storepass changeit -delete -v -alias gtecybertrustglobalca -keystore $GLASSFISH_HOME/domains/domain1/config/cacerts.jks && \
  keytool -storepass changeit -delete -v -alias gtecybertrust5ca -keystore $GLASSFISH_HOME/domains/domain1/config/cacerts.jks && \
  keytool -storepass changeit -delete -v -alias verisignserverca -keystore $GLASSFISH_HOME/domains/domain1/config/cacerts.jks
  # set corba warning level to SEVERE on domain 1 so we don't see JDK version warning
  # solution from: https://stackoverflow.com/a/19692823/1700053
  # asadmin start-domain domain1 && asadmin set server.log-service.module-log-levels.corba=SEVERE && asadmin stop-domain domain1



# Export every lib folder from Glassfish into a classpath var
ENV GLASSFISH_CLASSPATH $GLASSFISH_HOME/lib/*:$GLASSFISH_HOME/domains/domain1/lib/*:$GLASSFISH_HOME/lib/install/applications/admingui/adminGUI_war/WEB-INF/lib/*:$GLASSFISH_HOME/lib/SUNWjdmk/5.1/lib/*:$GLASSFISH_HOME/lib/ant/lib/*:$GLASSFISH_HOME/jbi/lib/*:$GLASSFISH_HOME/javadb/lib/*:$GLASSFISH_HOME/javadb/demo/programs/localcal/lib/*:$GLASSFISH_HOME/updatecenter/lib/*:$GLASSFISH_HOME/imq/lib/*


# swjweb 客製

ADD ojdbc6.jar ${GLASSFISH_HOME}/domains/domain1/lib/ext
ADD db2jcc.jar ${GLASSFISH_HOME}/domains/domain1/lib/ext
ADD db2jcc_license_cu.jar ${GLASSFISH_HOME}/domains/domain1/lib/ext

RUN groupadd -g 501 glassfish
RUN useradd -u 501 -g 501 -s /sbin/bash -d ${GLASSFISH_HOME} glassfish
RUN chown -R glassfish:glassfish ${GLASSFISH_HOME}

USER glassfish

WORKDIR ${GLASSFISH_HOME}

# Expose ports for admin panel and websites
# localhost:4848 -> user:admin ; pwd:adminadmin
EXPOSE 8080 4848 8686

# Start the GlassFish domain
CMD ["asadmin", "start-domain", "--verbose"]