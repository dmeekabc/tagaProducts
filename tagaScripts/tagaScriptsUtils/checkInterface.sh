#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2016
#
# All Rights Reserved
#                                                                     
# Redistribution and use in source and binary forms, with or without  
# modification, are permitted provided that the following conditions 
# are met:                                                             
# 1. Redistributions of source code must retain the above copyright    
#    notice, this list of conditions and the following disclaimer.     
# 2. Redistributions in binary form must reproduce the above           
#    copyright notice, this list of conditions and the following       
#    disclaimer in the documentation and/or other materials provided   
#    with the distribution.                                            
#                                                                      
# THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS   
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED    
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE     
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR  
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT    
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR   
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF           
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT            
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE    
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH     
# DAMAGE.                                                              
#
#######################################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# method to determine gateway name
GW_DETERMINATINO_METHOD="runtime"
GW_DETERMINATINO_METHOD="config"

let ADD_ROUTE_FLAG=0
let ADD_ROUTE_FLAG=1

#OUT_FILE=/tmp/checkInterface.out
OUT_FILE=$CHECK_INTERFACE_LOG_FILE

echo `date` : $0 : executing on $MYIP >> $OUT_FILE

# this is our poor-mans interprocess communications mechanism
# it is not elegant but does work
if cat $NET_RESET_IN_PROG_FLAG_FILE 2>/dev/null | grep 1 ; then
   echo Notice: Network Reset is in progress,  
   echo Notice: Network Reset is in progress,  >> $OUT_FILE
   echo Notice: This $0 is not permitted to run in this state, exiting with no action! 
   echo Notice: This $0 is not permitted to run in this state, exiting with no action! >> $OUT_FILE
   exit
fi

###################
# MAIN
###################

# if param is provided, that implies to do reset without checks
if [ $# -eq 1 ]; then

   # more than one bad return, this implies our interface may be bad
   echo Interface is in suspect state - resetting!  
   echo Interface is in suspect state - resetting!  >> $OUT_FILE
   echo Interface is in suspect state - setting interface down! 
   echo Interface is in suspect state - setting interface down! >> $OUT_FILE
   sudo /sbin/ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
   echo Retcode:$? >> $OUT_FILE
   sleep 5
   echo Interface is in suspect state - setting interface up! 
   echo Interface is in suspect state - setting interface up! >> $OUT_FILE
   sudo /sbin/ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
   echo Retcode:$? >> $OUT_FILE

   if [ $ADD_ROUTE_FLAG -eq 1 ] ; then
      echo Adding Route ... 
      sudo route add -net $NETADDRPART.0 gw $NETADDRPART.1 netmask 255.255.255.0 dev $INTERFACE
      echo Adding Defalt Route ... 
      sudo route add default gw $NETADDRPART.1
   fi

else

   # only do reset if checks indicate it is necessary

   let flag=0
   let retCodeSum=0

   let CHECKVAL=$TARGET_COUNT-1
   # don't proceed with less than 2 checkval
   if [ $CHECKVAL -lt 2 ]; then
      let CHECKVAL=2
   fi

   echo PINGING TARGETS: $targetList >/dev/null >> $OUT_FILE

   for target in $targetList
   do
      #echo
      ping -c 1 $target >/dev/null
      let retCode=$?
      #echo retCode: $retCode
      if [ $retCode -eq 2 ] ; then
         echo Unreachable Network Detected, Not much we can do... >> $OUT_FILE
         # exit the routine, not much we can do
         exit
      elif [ $retCode -eq 0 ] ; then
         # set the flag that we have at least one successful ping
         let flag=1
      else
         let retCodeSum=$retCodeSum+$retCode
      #   echo retCodeSum: $retCodeSum
      fi
      echo retCode: $retCode retCodeSum: $retCodeSum >> $OUT_FILE
      if [ $retCodeSum -ge $CHECKVAL ] ; then
         # we have all the info we need... go ahead and break out
         break
      fi
   done

   # primary output line
   echo retCode: $retCode retCodeSum: $retCodeSum CHECKVAL: $CHECKVAL flag:$flag 
   echo retCode: $retCode retCodeSum: $retCodeSum CHECKVAL: $CHECKVAL flag:$flag >> $OUT_FILE

   # if we have failed to ping anybody...
   if [ $retCodeSum -ge $CHECKVAL ] ; then
      # more than one bad return, this implies our interface may be bad
      echo Interface is in suspect state - resetting!  
      echo Interface is in suspect state - resetting!  >> $OUT_FILE
      echo Interface is in suspect state - setting interface down! 
      echo Interface is in suspect state - setting interface down! >> $OUT_FILE
      sudo /sbin/ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
      echo Retcode:$? >> $OUT_FILE
      sleep 5
      echo Interface is in suspect state - setting interface up! 
      echo Interface is in suspect state - setting interface up! >> $OUT_FILE
      sudo /sbin/ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
      echo Retcode:$? >> $OUT_FILE

      if [ $ADD_ROUTE_FLAG -eq 1 ] ; then
         echo Adding Route ... 
         sudo route add -net $NETADDRPART.0 gw $NETADDRPART.1 netmask 255.255.255.0 dev $INTERFACE
         echo Adding Defalt Route ... 
         sudo route add default gw $NETADDRPART.1
      fi

   # here is another way to check , this may make the block above unnecessary, 
   # believe that this one is more demanding than the one above
   elif [ $flag -eq 0 ] ; then
      # failure to contact anybody implies our interface may be bad
      # dlm temp, this whole thing needs relooked, gateway is not valid, 
      # and the logic for only 1 or 2 nodes is probably wrong
     
      # before we declare failure, let's check against the gateway
      # get the gateway in case it has changed
      echo; date; echo Determining GATEWAY.... >> $OUT_FILE
      if [ $GW_DETERMINATIN_METHOD == "runtime" ] ; then
         # get gateway via runtime check
         MYGATEWAY=`route | grep default | cut -c16-30`
      else
         # get gateway via config
         MYGATEWAY=$NETADDRPART.1
      fi
  #    MYGATEWAY=`route | grep default | cut -c16-30`
      echo GATEWAY: $MYGATEWAY >> $OUT_FILE

      echo; echo PINGING GATEWAY: $MYGATEWAY; echo >> $OUT_FILE
      ping -c 1 $MYGATEWAY
      let retCode=$?

      if [ $retCode -eq 0 ] ; then
         echo Interface appears healthy, comms with gateway AOK >> $OUT_FILE
      else
         echo Interface is in suspect state - resetting!  
         echo Interface is in suspect state - resetting!  >> $OUT_FILE
         echo Interface is in suspect state - setting interface down! 
         echo Interface is in suspect state - setting interface down! >> $OUT_FILE
         sudo /sbin/ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
         echo Retcode:$? >> $OUT_FILE
         sleep 5
         echo Interface is in suspect state - setting interface up! 
         echo Interface is in suspect state - setting interface up! >> $OUT_FILE
         sudo /sbin/ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
         echo Retcode:$? >> $OUT_FILE
         if [ $ADD_ROUTE_FLAG -eq 1 ] ; then
            echo Adding Route ... 
            sudo route add -net $NETADDRPART.0 gw $NETADDRPART.1 netmask 255.255.255.0 dev $INTERFACE
            echo Adding Defalt Route ... 
            sudo route add default gw $NETADDRPART.1
         fi
      fi
   fi
fi

#      echo; date; echo Determining GATEWAY....
#      MYGATEWAY=`route | grep default | cut -c16-30`
#      echo GATEWAY: $MYGATEWAY
#
#      echo; echo PINGING GATEWAY: $MYGATEWAY; echo
#      ping -c 1 $MYGATEWAY
#      let retCode=$?

