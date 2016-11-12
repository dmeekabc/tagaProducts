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

echo; echo $0 : $MYIP :  executing at `date`; echo


# dlm temp, this is really the daemon worker thread; 
# this (bash shell) script is periodically called by 
# the actual (python) deaemon process 

# continue to execute the command
echo `basename $0` Proceeding.... at `date`; echo

iteration=$1

if [ $iteration -eq 1 ]; then
   echo `basename $0` iteration: $iteration
fi

/usr/bin/sudo /bin/touch                              /tmp/tlm_daemon.out
/usr/bin/sudo /bin/touch                              /tmp/tlm_audit.log

/usr/bin/sudo /bin/chmod 777                          /tmp/tlm_daemon.out
/usr/bin/sudo /bin/chmod 777                          /tmp/tlm_audit.log

/usr/bin/sudo /bin/echo `date` : iter:$iteration  >>  /tmp/tlm_daemon.out
/usr/bin/sudo /bin/echo `date` : iter:$iteration  >>  /tmp/tlm_daemon_fix.log



myState=`cat /var/opt/jtmnm/run/jteState.dat`
echo myState: $myState
echo AUDITOR: $AUDITOR
echo MYIP: $MYIP

if [ $TLM_AUDIT_ENABLED -eq 1 ] ; then
   date
   echo TLM AUDIT is ENABLED - Proceeding with Audit NOW! > /dev/null
   echo `basename $0` `date`                                          >> /tmp/tlm_audit.log
   echo TLM AUDIT is ENABLED - Proceeding with Audit NOW! >> /tmp/tlm_audit.log
else
   date
   echo TLM AUDIT is DISABLED - EXITING NOW!
   echo `basename $0` `date`                             >> /tmp/tlm_audit.log
   echo TLM AUDIT is DISABLED - EXITING NOW! >> /tmp/tlm_audit.log
   exit
fi

# Do the Audit Periodically (based on AUDIT_MODVAL)
if echo $AUDITOR | grep $MYIP ; then
  AUDIT_MODVAL=1
  AUDIT_MODVAL=10
  let CHECKVAL=$iteration%$AUDIT_MODVAL
  if [ $CHECKVAL -eq 0 ]; then
     let auditEnabled=1
  else
     let auditEnabled=0
  fi
else
  echo I am not An Auditor,  Audit Not Enabled on this node.!
  let auditEnabled=0
fi

if [ $auditEnabled -eq 1 ]; then
   echo Audit In Progress, Note, this may take some time...
fi

