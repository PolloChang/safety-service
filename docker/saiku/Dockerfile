# FROM frolvlad/alpine-openjdk7
FROM  debian:11.8-slim

RUN apt update;  \
	apt upgrade -y; \
  apt install -y curl libfreetype6 fontconfig; \
  apt-get -y clean all; \
  dpkg remove -y apt; \
	rm -rf /var/lib/apt/lists/*;

ENV JAVA_HOME /opt/java/openjdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_VERSION jre-7u80
ENV PATH $CATALINA_HOME/bin:$PATH
ENV SAIKU_HOME /usr/local/saiku-server

# ADD ${JAVA_VERSION}-linux-x64.tar.gz ${JAVA_HOME}

COPY saiku-server /usr/local/saiku-server

ENV JAVA_VERSION_1 8u392
ENV JAVA_VERSION_2 b08
RUN mkdir -p ${JAVA_HOME}
ADD OpenJDK8U-jre_x64_linux_hotspot_${JAVA_VERSION_1}${JAVA_VERSION_2}.tar.gz /tmp
RUN mv /tmp/jdk${JAVA_VERSION_1}-${JAVA_VERSION_2}-jre/* ${JAVA_HOME}


RUN groupadd -g 1500 saiku
RUN useradd -u 1500 -g 1500 -d ${SAIKU_HOME} -s /sbin/bash saiku
RUN mkdir -p ${SAIKU_HOME}/tomcat/logs
RUN mkdir -p ${SAIKU_HOME}/tomcat/work
RUN mkdir -p ${SAIKU_HOME}/tomcat/temp

RUN touch ${SAIKU_HOME}/tomcat/logs/saiku.log

RUN chown -R saiku:saiku ${SAIKU_HOME}

USER saiku

WORKDIR ${SAIKU_HOME}

EXPOSE 8080 8686

CMD ${SAIKU_HOME}/start-saiku.sh && tail -f ${SAIKU_HOME}/tomcat/logs/catalina.out ${SAIKU_HOME}/tomcat/logs/saiku.log