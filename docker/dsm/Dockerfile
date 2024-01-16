# FROM frolvlad/alpine-openjdk7
FROM  debian:11.8-slim

# ENV JAVA_HOME /opt/java/openjdk
# ENV PATH $JAVA_HOME/bin:$PATH
ENV DSM_HOME /opt

# ADD ${JAVA_VERSION}-linux-x64.tar.gz ${JAVA_HOME}

RUN mkdir -p ${DSM_HOME}
ADD ibm-datasrvmgr-linux-x86_64.tgz ${DSM_HOME}
ADD start_dsm.sh ${DSM_HOME}

RUN apt update;  \
	apt upgrade -y; \
    apt install -y curl tar wget procps net-tools
    # apt-get -y clean all; \
    # dpkg remove -y apt; \
    # rm -rf /var/lib/apt/lists/*;

RUN groupadd -g 1000 ibmdsm
RUN useradd -u 1000 -g 1000 -d ${DSM_HOME} -s /sbin/bash ibmdsm
RUN chmod +x  ${DSM_HOME}/start_dsm.sh;
RUN touch /var/log/firstboot.log
RUN touch /var/log/healthiness
RUN touch /var/log/liveliness

RUN chown -R ibmdsm:ibmdsm ${DSM_HOME}

# RUN chown ibmdsm:ibmdsm /var/log/firstboot.log
# RUN chown ibmdsm:ibmdsm /var/log/healthiness
# RUN chown ibmdsm:ibmdsm /var/log/liveliness

USER ibmdsm

WORKDIR ${DSM_HOME}

EXPOSE 11080 11081 11082

ENTRYPOINT [ "/opt/start_dsm.sh" ]