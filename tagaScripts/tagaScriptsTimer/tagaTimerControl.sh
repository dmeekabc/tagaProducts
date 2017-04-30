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

#TAGA_DIR=~/scripts/taga
#TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
#source $TAGA_CONFIG_DIR/config

LOG_FILE=/tmp/`basename $0`.log

/usr/bin/sudo /usr/bin/touch $LOG_FILE
/usr/bin/sudo /bin/chmod 777 $LOG_FILE
/usr/bin/sudo /bin/echo `date` : 123 >> $LOG_FILE

echo `date` : Waiting until $PRESET_CHANGE_TRIGGER minute time boundary	
echo `date` : Waiting until $PRESET_CHANGE_TRIGGER minute time boundary >> $LOG_FILE	

if [ $PRESET_CHANGE_TRIGGER -eq 1 ] ; then
   $tagaScriptsTimerDir/minute.sh >> $LOG_FILE
elif [ $PRESET_CHANGE_TRIGGER -eq 2 ] ; then
   $tagaScriptsTimerDir/twominute.sh >> $LOG_FILE
elif [ $PRESET_CHANGE_TRIGGER -eq 5 ] ; then
   $tagaScriptsTimerDir/fiveminute.sh >> $LOG_FILE
elif [ $PRESET_CHANGE_TRIGGER -eq 10 ] ; then
   $tagaScriptsTimerDir/tenminute.sh >> $LOG_FILE
elif [ $PRESET_CHANGE_TRIGGER -eq 20 ] ; then
   $tagaScriptsTimerDir/twentyminute.sh >> $LOG_FILE
elif [ $PRESET_CHANGE_TRIGGER -eq 30 ] ; then
   $tagaScriptsTimerDir/halfhour.sh >> $LOG_FILE
   # verifiation that nothing has changed here!!, e.g. re-read the database!
elif [ $PRESET_CHANGE_TRIGGER -eq 60 ] ; then
   $tagaScriptsTimerDir/hour.sh >> $LOG_FILE
else
   # default, no delay hence no database change...
   echo no delay! 
   echo no delay! >> $LOG_FILE
fi

let retCode=$?

if [ $retCode -eq 1 ] || [ $retCode -eq 2 ] ; then
   echo `date` : Notice: TRUNCATED  Wait until $PRESET_CHANGE_TRIGGER minute time boundary... retCode: $retCode 	
   echo `date` : Notice: TRUNCATED  Wait until $PRESET_CHANGE_TRIGGER minute time boundary... retCode: $retCode >> $LOG_FILE 	
else
   echo `date` : DONE Waiting until $PRESET_CHANGE_TRIGGER minute time boundary
   echo `date` : DONE Waiting until $PRESET_CHANGE_TRIGGER minute time boundary >> $LOG_FILE	
fi

# pass the return code to external caller
exit $retCode
