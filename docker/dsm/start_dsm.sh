#!/bin/bash

set +x

echo "Starting DSM health API"
# /usr/bin/dsm-api &

DSMHOME=/opt/ibm-datasrvrmgr

cd ${DSMHOME}

# sed -i -e "s/^#product./product./" -e "s/^#admin.user/admin.user/" -e "s/^#admin.password=.*/admin.password=password/" setup.conf


if [[ -z $REP_HOST || -z $REP_PORT || -z $REP_DBNAME || -z $REP_USER || -z $REP_PWD ]] ; then
    tee $DSMHOME/setup.conf <<-EOF
    product.license.accepted=y
    port=${HTTP_PORT:=11080}
    https.port=${HTTPS_PORT:=11081}
    status.port=${STATUS_PORT:=11082}
    admin.user=${WEB_USER:=admin}
    admin.password=${WEB_PWD:=password}
EOF
else
    REP_PWD=$($DSMHOME/dsutil/bin/crypt.sh ${REP_PWD:=password})
    tee $DSMHOME/setup.conf <<-EOF
    product.license.accepted=y
    port=${HTTP_PORT:=11080}
    https.port=${HTTPS_PORT:=11081}
    status.port=${STATUS_PORT:=11082}
    admin.user=${WEB_USER:=admin}
    admin.password=${WEB_PWD:=password}
    repositoryDB.dataServerType=DB2LUW
    repositoryDB.host=${REP_HOST:=localhost}
    repositoryDB.port=${REP_PORT:=50000}
    repositoryDB.databaseName=${REP_DBNAME:=DSMDB}
    repositoryDB.user=${REP_USER:=dsm}
    repositoryDB.password=${REP_PWD}
EOF
fi

sed -i "s/^[ \t]*//" $DSMHOME/setup.conf

echo ####################################################
echo Install Data Server Manager in the container
echo ####################################################
cd $DSMHOME
./setup.sh -silent
echo ####################################################
echo Add cookie.secureOnly=false for http access
echo ####################################################
if ! grep -qs cookie.secureOnly $DSMHOME/Config/dswebserver.properties ; then
    echo "cookie.secureOnly=false" >> $DSMHOME/Config/dswebserver.properties
fi

${DSMHOME}/setup.sh -silent
${DSMHOME}/bin/start.sh

echo "--done--"

## Run forever so that container does not stop
tail -f /dev/null