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
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

PROTO="RESTCONF"

#COMMON_PARAMS="--log-level=debug4 --log=/tmp/endOfTest.log --log-mirror --user=dtn --password=dtn1234 --batch-mode"
COMMON_PARAMS="--user=netconf1 --password=netconf1 --batch-mode"
COMMON_PARAMS="--user=dtn --password=dtn1234 --batch-mode"

SENSOR_COMMAND="sensor:change-freq --jtsFrequency"
RADIO_COMMAND="radio:change-freq --jtrFrequency"
JAMMER_COMMAND="jammer:change-freq --jtjFrequency"

# grab some randomness from the date command
if date | cut -c18-19 | grep 8  ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=3"
    RADIO_COMMAND="$RADIO_COMMAND=3"
    JAMMER_COMMAND="$JAMMER_COMMAND=8"

elif date | cut -c18-19 | grep 9  ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=2"
    RADIO_COMMAND="$RADIO_COMMAND=2"
    JAMMER_COMMAND="$JAMMER_COMMAND=5"
 
elif date | cut -c18-19 | grep 1  ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=5"
    RADIO_COMMAND="$RADIO_COMMAND=5"
    JAMMER_COMMAND="$JAMMER_COMMAND=2"

elif date | cut -c18-19 | grep 4 ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=4"
    RADIO_COMMAND="$RADIO_COMMAND=4"
    JAMMER_COMMAND="$JAMMER_COMMAND=2"

elif date | cut -c18-19 | grep 2 ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=8"
    RADIO_COMMAND="$RADIO_COMMAND=8"
    JAMMER_COMMAND="$JAMMER_COMMAND=3"

elif date | cut -c18-19 | grep 7 ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=7"
    RADIO_COMMAND="$RADIO_COMMAND=7"
    JAMMER_COMMAND="$JAMMER_COMMAND=3"

elif date | cut -c18-19 | grep 3 ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=1"
    RADIO_COMMAND="$RADIO_COMMAND=1"
    JAMMER_COMMAND="$JAMMER_COMMAND=6"

elif date | cut -c18-19 | grep 6 ; then
    SENSOR_COMMAND="$SENSOR_COMMAND=6"
    RADIO_COMMAND="$RADIO_COMMAND=6"
    JAMMER_COMMAND="$JAMMER_COMMAND=7"

else
    SENSOR_COMMAND="$SENSOR_COMMAND=7"
    RADIO_COMMAND="$RADIO_COMMAND=7"
    JAMMER_COMMAND="$JAMMER_COMMAND=1"
fi

# for each target, run the yangcli-pro client commands (script file)
for target in $targetList
do

    TEE_FILE=/tmp/TestJTX_$target.out

   # Get the connection command (top line of the script file)
   if [ $PROTO == "RESTCONF" ]; then
      # RESTCONF
      echo RESTCONF:`date` : hostname:`hostname` target:$target -------------------------- | tee $TEE_FILE
      # RESTCONF
      CONNECT_COMMAND="connect --server=restconf-dev --protocol=restconf --user=dtn --password=dtn1234" 
   else
      # NETCONF
      echo NETCONF:`date` : hostname:`hostname` target:$target -------------------------- | tee $TEE_FILE
      # NETCONF
      CONNECT_COMMAND="connect --server=yangapi-dev --user=dtn --password=dtn1234" 
   fi

   # start building the yangcli-pro script file (top line)
   echo $CONNECT_COMMAND > yangcli-pro.script

   # continue building the yangcli-pro script file (body)
   echo $RADIO_COMMAND >> yangcli-pro.script
   echo $JAMMER_COMMAND >> yangcli-pro.script
   #echo $SENSOR_COMMAND >> yangcli-pro.script

   # finish building the yangcli-pro script file (last line)
   echo quit >> yangcli-pro.script

   # execute the yangcli-pro client with script file input
   yangcli-pro --run-script=yangcli-pro.script
   RETVAL=$?
   echo $0 $target `date` Cmd1: RetVal: $RETVAL
   yangcli-pro --run-script=yangcli-pro.script >> $TEE_FILE 
   RETVAL=$?
   echo $0 $target `date` Cmd2: RetVal: $RETVAL

   echo "`date` Done ($target)"

done


exit




if [ $PROTO == "RESTCONF" ]; then
# RESTCONF
CONNECT_COMMAND="connect --server=restconf-dev --protocol=restconf --user=dtn --password=dtn1234" 
echo $CONNECT_COMMAND > yangcli-pro.script

for target in $targetList
do
  echo `date` CmdJTXChangFreq:


  echo RESTCONF:`date` : hostname:`hostname` target:$target -------------------------- | tee $TEE_FILE
  restconf --server=$target $COMMON_PARAMS --run-command="list commands" 
  restconf --server=$target $COMMON_PARAMS --run-command="list commands" >> $TEE_FILE 
  restconf --server=$target $COMMON_PARAMS --run-command="$RADIO_COMMAND" 
  restconf --server=$target $COMMON_PARAMS --run-command="$RADIO_COMMAND" >> $TEE_FILE
  restconf --server=$target $COMMON_PARAMS --run-command="$JAMMER_COMMAND" 
  restconf --server=$target $COMMON_PARAMS --run-command="$JAMMER_COMMAND" >> $TEE_FILE
  #restconf --server=$target $COMMON_PARAMS --run-command="$SENSOR_COMMAND" 
  #restconf --server=$target $COMMON_PARAMS --run-command="$SENSOR_COMMAND" >> $TEE_FILE

  echo "`date` Done ($target)"

done
else

# NETCONF
CONNECT_COMMAND="connect --server=yangapi-dev --user=dtn --password=dtn1234" 
echo $CONNECT_COMMAND > yangcli-pro.script


for target in $targetList
do

  echo `date` CmdJTXChangFreq:

  echo $0 $target `date` Cmd1: RetVal: TBD
  TEE_FILE=/tmp/TestJTX_$target.out
  echo NETCONF:`date` : hostname:`hostname` target:$target -------------------------- | tee $TEE_FILE
  yangcli-pro --server=$target $COMMON_PARAMS --run-command="list commands" 
  RETVAL=$?
  echo $0 $target `date` Cmd1: RetVal: $RETVAL
  yangcli-pro --server=$target $COMMON_PARAMS --run-command="list commands" >> $TEE_FILE 
  RETVAL=$?
  echo $0 $target `date` Cmd2: RetVal: $RETVAL
  yangcli-pro --server=$target $COMMON_PARAMS --run-command="$RADIO_COMMAND" 
  RETVAL=$?
  echo $0 $target `date` Cmd3: RetVal: $RETVAL
  yangcli-pro --server=$target $COMMON_PARAMS --run-command="$RADIO_COMMAND" >> $TEE_FILE
  RETVAL=$?
  echo $0 $target `date` Cmd4: RetVal: $RETVAL
  yangcli-pro --server=$target $COMMON_PARAMS --run-command="$JAMMER_COMMAND" 
  RETVAL=$?
  echo $0 $target `date` Cmd5: RetVal: $RETVAL
  yangcli-pro --server=$target $COMMON_PARAMS --run-command="$JAMMER_COMMAND" >> $TEE_FILE
  RETVAL=$?
  echo $0 $target `date` Cmd6: RetVal: $RETVAL
  #yangcli-pro --server=$target $COMMON_PARAMS --run-command="$SENSOR_COMMAND" >> $TEE_FILE
  #yangcli-pro --server=$target $COMMON_PARAMS --run-command="$SENSOR_COMMAND" 

  echo "$0 $target `date` Done ($target)"

done
fi
