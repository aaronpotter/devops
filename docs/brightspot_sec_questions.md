# Brightspot Security Questions and Answers
## as compiled by Jonathan Bilodeau

* **Infrastructure**
  - IDS/IPS – describe technology, how this is tuned, monitored, updated, etc.?
    + no IDS/IPS system, but would work with us if we wished to introduce a SAS partner such as SkyHigh, etc.
  - Firewalls – describe technology, policy change process, response to IDS incidents, how we would conduct audit reviews, log availability?
    + Using AWS load balance with ACL to allow only 80/443 traffic.   No stateful inspection of packets.
  - Load Balancers – describe technology
    + AWS service that maps VPC to the Internet. Backend servers use RFC1918 addressing

* **System logging / access to logs & reporting**
  - Overview
    + Logs are captured/stored locally on the servers.  Logs currently do not flow to Amazon S3 service but could.
  - Server Authentication logs – who is logging into the server (administrative work), authentication/authorization, access restrictions?
    + admin login success/fails are captured in the server logs.  There is no active monitoring/alerting of admin misuse.
  - Web access logs – public access logs (IP address, registered users, etc.), how log data is provided to univision?
    + Tomcat/general web access logs are captured.  Data is not provided to Univision but could be.
  - How often does Brightspot conduct audit reviews on admin login activity
    + One a quarterly basis to review user account access.   If necessary, logs are moved to an AWS Elastic host for review/forensics.


* **Event management - How would Brightspot respond to:**
  - a ddos attack?
    + would be detected by service unavailable or process monitoring alerts.  
    + There is no Ddos mitigation service, but Univision could introduce this if desired.
    + Response at this time would be to identify and block the offending hosts as best as possible and could include spinning up additional servers to weather an attack if required.
  - Scripting exploit (polls, password reset/login, “send to a friend” feature, sql injection, etc)?
    +  Sev 1 issue would be opened (with 15 min response time).  Process then would be to:
      * Confirm issue
      * Engage developers and product team (including Univision POCs)
      * Determine if offending code piece can be temporarily disabled
      * Tailor additional response to the incident.  
  - Site hijacking? Response/expectations/process for a major breach.
    + No retainers currently in place with IR providers (Mandiant, etc.), however no real data exists on the site.   The CRM database will remain hosted by Univision
    + Would take down the site and replace it with a last known good build in backup to restore standard service.
    + Would review deltas to determine how code was changed.  If via CMS exploit of editor credentials, that account would be revoked.
  - SLA to respond to an event?
    + 15 min response time.
  - Does an Incident Response Plan exist? Can this be shared with Univision
    + No formal plan, but steps captured within “site hijacking” section
  - Expectations from Univision during an event?
    + TBD, but involvement would appear to be minimal

* **DNS**
  - Will Brightspot require access to domain for changes?
    + Maintained entirely by Univision
  - Process for requesting domain related changes?
    + Process for requesting domain related changes should align with Univision ETS standard workflows.

* **Disaster Recovery?**
  - What is the DR plan and response time before initiating a failover?
  - What is the length of time to complete the site cutover to DR (recovery time objective)?
  - What is the recovery point objective?

  - A plan exists and can be summarized as follows:
    + Loss of a single host – can quickly spin up new hosts as need be locally
    + Loss of a region/cloud provider – would spin up Univision in another data center (most likely US West or US West 2).
      - The exercises take approximately 1-2 hours to complete after the decision to do so has been made.  However in the event of a major disaster involving many customers, this number would likely increase due to availability of Amazon services and available admin resources.
      - DB and code are mirrored to the US West datacenter.

* **Patching/Controls**
  - What is the frequency of system patching?
    + Based on the severity/need.   Servers/DB  are regularly upgraded to newer versions to take advantage of new features, thus the risk of having old software is minimized. 
    + No PHP software is utilized.
  - How soon are patches tested/rolled out from the time they are announced?
    + OS level patches can be rolled out on a few servers to test on a few hosts.  Once it has been determined that there is no adverse impact, the remaining servers are upgraded.
  - Process for rolling out emergency patches or fixes (i.e. Heartbleed, etc.)
    + Heartbleed and bash vulnerabilities were fixed within 2 hrs.
  - Univision runs vulnerability scans on a monthly cycle. Discuss scanning Brightspot site (external IPs only, static IPs?)
    + No concerns, just document the process.
  - Does Brightspot initiate their own vulnerability scans/Pen tests? Frequency? Length of time for Univision to receive report results?
    + Not offered as a service, but other companies do perform regular pen-tests. Any such test should be discussed/scheduled beforehand.  The Univision/Brightspot distribution list (managed by Viiveek) should be utilized for such communication.

* **Other items for discussion**
  - Does Brightspot have a recent SOC2 report that is available for review by Univision?
    + No SOC 1 or 2 reports.  No SAS70 reports
  - Integration with Univision AD/SSO capabilities for CMS tool?
    + Not in the current plan but can be done.  
    + Viiveek would like to add this after the initial launch and is targeting either Q3 or Q4 of 2015.
  - Discuss digital certificate process
    + uses the current Univision process that involves ETS.
