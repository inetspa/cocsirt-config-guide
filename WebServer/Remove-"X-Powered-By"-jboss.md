## วิธีการลบ X-Powered-By Header JBoss

#### JBoss 4.2
เปิดไฟล์ `web.xml` ที่ `${jboss.home}/server/${server.instance.name}/deploy/jboss-web.deployer/conf/.` เช่น `/usr/local/jboss-4.2.3.GA/server/default/deploy/jboss-web.deployer/conf/.`

```
1 <!-- ================== Common filter Configuration ==================== -->

2  <filter>

3     <filter-name>CommonHeadersFilter</filter-name>

4     <filter-class>org.jboss.web.tomcat.filters.ReplyHeaderFilter</filter-class>

5  <!--   <init-param> -->

6  <!--      <param-name>X-Powered-By</param-name>  -->

7  <!--      <param-value>Servlet 2.4; JBoss-4.2.3.GA (build: SVNTag=JBoss_4_2_3_GA date=200807     181439)/JBossWeb-2.0</param-value>  -->

8  <!--   </init-param>  -->

9  </filter>
```

#### JBoss 5.0 & JBoss 5.1
The `web.xml` file that needs to be updated is located in a different location than with JBoss 4,2 but the technique is the same. To suppress the X-Powered-By header under JBoss 5.0, comment out the init-param, param-name, and param-value line entries from the web.xml located in `${jboss.home}server/${server.instance.name}/deployers/jbossweb.deployer/.`

```
01 <!-- ================== Common filter Configuration ==================== -->

02  <filter>

03     <filter-name>CommonHeadersFilter</filter-name>

04     <filter-class>

05        org.jboss.web.tomcat.filters.ReplyHeaderFilter</filter-class>

06  <!--   <init-param>  -->

07  <!--      <param-name>X-Powered-By</param-name>  -->

08  <!--      <param-value>Servlet 2.5; JBoss-5.0/JBossWeb-2.1</param-value>  -->

09  <!--   </init-param>  -->
```

#### JBoss 6.
In order to suppress the X-Powered-By header in JBoss 6, 7, or 7.1, you no longer make changes to `web.xml` files but instead modify the catalina.properties file included with your server instance. Edit the catalina.properties file located in `${jboss.home}/server/${server.instance.name}/deploy/jbossweb.sar/.`  Locate the property named: org.apache.catalina.connector.X_POWERED_BY and set its value to false. Restart the server and you're all set.