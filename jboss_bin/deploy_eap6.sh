#!/bin/bash

if [ $# -eq 0 ] ; then
cat << EOM

Usage: deploy_eap6.sh [crm.war|admin.war] [y]

2nd parameter is if run in interactive mode

EOM
exit 1
fi

. ~/.bash_profile

# Begin Locking Procedure

declare -r LockFile="/tmp/`basename $0`.lock"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

# End Locking Procedure

#################
# Main Logic
#################

declare -r Base=$HOME/bin
declare -r WarFolder=$HOME/war
declare -r Sleep=5
declare -r From="noreply@prd.mc.univision.com"
declare -r MailTo="InteractiveApplicationsSupport@univision.net"
declare -r CCMailTo=""
declare -r Host=`uname -n|cut -d. -f1`

# Check if the war folder is there
[ ! -d $WarFolder ] && mkdir $WarFolder

if [ ! -d $DeployTo ]; then
   echo "$DeployTo deployment folder not found"

   [ -f $LockFile ] && /bin/rm -rf $LockFile
   exit 1; 
fi

# Check if name was passed of the deployment file
Name=$1
if [ -z $Name ]; then
   echo "War name not provided"

   [ -f $LockFile ] && /bin/rm -rf $LockFile
   exit 1;
fi


Interactive=$2
# first validate that trigger exists if not run in interactive mode
if [ "$Interactive" == "y" ] ; then
  echo "running interactively"
else
  Trigger="${Name%.*}"
  [ ! -e /cust/home/jboss/bin/${Trigger}.trigger ] && echo "Trigger does not exist" && exit
fi

# Check if deploy to folder exists
declare -r DeployTo=/cust/wcm/deploy/$Name
if [ ! -d $DeployTo ]; then
   echo "$DeployTo deployment folder not found"

   [ -f $LockFile ] && /bin/rm -rf $LockFile
   exit 1;
fi

# Check if the deployment file exists
declare -r WarFile=$WarFolder/$Name
if [ ! -e $WarFile ]; then
   echo "$WarFile does not exist!"

   [ -f $LockFile ] && /bin/rm -rf $LockFile
   exit 1;
fi

# Stop Jboss Instances
$Base/StopAllEAP6.sh

# Extract the war file
cd $DeployTo
jar -xvf $WarFile

############################################
#******************************************#
#*The ENV variable decides what file *#
#*is going to be picked up and linked     *#
#******************************************#
############################################
CONFIGDIR=${DeployTo}/WEB-INF/classes
ENV=prodaws


DIRS=`find $CONFIGDIR -name "*.$ENV" -exec dirname {} \; | uniq`

for dir in ${DIRS}; do
        echo $dir
        cd $dir
        FILES=`ls |grep $ENV$`
        for file in ${FILES}; do
                echo "Real file: $file"
                SYMLINK=`echo $file | awk -F. '{print $1"."$2}'`
                if [ -e $SYMLINK ] ; then
                        echo "Symlink currently exists.."
                        echo "Symlink: $SYMLINK"
                        echo "For sanity, removing existing symlink and recreating"
                        `rm -f $SYMLINK`
                        `ln -s $file $SYMLINK`
                else
                        echo "Creating symlink"
                        echo "Symlink: $SYMLINK"
                        `ln -s $file $SYMLINK`
                fi
        done
done

sleep $Sleep

# Start JBoss instances
$Base/StartAllEAP6.sh

[ ! -z "$MailTo" ] && echo "$Name: finished deployment" | mailx -s "`basename $0`: on $Host" -r "$From" $MailTo

[ -f $LockFile ] && /bin/rm -rf $LockFile
exit 0;

