
## WCM

nv006 (telephonica)
    what are the scripts?
        uolsvn user
            /bin/
                scripts
tag it
minify resaoces
    rsync
        assets
holding/checkout dir
trigger file
    text file with tag name

## UIMAPI

linux10 (NJ3 or NJ4)
Tar -> S3 bucket

## CRM

linux10 (NJ3 or NJ4)
Build
checkout revision
swith to tag
    prod cli server
        compile
        -> JBoss

## Chris' Notes

### CRM, NV600

WCM, source code REPO is on server in telephonica in miami mv006.
SVN path + rev #, 
create tag based on that info 
checkout directory
svn switch to that tag
run scripts that will minifi static file resources
rsync all the code to the individual WCM servers (generators and back office server)
each server has a trigger file created and each one of the WCM servers has a script that runs every 2 minuts
loking for that trigger file and if that file exists, that will do the code deploy

This lets us schedule deployments on NV006.
When deploy occurs the code gets copied from the holding directory to the live apache directory.
UOL SVN is the user that these scripts run under. 
This is in that users home bin directory 

### UMIAPI

On linux 10, there is another SVN source code repo. Same opeation, 
create tag based on path and revision
in the home directory there is a checkouts folder
svn swithch to that tag
in the home /bin of that user is a script that will tar up resources, copy to s3
and then from each instances do a pull of a tar file, and deploy into the live directory,
this is integrated into the amazon autoscaling, and as part of the launch group they will pull the latest tar file from s3 
and deploy that into the live directory

### CRM

more svn stuff

On linux 10, 
svn switch on desktop in cygwin to tag
copy over to prod cli server under jboss user 
checkouts folder there
on that server there is an ant script/build.xml 
compile CRM into a war and then copy to individual JBOSS servers, 
and they have their own deploy scripts
this is interactive.
