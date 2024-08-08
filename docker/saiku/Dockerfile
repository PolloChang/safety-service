FROM  debian:11.8-slim

RUN apt update;  \
	apt upgrade -y; \
  apt install -y curl libfreetype6 fontconfig; \
  apt-get -y clean all; \
  dpkg remove -y apt; \
	rm -rf /var/lib/apt/lists/*;

ENV JAVA_BASE /usr/local/lib/jvm
ENV JAVA_HOME ${JAVA_BASE}/jdk1.7.0_80
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_VERSION jre-7u80
ENV PATH $CATALINA_HOME/bin:$PATH
ENV SAIKU_HOME /usr/local/saiku-server

RUN mkdir -p ${JAVA_BASE}

ADD jdk-7u80-linux-x64.tar.gz ${JAVA_BASE}

COPY saiku-server /usr/local/saiku-server

RUN mkdir -p ${JAVA_HOME}


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