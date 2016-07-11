**Install**

```
git clone https://connect.netangels.net/pastor/oddeye-dash.git
cd oddete-dash
mvn install
```
**Deploy**

```
/opt/jetty/bin/jetty.sh stop 
rm /opt/jetty/webapps/OddeyeCoconut-{VERSION}.war
cp target/OddeyeCoconut-0.1.war /opt/jetty/webapps/
/opt/jetty/bin/jetty.sh start
```

