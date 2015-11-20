#!/bin/bash

. ~/.bash_profile

function LogMsg {
   T="`date '+%Y-%m-%d_%H:%M:%S'` "
   echo "" >> $LogFile
   if [ "$CmdLine" = "true" ]; then
      echo " "
      echo $T $1
   fi
   echo $T $1 >> $LogFile
}

function SendAlert {
   [ ! -z "$MailTo" ] && [ -s $ErrFile ] && mailx -s "`basename $0`: Message on $Host" -r "$From" $MailTo <$ErrFile
}

function Cleanup {
  [ -f $ErrFile ] && /bin/rm -rf $ErrFile
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

# Begin Locking Procedure

declare -r LockFile="/tmp/`basename $0`.lock"
declare -r ErrFile="/tmp/`basename $0`.err"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

# End Locking Procedure

######################################
# Main Script Logic
######################################

if  [ "${LOGNAME}" != "jboss" ]
then
  echo "Invalid User: Must be run as jboss"
  Cleanup
  exit 1 
fi

declare CmdLine=false
declare Execute=false
declare -r Today=`date +%w`
declare -r LogFolder=$HOME/logs
declare -r LogFile=$LogFolder/`basename $0`.$Today.log
declare -r InvokedAs=$*

declare -r MailTo="InteractiveApplicationsSupport@univision.net"
declare -r From="noreply@$(hostname -s).prd.mc.univision.com"
declare -r Host=`uname -n|cut -d. -f1`

declare ConfigFile=$HOME/bin/config.$Host.txt
declare JBOSS_HOME=/cust/jboss-eap-6.3
declare JBoss_BIN=$JBOSS_HOME/bin

[ ! -d $LogFolder ] && mkdir -p $LogFolder

if [ ! -d $JBoss_BIN ]; then
   LogMsg "JBoss bin folder not found "
   Cleanup
   exit 1;
fi

if [ ! -e $ConfigFile ]; then
   LogMsg "Config file $ConfigFile not found "
   Cleanup
   exit 1;
fi

if [ "`tty`" != "not a tty" ]; then
   CmdLine="true"
fi


# Append messages to log file
LogMsg "Starting a new run as $0 $InvokedAs "

Node=$1
NodeAction=$2

if [ -z $Node ]; then
   LogMsg "Node not passed"
   Cleanup
   exit 1;
fi
if [ -z $NodeAction ]; then
   LogMsg "NodeAction not passed"
   Cleanup
   exit 1;
fi

declare NodeData=`grep "$Node=" $ConfigFile | sed 's/^.*=//'`;

if [ "$NodeData" == "" ]; then
   LogMsg "Node $Node not found in $ConfigFile"
   echo   "Node $Node not found in $ConfigFile" >> $ErrFile
   SendAlert 
   Cleanup
   exit 1;
fi

Configuration=`echo $NodeData | awk '{ print $1 }'` 
ServerName=`echo $NodeData | awk '{ print $2 }'` 
PortOffset=`echo $NodeData | awk '{ print $3 }'` 
IP=`echo $NodeData | awk '{ print $4 }'`
MultiCastIP=`echo $NodeData | awk '{ print $5 }'`

LogMsg "IP=$IP ServerName=$ServerName PortOffset=$PortOffset Multicast=$MultiCastIP Configuration=$Configuration" 

if [ "$NodeAction" == "start" ]; then
   
   [ ! -d $JBOSS_HOME/$Configuration/log ] && mkdir -p $JBOSS_HOME/$Configuration/log

   ##################################################################
   # From ps list rmeove fgrep and the node names because it shows up 
   # when this script is run 
   ##################################################################
   #Result=`ps -ef | fgrep run.sh | fgrep -v fgrep | fgrep $Node`
   Result=`ps -ef | fgrep Djboss | fgrep -v fgrep | fgrep $Node`
   if [ "$Result" != "" ]; then
         LogMsg "Node $Node is alive" 
         echo   "Node $Node is alive" >> $ErrFile
         echo $Result >> $ErrFile
         SendAlert
         Cleanup
         exit 1;
   fi

   if [ -e $JBOSS_HOME/$Configuration/log/jvm.log ]; then
      mv $JBOSS_HOME/$Configuration/log/jvm.log  $JBOSS_HOME/$Configuration/log/jvm.log.`date '+%Y-%m-%d_%H%M%S'`
   fi
 
   cd $JBOSS_HOME/bin
   nice ./standalone.sh -c standalone-full-ha.xml \
         -Dorg.jboss.as.logging.per-deployment=false \
         -Djboss.server.name=$ServerName \
         -Djboss.socket.binding.port-offset=$PortOffset \
         -Djboss.server.base.dir=../$Configuration \
         -Djboss.server.config.dir=../$Configuration/configuration \
         -Djboss.messaging.group.address=$MultiCastIP \
         -Dorg.glassfish.web.rfc2109_cookie_names_enforced=false \
         -b $IP \
         -bmanagement=$IP \
	 -u $MultiCastIP > $JBOSS_HOME/$Configuration/log/jvm.log &
 
elif [ "$NodeAction" == "stop" ]; then

   ##################################################################
   # From ps list rmeove fgrep and the node names because it shows up 
   # when this script is run 
   ##################################################################
   Result=`ps -ef | fgrep Djboss | fgrep -v fgrep | fgrep $Node`
   if [ "$Result" != "" ]; then
      Result=`ps -ef | fgrep Djboss | fgrep -v fgrep | fgrep $Node | awk ' { print $2} ' `
      if [ "$Result" != "" ]; then
         kill -9 $Result
         SendAlert
         Cleanup
         exit 1;
      fi
   fi
else
   LogMsg "Action $NodeAction undefined"
   echo   "Action $NodeAction undefined" >> $ErrFile
   SendAlert
   Cleanup
   exit 1;
fi

[ ! -e $ErrFile ] && echo "$ServerName: no errors attempting $NodeAction" > $ErrFile && SendAlert
Cleanup
exit 0;

