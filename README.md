**Install**

```
git clone https://github.com/oddeyeco/oddeye-dash.git
cd oddete-dash
mvn clean package
```

**Deploy**

```
cp target/OddeyeCoconut-{VERSION}.war $TOMCAT_HOME/webapps/OddeyeCoconut.war
```

Requires Apache Tomcat 8+ and Java 1.8+ 

Makechanges to ```dash.properties``` and ```dashlog4j.properties```
create /etc/oddeye and copy .properties files to it
