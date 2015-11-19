# xBox

## Servers

Windows servers

    uimnj3xboxweb01.uolsite.univision.com QA
    uimnj3xboxweb02.uolsite.univision.com Prod1
    uimnj3xboxweb03.uolsite.univision.com Prod2

## AWS

Currently we have 2 Xbox servers in AWS Prod VPC with the following Instance ID:

    i-5cd8cebd
    i-15292aff

These servers have not been tested by Viiveek's group yet...

Unlike the current Xbox servers in the Data Center where we have separate servers for "XBox 360(M3)" and "XBox One", however the AWS Xbox Servers are hosting both a XBox 360 and One.

### The 2 IIS application are:

SimpleAuthService - XBox One
SimpleXHTTPService - XBox 360

I have updated current XBox 360 and One code and certs on here. Each ssl cert has to be loaded into the MMC certs snap-in. To add to the MMC snap-in, follow these instructions:

    Click on Start button
    On the Search type "mmc" and press enter
    Microsoft Management Console will pop up, on the top menu click on "File" on the drop down menu click on "Add/Remove Snap-in..."
    From there select "Certificates" and click on Add and then select "Computer account" then click Finish and then click on "OK"
    Then add the ssl certs in the appropriate folder
    For 360 add to the following: Personal,Trusted Root Certification Authorities, Trusted Publishers, Trusted People.

https://xboxone.univision.com/SimpleAuthService/RESTService.svc/messageoftheday

https://xauth.uimvdc.univision.com/SimpleXHTTPService/RESTService.svc/messageoftheday

Xbox One Production Servers in the Data Center:

    10.200.1.113/UIMNJ3XBOXWEB02
    10.200.1.114/UIMNJ3XBOXWEB03
    10.200.1.102/UIMNJ3XBOXWEB01 -- QA Machine

XBox 360(M3) installation steps: https://wiki.us.univision.com/download/attachments/1278077/Steps%20for%20%20Installingxboxrestapi.docx?version=1&modificationDate=1360970835000&api=v2
