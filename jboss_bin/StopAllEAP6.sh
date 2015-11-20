#!/bin/bash

##################################
# main script is standaloneEAP6.sh
##################################

declare -r EAP_HOME=/cust/jboss-eap-6.3
declare -r Sleep=2

for X in 1 2
do
 
   if [ -d $EAP_HOME/standalone${X} ]; then

       /cust/home/jboss/bin/standaloneEAP6.sh node${X} stop
       if [ ${X} -lt 4 ]; then
          sleep $Sleep
       fi
    fi
done
