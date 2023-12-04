#!/bin/bash

export workdir=$(pwd)
export downloadSource=$(pwd)/source
export tomcatHome="${workdir}/tmp"
export releases=${workdir}/releases
export tomcatVersion=0
export tomcatMainVersion=0
export toDate=$(date "+%Y%m%d")

func() {
    echo "Usage:"
    echo "safety-tomcat.sh [-v tomcatVersion]"
    echo "Description:"
    echo "tomcatVersion: tomcat 版本,例如: 9.0.59"
    exit -1
}

while getopts 'v:h' OPT; do
    case $OPT in
        v) tomcatVersion="$OPTARG";;
        h) func;;
        ?) func;;
    esac
done

if [ "${tomcatVersion:0:2}" = "10" ]; then
    tomcatMainVersion=${tomcatVersion:0:2}
else
    tomcatMainVersion=${tomcatVersion:0:1}
fi

mkdir -p ${downloadSource}
mkdir -p ${tomcatHome}
mkdir -p ${releases}

 
if [ -f "${downloadSource}/apache-tomcat-${tomcatVersion}.tar.gz" ]; then
    # 檔案存在
    echo "File apache-tomcat-${tomcatVersion}.tar.gz exists."
else
    # 檔案不存在
    echo "File apache-tomcat-${tomcatVersion}.tar.gz does not exists."
    wget -O ${downloadSource}/apache-tomcat-${tomcatVersion}.tar.gz https://archive.apache.org/dist/tomcat/tomcat-${tomcatMainVersion}/v${tomcatVersion}/bin/apache-tomcat-${tomcatVersion}.tar.gz
    wget -O ${downloadSource}/apache-tomcat-${tomcatVersion}.tar.gz.sha512 https://archive.apache.org/dist/tomcat/tomcat-${tomcatMainVersion}/v${tomcatVersion}/bin/apache-tomcat-${tomcatVersion}.tar.gz.sha512
fi

cd ${downloadSource}

if sha512sum -c "apache-tomcat-${tomcatVersion}.tar.gz.sha512"; then
    echo "The sha512 sum matched"
else
    echo "The sha512 sum didn't match"
    exit -1
fi


if [ -d "${tomcatHome}/apache-tomcat-${tomcatVersion}" ]; then
    echo "remove apache-tomcat-${tomcatVersion}"
    rm -rf ${tomcatHome}/apache-tomcat-${tomcatVersion}
fi

if [ -f "${releases}/safety-tomcat-${tomcatVersion}-${toDate}.tar.gz" ]; then
    echo "remove safety-tomcat-${tomcatVersion}-${toDate}.tar.gz"
    rm -rf ${releases}/safety-tomcat-${tomcatVersion}-${toDate}.tar.gz
fi


if [ -d "${tomcatHome}/catalina_jar-${tomcatVersion}" ]; then
    echo "remove ${tomcatHome}/catalina_jar-${tomcatVersion}"
    rm -rf ${tomcatHome}/catalina_jar-${tomcatVersion}
fi


mkdir -p ${tomcatHome}/catalina_jar-${tomcatVersion}

tar -zxf ${downloadSource}/apache-tomcat-${tomcatVersion}.tar.gz -C ${tomcatHome}


echo "tomcat 移除版號"

unzip -q ${tomcatHome}/apache-tomcat-${tomcatVersion}/lib/catalina.jar -d ${tomcatHome}/catalina_jar-${tomcatVersion}/
sed -i '/^server.number=.*/c server.number=0' ${tomcatHome}/catalina_jar-${tomcatVersion}/org/apache/catalina/util/ServerInfo.properties
sed -i '/^server.info=.*/c server.info=Apache Tomcat' ${tomcatHome}/catalina_jar-${tomcatVersion}/org/apache/catalina/util/ServerInfo.properties
jar uvf ${tomcatHome}/apache-tomcat-${tomcatVersion}/lib/catalina.jar -C ${tomcatHome}/catalina_jar-${tomcatVersion} org/apache/catalina/util/ServerInfo.properties


echo "刪除預設 webapps"

rm -rf ${tomcatHome}/apache-tomcat-${tomcatVersion}/webapps/*

echo "設定目錄權限"

find ${tomcatHome}/apache-tomcat-${tomcatVersion} -type d -exec chmod -R 0755 "{}" +;
find ${tomcatHome}/apache-tomcat-${tomcatVersion} -type f -exec chmod -R 0644 "{}" +;
find ${tomcatHome}/apache-tomcat-${tomcatVersion}/bin/*.sh -type f -exec chmod -R 0755 "{}" +;

echo "重新打包"
tar -zcf ${releases}/safety-tomcat-${tomcatVersion}-${toDate}.tar.gz -C ${tomcatHome} apache-tomcat-${tomcatVersion}

echo "down!"
