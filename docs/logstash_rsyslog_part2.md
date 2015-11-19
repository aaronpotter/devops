## Configuring Logstash for Syslog

Configuring Logstash to receive Syslog messages is really easy. All we need to
do is add the syslog input plugin to our central server's
/etc/logstash/conf.d/central.conf configuration file. Let's do that now:

Listing 1.2: Adding the `syslog` _input_

    input {
      redis {
        host => "10.0.0.1"
        data_type => "list"
        type => "redis-input"
        key => "logstash"
      }
      syslog {
        type => syslog
        port => 5514
      }
    }
    output {
      stdout { }
      elasticsearch {
        cluster => "logstash"
      }
    }

You can see that in addition to our redis input we've now got syslog enabled and
we've specified two options:

Listing 1.3: The `syslog` _input_

    syslog {
      type => syslog
      port => 5514
    }

The first option, `type`, tells Logstash to label incoming events as syslog to help
us to manage, filter and output these events. The second option, `port`, opens
port 5514 for both TCP and UDP and listens for Syslog messages. By default most
Syslog servers can use either TCP or UDP to send Syslog messages and when being
used to centralize Syslog messages they generally listen on port 514. Indeed, if
not specified, the port option defaults to 514. We've chosen a different port here
to separate out Logstash traffic from any existing Syslog traffic flows you might
have. Additionally, since we didn't specify an interface (which we could do using
the host option) the syslog plugin will bind to `0.0.0.0` or all interfaces.

---

*TIP* You can find the full list of options for the `syslog` input plugin [here](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-syslog.html).

---

Now, if we restart our Logstash agent, we should have a Syslog listener running on
our central server.

Listing 1.4: Restarting the Logstash server

    $ sudo service logstash restart

You should see in your /var/log/logstash/logstash.log log file some lines indicating
the syslog input plugin has started:

Listing 1.5: Syslog input startup output

    {:message=>"Starting syslog udp listener", :address=>"0.0.0.0:5514",↩
    :level=>:info}
    {:message=>"Starting syslog tcp listener", :address=>"0.0.0.0:5514",↩
    :level=>:info}

---

*NOTE* To ensure connectivity you will need make sure any host or intervening
network firewalls allow connections on TCP and UDP between hosts sending Syslog
messages and the central server on port 5514.

---

## Configuring Syslog on remote agents

There are a wide variety of hosts and devices we need to configure to send Syslog
messages to our Logstash central server. Some will be configurable by simply
specifying the target host and port, for example many appliances or managed
devices. In their case we'd specify the hostname or IP address of our central server
and the requisite port number.
Central server

- Hostname: smoker.example.com
- IP Address: 10.0.0.1
- Syslog port: 5514

In other cases our host might require its Syslog daemon or service to be specifically
configured. We're going to look at how to configure three of the typically used
Syslog daemons to send messages to Logstash:

- RSyslog
- Syslog-NG
- Syslogd

We're not going to go into great detail about how each of these Syslog servers
works but rather focus on how to send Syslog messages to Logstash. Nor are we
going to secure the connections. The syslog input and the Syslog servers will be
receiving and sending messages unencrypted and unauthenticated.

Assuming we've configured all of these Syslog servers our final environment might
look something like:

---

*WARNING* As I mentioned above Syslog has some variations between platforms.
The Logstash syslog input plugin supports RFC3164 style syslog with the
exception that the date format can either be in the RFC3164 style or in ISO8601.
If your Syslog output isn't compliant with RFC3164 then this plugin will probably
not work. We'll look at custom filtering in Chapter 5 that may help parse your
specific Syslog variant.

*IAN NOTE* see [part1](https://github.com/univision/devop-scripts/blob/master/docs/logstash_rsyslog_part1.md) for a timestamp solution

---

### Configuring RSyslog

The RSyslog daemon has become popular on many distributions, indeed it has
become the default Syslog daemon on recent versions of Ubuntu, CentOS, Fedora,
Debian, openSuSE and others. It can process log files, handle local Syslog and
comes with an extensible modular plug-in system.

---

*TIP* In addition to supporting Syslog output Logstash also supports the RSyslog
specific RELP protocol.

---

We're going to add Syslog message forwarding to our RSyslog configuration file,
usually /etc/rsyslog.conf (or on some platforms inside the /etc/rsyslog.d/
directory). To do so we're going to add the following line to the end of our
/etc/rsyslog.conf file:

Listing 1.6: Configuring RSyslog for Logstash

    *.* @@smoker.example.com:5514

---

NOTE If you specify the hostname, here smoker.example.com, your host will
need to be able to resolve it via DNS.

---

This tells RSyslog to send all messages using *.*, which indicates all facilities
and priorities. You can specify one or more facilities or priorities if you wish, for
example:

Listing 1.7: Specifying RSyslog facilities or priorities

    mail.* @@smoker.example.com:5514
    *.emerg @@joker.example.com:5514

The first line would send all mail facility messages to our smoker host and the
second would send all messages of emerg priority to the host joker.
The @@ tells RSyslog to use TCP to send the messages. Specifying a single @ uses
UDP as a transport.

---

TIP I would strongly recommend using the more reliable and resilient TCP protocol
to send your Syslog messages.

---

If we then restart the RSyslog daemon, like so:

Listing 1.8: Restarting RSyslog

    $ sudo /etc/init.d/rsyslog restart

Our host will now be sending all the messages collected by RSyslog to our central
Logstash server.

The RSyslog imfile module One of RSyslog's modules provides another method
of sending log entries from RSyslog. You can use the imfile module to transmit
the contents of files on the host via Syslog. The imfile module works much like
Logstash's file input and supports file rotation and tracks the currently processed
entry in the file.

To send a specific file via RSyslog we need to enable the imfile module and then
specify the file to be processed. Let's update our /etc/rsyslog.conf file (or if your
platform supports the /etc/rsyslog.d directory then you can create a file-specific
configuration file in that directory).

Listing 1.9: Monitoring files with the imfile module

    module(load="imfile" PollingInterval="10")
    input(type="imfile"
      File="/var/log/riemann/riemann.log"
      Tag="riemann")

The first line loads the imfile module and sets the polling internal for events to
10 seconds. It only needs to be specified once in your configuration.
The next block specifies the file from which to collect events. It has a type of
imfile, telling RSyslog to use the imfile module. The File attribute specifies the
name of the file to poll. The File attribute also supports wildcards.

Listing 1.10: Monitoring files with an imfile wildcard

    input(type="imfile"
    File="/var/log/riemann/*.log"
      Tag="riemann")

This would collect all events from all files in the /var/log/riemann directory with
a suffix of .log.

Lastly, the Tag attribute tags these messages in RSyslog with a tag of riemann.
Now, once you've restarted RSyslog, it will be monitoring this file and sending any
new lines via Syslog to our Logstash instance (assuming we've configured RSyslog
as suggested in the previous section).
