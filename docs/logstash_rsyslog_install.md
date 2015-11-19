# Transport Rsyslog events to Logstash

## Overview

These are the steps to set up rsyslog to send logs to our ELK stack.

Iassune that you will have sudo access here.

### step 1

Install rsyslog

    yum install rsyslog

### step 2

Update the rsyslog config file `/etc/rsyslog.conf` with the following. Adjust the logs to be ingested if necessary.

    *.* @@10.208.200.73:5514

    module(load="imfile" PollingInterval="10")
    input(type="imfile"
      File="/cust/app/apache2/jboss.univision.com_access_log"
      Tag="jboss.univision.com_access_log")

    module(load="imfile" PollingInterval="10")
    input(type="imfile"
      File="/cust/app/apache2/r.univision.com_access_log"
      Tag="r.univision.com_access_log")

    module(load="imfile" PollingInterval="10")
    input(type="imfile"
      File="/cust/app/apache2/jboss.univision.com_error_log"
      Tag="jboss.univision.com_error_log")

    module(load="imfile" PollingInterval="10")
    input(type="imfile"
      File="/cust/app/apache2/r.univision.com_error_log"
      Tag="r.univision.com_error_log”)


### step 3

Restart rsyslog

    service rsyslog restart
