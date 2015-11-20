#!/bin/bash

PATH=/usr/local/bin:/usr/bin:$PATH
export PATH


# The base of this script and the WCM source server

function Cleanup {
  [ -f $ErrFile ] && /bin/rm -rf $ErrFile
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

declare -r LockFile="/tmp/`basename $0`.lock"
declare -r ErrFile="/tmp/`basename $0`.err"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

declare -r SCRIPT=/cust/home/jboss/bin/get_EAP6_metrics.sh

STOPPING="$(pgrep -f StopAllEAP6)"
STARTING="$(pgrep -f StartAllEAP6)"

[ -n "$STOPPING" ] || [ -n "$STARTING" ] && Cleanup && exit

for PORT in 9999 10099
do
  $SCRIPT $PORT > /tmp/get_EAP6_metrics_${PORT}.myjob 2>&1
done

Cleanup
exit 0;
