#!/bin/bash

PATH=/usr/local/bin:/usr/bin:$PATH
export PATH

function Cleanup {
  [ -f $ErrFile ] && /bin/rm -rf $ErrFile
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

declare -r LockFile="/tmp/`basename $0`.lock"
declare -r ErrFile="/tmp/`basename $0`.err"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

#-------------------------------
# put script logic here
#-------------------------------

 
#-------------------------------

Cleanup
exit 0;
