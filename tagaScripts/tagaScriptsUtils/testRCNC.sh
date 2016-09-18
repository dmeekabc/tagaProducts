#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################
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
TAGA_CONFIG_DIR=~/scripts/taga/tagaConfig
source $TAGA_CONFIG_DIR/config

PROTO="notset"

if [ $2 ]; then
  # assume it is a count
  count=$2
elif [ $1 ]; then
  # assume it is a count
  count=$1
else
  count=""
fi


# Are we NETCONF or RESTCONF?
if [ $PROTO == "RESTCONF_FORCE" ]; then
   PROTO=RESTCONF
elif [ $PROTO == "NETCONF_FORCE" ]; then
   PROTO=NETCONF
else
   # command line override of config 
   if [ $1 ]; then
   if [ $1 == "r" ]; then
      PROTO=RESTCONF
      count=$2
   elif [ $1 == "n" ]; then
      PROTO=NETCONF
      count=$2
   else
      # use the  PROTO from the config
      echo use the config from the config file >/dev/null
      # $1 must be a count
      count=$1
   fi
   fi
fi


COMMON_PARAMS="--user=netconf1 --password=netconf1 --batch-mode"
COMMON_PARAMS="--user=dtn --password=dtn1234 --batch-mode"

function getRandomFrequency {

SENSOR_COMMAND="sensor:change-freq --jtsFrequency"
RADIO_COMMAND="radio:change-freq --jtrFrequency"
JAMMER_COMMAND="jammer:change-freq --jtjFrequency"


# grab some randomness from the date command
if date | cut -c18-19 | grep 8  >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=3"
    RADIO_COMMAND="$RADIO_COMMAND=3"
    JAMMER_COMMAND="$JAMMER_COMMAND=8"

elif date | cut -c18-19 | grep 9  >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=2"
    RADIO_COMMAND="$RADIO_COMMAND=2"
    JAMMER_COMMAND="$JAMMER_COMMAND=5"
 
elif date | cut -c18-19 | grep 1  >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=5"
    RADIO_COMMAND="$RADIO_COMMAND=5"
    JAMMER_COMMAND="$JAMMER_COMMAND=2"

elif date | cut -c18-19 | grep 4 >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=4"
    RADIO_COMMAND="$RADIO_COMMAND=4"
    JAMMER_COMMAND="$JAMMER_COMMAND=2"

elif date | cut -c18-19 | grep 2 >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=8"
    RADIO_COMMAND="$RADIO_COMMAND=8"
    JAMMER_COMMAND="$JAMMER_COMMAND=3"

elif date | cut -c18-19 | grep 7 >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=7"
    RADIO_COMMAND="$RADIO_COMMAND=7"
    JAMMER_COMMAND="$JAMMER_COMMAND=3"

elif date | cut -c18-19 | grep 3 >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=1"
    RADIO_COMMAND="$RADIO_COMMAND=1"
    JAMMER_COMMAND="$JAMMER_COMMAND=6"

elif date | cut -c18-19 | grep 6 >/dev/null; then
    SENSOR_COMMAND="$SENSOR_COMMAND=6"
    RADIO_COMMAND="$RADIO_COMMAND=6"
    JAMMER_COMMAND="$JAMMER_COMMAND=7"

else
    SENSOR_COMMAND="$SENSOR_COMMAND=7"
    RADIO_COMMAND="$RADIO_COMMAND=7"
    JAMMER_COMMAND="$JAMMER_COMMAND=1"
fi

# start building the yangcli-pro script file (top line)
echo $CONNECT_COMMAND > yangcli-pro.script
# continue building the yangcli-pro script file (body)
echo $RADIO_COMMAND >> yangcli-pro.script
echo $JAMMER_COMMAND >> yangcli-pro.script
#echo $SENSOR_COMMAND >> yangcli-pro.script
# finish building the yangcli-pro script file (last line)
echo quit >> yangcli-pro.script



} # end getRandomFrequency function



# for each target, run the yangcli-pro client commands (script file)
#for target in $targetList
for target in localhost
do

   #echo "`date` START $PROTO ($target)"
   #echo "`date` START $PROTO ($target)" >> /tmp/rcnc.out
   echo "`date -Ins` START $PROTO ($target)"
   echo "`date -Ins` START $PROTO ($target)" >> /tmp/rcnc.out
   START_DATE=`date -Ins`

    TEE_FILE=/tmp/TestJTX_$target.out

   # Get the connection command (top line of the script file)
   if [ $PROTO == "RESTCONF" ]; then
      # RESTCONF
      echo RESTCONF:`date` : hostname:`hostname` \
             target:$target -------------------------- | tee $TEE_FILE
      # RESTCONF
      #CONNECT_COMMAND="connect --server=restconf-dev \
      #CONNECT_COMMAND="connect --server=10.0.0.27 \
      CONNECT_COMMAND="connect --server=$target  \
             --protocol=restconf --user=pi --password=raspberry" 
   else
      # NETCONF
      echo NETCONF:`date` : hostname:`hostname` \
            target:$target -------------------------- | tee $TEE_FILE
      # NETCONF
      #CONNECT_COMMAND="connect --server=yangapi-dev \
      #CONNECT_COMMAND="connect --server=10.0.0.27 \
      CONNECT_COMMAND="connect --server=$target  \
            --user=pi --password=raspberry" 
   fi

   #for j in 9 8 7 6 5 4 3 2 1 0 
   #for j in 5 4 3 2 1 0 
   #for j in 2 1 0 
   #for j in 1 0 
   #for j in 1 0 
   #for j in 5 4 3 2 1 0 
   #for j in 9 8 7 6 5 4 3 2 1 0 
   #for j in 9 8 7 6 5 4 3 2 1 0 
   for j in 0 
   do
   # NOTE: Consider swapping order and eliminating icount
   # NOTE: Consider swapping order and eliminating icount
   #let icount=80
   #let icount=60
   #let icount=40
   #let icount=20
   # NOTE: make sure icount matches number of i's !!
   # NOTE: make sure icount matches number of i's !!
   let icount=20
   let icount=40
   let icount=80
   let icount=10
   let icount=1
   for i in 1 #2 3 4 5 6 7 8 9 10 #11 12 13 14 15 16 17 18 19 20 \
   #21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 \
   #41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 \
   #61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 

   do
   
     # remaining loop count
     let k=$icount-$i

      # get random frequency and build the yangcli script file
      getRandomFrequency




# dlm temp hard code the script file for now
if [ $1 == "r" ]; then
#   cp yangcli-pro.script.save.r yangcli-pro.script
   yangcli-pro --run-script=yangcli-pro.script.r
elif [ $1 == "n" ]; then
#   cp yangcli-pro.script.save.n yangcli-pro.script
   yangcli-pro --run-script=yangcli-pro.script.n
else
      yangcli-pro --run-script=yangcli-pro.script
fi


#      # execute the yangcli-pro client with script file input
#      yangcli-pro --run-script=yangcli-pro.script

      RETVAL=$?
      echo $0 j:$j k:$k: $target `date` Cmd1: RetVal: $RETVAL


#      yangcli-pro --run-script=yangcli-pro.script >> $TEE_FILE 
#      RETVAL=$?
#      echo $0 j:$j k:$k: $target `date` Cmd2: RetVal: $RETVAL
   done
   done


   #echo "`date` DONE $PROTO ($target)" 
   echo "`date -Ins` DONE $PROTO ($target)" 
   echo
   #echo "`date` DONE $PROTO ($target)" >> /tmp/rcnc.out
   echo "`date -Ins` DONE $PROTO ($target)" >> /tmp/rcnc.out
   END_DATE=`date -Ins`
   echo >> /tmp/rcnc.out
   #echo >> /tmp/rcnc.out
   ./timeDeltaCalc.sh $START_DATE $END_DATE $target $PROTO $count 
   ./timeDeltaCalc.sh $START_DATE $END_DATE $target $PROTO $count >> /tmp/rcnc.out
   
   echo

done

