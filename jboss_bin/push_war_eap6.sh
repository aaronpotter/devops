#!/bin/bash

. ~/.bash_profile

# Begin Locking Procedure

declare -r LockFile="/tmp/`basename $0`.lock"

[ -f $LockFile ] && [ -d /proc/`cat $LockFile` ] && echo "Another instance is running" && exit 16
echo $$ >$LockFile

function Cleanup {
  [ -f $ErrFile ] && /bin/rm -rf $ErrFile
  [ -f $LockFile ] && /bin/rm -rf $LockFile
}

# End Locking Procedure

#################
# Main Logic
#################

declare -r Base=$HOME/bin
declare -r WarFolder=$HOME/war

[ "$1" == "crm.war" ] && declare App="crm"
[ "$1" == "admin.war" ] && declare App="admin"

for X in $(cat crmlist)
do
   echo $X
   echo "Push to $X"
   rsync -avz --delete -e ssh $WarFolder/${App}* $X:$WarFolder/
   ssh $X touch $HOME/bin/${App}.trigger
done


# push to S3
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="AKIAIIFAPELNYLEBESJQ"
export AWS_SECRET_ACCESS_KEY="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"

aws s3 cp /cust/home/jboss/war/$1 s3://uim-prod/aws/appl/crm/war/$1

Cleanup
exit 0;

