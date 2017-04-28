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

# Note, 'daemon' is really a misnomer, this script is exptected to be
# called  repeatedly by the actual daemon process

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

TRIGGER_FILE=/var/opt/taga/run/yangcli-pro.taga.run.script

DATED_TRIGGER_FILE1=$TRIGGER_FILE.dated.1
DATED_TRIGGER_FILE2=$TRIGGER_FILE.dated.2

touch $DATED_TRIGGER_FILE1
touch $DATED_TRIGGER_FILE2

iteration=$1
LOG_FILE=/tmp/`basename $0`.log

/usr/bin/sudo /usr/bin/touch                         $LOG_FILE
/usr/bin/sudo /bin/chmod 777                         $LOG_FILE
/usr/bin/sudo /bin/echo                           >> $LOG_FILE
/usr/bin/sudo /bin/echo $0:`date`:Iter:$iteration >> $LOG_FILE
/usr/bin/sudo /bin/echo                           >> $LOG_FILE

AUDIT_MODVAL=2
let CHECKVAL=$iteration%$AUDIT_MODVAL
if [ $CHECKVAL -eq 0 ] ; then
  echo                                              >> $LOG_FILE
  echo iteration:$iteration : Audit In Progress ... >> $LOG_FILE
  echo                                              >> $LOG_FILE
  if [ -f $TRIGGER_FILE ] ; then
     ls -lrt $TRIGGER_FILE > $DATED_TRIGGER_FILE1
     diff $DATED_TRIGGER_FILE1 $DATED_TRIGGER_FILE2 
     if [ $? -eq 0 ] ; then
        echo $TRIGGER_FILE already processed!, exiting no action >> $LOG_FILE
        exit
     else
        echo $TRIGGER_FILE is new and has not yet been processed!, processing now >> $LOG_FILE
        echo "yangcli-pro --run-script $TRIGGER_FILE"  >> $LOG_FILE
        yangcli-pro --run-script $TRIGGER_FILE         >> $LOG_FILE
        cp $DATED_TRIGGER_FILE1 $DATED_TRIGGER_FILE2 
     fi
  fi 
else
  echo iteration:$iteration : Audit Not In Progress, exiting ... >> $LOG_FILE
  exit
fi

