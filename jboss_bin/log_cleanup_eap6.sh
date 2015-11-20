#!/bin/bash

###############################################
# Author SBali
# Compress JBoss logs and move to .attic folder
###############################################

. ~/.bash_profile

function Cleanup {
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

# Begin Locking Procedure

declare -r LockFile="/tmp/`basename $0`.lock"
declare -r ErrFile="/tmp/`basename $0`.err"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

# End Locking Procedure

declare -r JBoss_Server=/cust/jboss-eap-6.3

if [ ! -d ${JBoss_Server} ]; then
  Cleanup
  exit 1;
fi

for Node in 1 2
do
   
   JBoss_Log=$JBoss_Server/standalone$Node/log
   JBoss_Access_Log=$JBoss_Log/default-host
   JBoss_Attic=$JBoss_Server/standalone$Node/log/.attic

   if [ -d ${JBoss_Log} ]; then
      [ ! -d ${JBoss_Attic} ] && mkdir -p $JBoss_Attic
     
      for X in `find ${JBoss_Access_Log} -maxdepth 1 -type f -mtime +6 `
      do
         gzip $X
         mv   ${X}.gz $JBoss_Attic/
      done

      for X in `find ${JBoss_Log} -maxdepth 1 -type f -mtime +6 `
      do
         gzip $X
         mv   ${X}.gz $JBoss_Attic/
      done
   fi

   if [ -d ${JBoss_Attic} ]; then
      find ${JBoss_Attic} -type f -name '*.gz' -mtime +40 -exec /bin/rm -rf {} \;
   fi

done

Cleanup
exit 0;

