. ~/.bash_profile

function Cleanup {
  echo " " >> $LogFile
  echo "`date +%Y-%m-%d_%T` Completed the run started at $Now " >> $LogFile
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

# Begin Locking Procedure

declare -r LockFile="/tmp/`basename $0`.lock"
declare -r ErrFile="/tmp/`basename $0`.err"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

# End Locking Procedure

declare -r Base=$HOME/bin

declare -r Today=`date +%d`
declare -r LogFolder=$HOME/logs
declare -r LogFile=$LogFolder/`basename $0`.$Today.log

[ ! -d $LogFolder ] && mkdir -p $LogFolder

declare -r Now=`date +%Y-%m-%d_%T`
echo " " >>$LogFile && echo "$Now ((((((Starting a new run))))))" >>$LogFile

if [ ! -d ${Base} ]; then
  Cleanup
  exit 1;
fi

if [ -z ${JAVA_VM} ]; then
  Cleanup
  exit 1;
fi


$JAVA_VM -classpath /cust/wcm/deploy/crm.war/WEB-INF/classes:/cust/wcm/deploy/crm.war/WEB-INF/lib/commons-lang.jar:/cust/wcm/deploy/crm.war/WEB-INF/lib/javax.mail.jar \
         com.unv.crm.jobs.ServiceRunnerBatch $Base/serviceRunnerBatch.properties service=databaseReadOnly >> $LogFile

Cleanup
exit 0;
