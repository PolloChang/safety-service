# safety-service

安全的服務建立腳本

* 確認可執行OS: Debian12
* releases 目錄為打包過後的成品

## tomcat

```bash
./safety-tomcat.sh -v 9.0.83
```

## docker


```bash
docker inspect --format '{{json .State.Health}}' docker-safety-tomcat-7-jre7-1
```

## saiku


```bash
type=OLAP
name=<name>
driver=mondrian.olap4j.MondrianOlap4jDriver
location=jdbc:mondrian:Jdbc=jdbc:jtds:sqlserver://<DB_IP>:1433/<DB_NAME>;Catalog=mondrian:///datasources/<schema>.xml;JdbcDrivers=net.sourceforge.jtds.jdbc.Driver
username=<username>
password=<password>
security.enabled=false
```