# CRM Setup

-  [Overview](https://wiki.us.univision.com/display/TECH/CRM+Setup#CRMSetup-Overview)
-  [Softwares required for installation in Windows](https://wiki.us.univision.com/display/TECH/CRM+Setup#CRMSetup-SoftwaresrequiredforinstallationinWindows)
-  [Installation procedure in Windows/Mac](https://wiki.us.univision.com/display/TECH/CRM+Setup#CRMSetup-InstallationprocedureinWindows/Mac)
-  [Apache Installation](https://wiki.us.univision.com/display/TECH/CRM+Setup#CRMSetup-ApacheInstallation)
-  [Items required for Dev environment Set up](https://wiki.us.univision.com/display/TECH/CRM+Setup#CRMSetup-ItemsrequiredforDevenvironmentSetup)
-  [External source I used for setting the environment](https://wiki.us.univision.com/display/TECH/CRM+Setup#CRMSetup-ExternalsourceIusedforsettingtheenvironment)


## Overview

This document provides the details for setting up a CRM local environment


## Softwares required for installation in Windows

- CRM base code source from SVN
- Spring Tool Suite (IDE for development)
- Jboss 5.0.1
- Oracle Client
- jdk 1.6


## Installation procedure in Windows/Mac

- download the CRM source Code from SVN path:-  [svn://linux10/crm/](svn://linux10/crm/branches/releases/2.5.0). Use the latest production tag
- install jdk 1.6 (if you haven't already installed)  from the web
- install Spring tool Suite(STS) from , download it from web .
- Once you install it, copy file jboss323.xml** from  [here  ](https://wiki.us.univision.com/download/attachments/2228244/jboss323.xml?version=1&modificationDate=1362668664000&api=v2)**and past it to \springsource\sts-2.5.0.M3\plugins\org.eclipse.jst.server.generic.jboss_1.6.1.v200904151730\buildfiles** (or your respective directory). I have made a modification to this file to deploy as an exploded war file.
- install jboss from  [http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.0.1.GA](http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.0.1.GA),its a zip file. you would have to unzip it to your preferred location
- for Oracle client installation, download , oracle and toad:

  - Oracle Client  [http://download.oracle.com/otn/nt/instantclient/112030/instantclient-sqlplus-nt-11.2.0.3.0.zip?AuthParam=1362776519_f96f5a27dd33cc9e8e6fa44acf22ade5](http://download.oracle.com/otn/nt/instantclient/112030/instantclient-sqlplus-nt-11.2.0.3.0.zip?AuthParam=1362776519_f96f5a27dd33cc9e8e6fa44acf22ade5)
  - Install toad form this link   [http://community-downloads.quest.com/toadsoft/ORACLE/TOADORACLE_FREEWARE_116_X86.MSI](http://community-downloads.quest.com/toadsoft/ORACLE/TOADORACLE_FREEWARE_116_X86.MSI)
- copy oracle-ds.xml from  [**here **](https://wiki.us.univision.com/download/attachments/2228244/oracle-ds.xml?version=1&modificationDate=1362668664000&api=v2)to the deploy folder in jboss e.g.  
      \jboss-5.0.1.GA\server\default\deploy
- open Spring tool Suite(STS), select the workspace where you downloaded the crm from svn, in the create project select Spring template project , name the project crm.
- refresh the project , you should have all the files in your workspace,add all the files from your WEB-INF/lib to your build path.(All the required jar files are in svn) .
- Remove the Maven libraries from the build path.
- Go to server console, create a server, select vJboss 5.0 and point to the jboss home directory, select the default server.
- Add the server runtime library to the build path.
- add crm (the project) to the server in the option Add or remove projects.
- the war would get deployed and you should be able to access it
- We are using spring 3.0 and hibernate 2.5 for this project.All the necessary jar files are inside WEB-INF/lib folder.
- Any property file  which is used per environment , we done have the .properties file in svn. So you would need to copy the QA version  and rename the file :-- globalproperties.properties
- crmglobal.properties


## Apache Installation

1. update apache config. the config can be located @ C:\xampp\apache\conf
```
# Virtual hosts
Include "conf/extra/httpd-vhosts.conf"
NameVirtualHost 127.0.0.1
<VirtualHost *:80>
  ServerAdmin nobody@localhost
  DocumentRoot "C:/Server/jboss-5.0.1.GA/server/default/deploy/crm.war"
  ServerName miembros-local.uim.univision.com
  ErrorLog  "logs/error_log"
  CustomLog "logs/access_log" common

  ProxyPass /resources  http://miembros-local.uim.univision.com:8080/crm/resources/
  ProxyPassReverse /resources  http://miembros-local.uim.univision.com:8080/crm/resources/

  ProxyPass /crm  http://miembros-local.uim.univision.com:8080/crm/
  ProxyPassReverse /crm  http://miembros-local.uim.univision.com:8080/crm/
</VirtualHost>
```
2. restart the apache after the update is complete

## Items required for Dev environment Set up

- Oracle client
- oracle-ds.xml (db access to Qora003/Dora003)
- EH Cache Standalone machine (if we want it like that). Currently as per my configuration, its one per jboss node
- All the required jar files are in the WEB-INF/lib folder in SVN.


## External source I used for setting the environment

-  [http://singgihpraditya.wordpress.com/2010/02/13/spring-3-0-and-hibernate-tutorial-part-1/](http://singgihpraditya.wordpress.com/2010/02/13/spring-3-0-and-hibernate-tutorial-part-1/)
-  [http://www.liferay.com/community/wiki/-/wiki/Main/Spring-Hibernate-DWR;jsessionid=DB0AC4784453FC1794574B786A2560DF.node-1](http://www.liferay.com/community/wiki/-/wiki/Main/Spring-Hibernate-DWR;jsessionid=DB0AC4784453FC1794574B786A2560DF.node-1)
-  [http://www.nabeelalimemon.com/blog/2010/05/spring-3-integrated-with-hibernate-part-a/](http://www.nabeelalimemon.com/blog/2010/05/spring-3-integrated-with-hibernate-part-a/)
-  [http://www.nabeelalimemon.com/blog/2010/05/spring-3-integrated-with-hibernate-part-b/](http://www.nabeelalimemon.com/blog/2010/05/spring-3-integrated-with-hibernate-part-b/)
-  [http://www.developer.com/java/ent/article.php/3897536/Combining-Hibernate-Cache-and-Ehcache-for-Better-Java-Scalability.htm](http://www.developer.com/java/ent/article.php/3897536/Combining-Hibernate-Cache-and-Ehcache-for-Better-Java-Scalability.htm)
-  [http://ehcache.org/documentation/hibernate.html](http://ehcache.org/documentation/hibernate.html)
-  [http://javathink.blogspot.com/2010/01/tutorial-integrating-terracotta-ehcache.html](http://javathink.blogspot.com/2010/01/tutorial-integrating-terracotta-ehcache.html)
-  [http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/html/transaction.html#transaction-intro](http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/html/transaction.html#transaction-intro)
-  [http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/htmlsingle/spring-framework-reference.html#spring-introduction](http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/htmlsingle/spring-framework-reference.html#spring-introduction)
-  [http://www.developer.com/java/other/article.php/3756831](http://www.developer.com/java/other/article.php/3756831)
