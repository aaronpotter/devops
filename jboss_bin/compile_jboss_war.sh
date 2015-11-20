#!/bin/bash

. ~/.bash_profile


function Cleanup {
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

# Begin Locking Procedure

declare -r LockFile="/tmp/`basename $0`.lock"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

# End Locking Procedure

[ "$1" == "crm.war" ] && declare App=crm.war
[ "$1" == "admin.war" ] && declare App=admin.war
[ "$App" == "" ] && echo "Invalid or no war parameter. Should be [crm.war|admin.war]" && exit

declare Name="${App%.*}"
declare Build_Folder=/cust/home/jboss/from_repository/github/$Name

declare -r Base=/cust/home/jboss
declare -r LogFolder=$Base/logs
declare -r AntLog=$LogFolder/ant.log
declare -r JBoss_Home=$JBOSS_HOME
declare -r JBoss_BIN=$JBoss_Home/bin
declare -r WAR=$Build_Folder/build/distribution/$App
declare -r Deploy_As="$App"
#declare -r Task=$*
declare -r WARFolder=$Base/war

[ ! -d $LogFolder ] && mkdir -p $LogFolder
[ ! -d $WARFolder ] && mkdir -p $WARFolder

if [ -e $WARFolder/$Deploy_As ]; then
  mv $WARFolder/$Deploy_As $WARFolder/$Deploy_As.`date '+%Y-%m-%d_%H%M%S'`
fi

cd $Build_Folder

echo "`date +%Y-%m-%d_%T` Starting Ant build " 
ant -buildfile build.xml $Task -l $AntLog
Status=$?
if [ $Status != 0 ] ; then
   echo "`date +%Y-%m-%d_%T` ant task failed with status $Status"
   more $AntLog

   Cleanup
   exit 1;
fi

if [ ! -r $WAR ]; then
   echo "`date +%Y-%m-%d_%T` $WAR not accessible"
   Cleanup
   exit 1;
fi

echo "`date +%Y-%m-%d_%T` deploying war file"
cp -v $WAR $WARFolder/

echo "`date +%Y-%m-%d_%T` done"

Cleanup
exit 0;
