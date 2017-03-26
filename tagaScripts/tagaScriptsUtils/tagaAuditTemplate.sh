#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2017
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

##################################
# IBOA TAGA Standard Includes
##################################
TAGA_DIR=~/scripts/taga
TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

##################################
# IBOA TAGA Standard Defines
##################################
LOG_FILE=/tmp/`basename $0`.log

##################################
# IBOA TAGA Standard Init
##################################

# Standard Entry Print
echo; echo $0 : $MYIP :  executing at `date`; echo

# Standard Input Verification
if [ $# -ne 1 ] ; then
   echo "Warning: $0 expects one parameter (parameter missing)"
   echo continuing without iteration identifier...
   sleep 1
fi

# Get the iteration 
iteration=$1; echo iteration:$iteration


#################################
# Function -  IBOA TAGA Standard Log Output
#################################
function printLogStandard 
{
   /usr/bin/sudo /usr/bin/touch $LOG_FILE
   /usr/bin/sudo /bin/chmod 777 $LOG_FILE
   /usr/bin/sudo /bin/echo >> $LOG_FILE
   /usr/bin/sudo /bin/echo $0:`date`:Iter:$iteration >> $LOG_FILE
   /usr/bin/sudo /bin/echo >> $LOG_FILE
}

##########################
# IBOA TAGA Audit Main
##########################
# Print Standard Log Info
printLogStandard 

##########################
# IBOA TAGA Audit Modulus
##########################
AUDIT_MODVAL=10
AUDIT_MODVAL=2
let CHECKVAL=$iteration%$AUDIT_MODVAL
if [ $CHECKVAL -eq 0 ] ; then
  echo >> $LOG_FILE
  echo iteration:$iteration : Audit In Progress ... >> $LOG_FILE
  echo >> $LOG_FILE
fi

##########################
# IBOA TAGA Standard Exit
##########################

# Standard Exit Print
echo; echo $0 : $MYIP :  exiting normally at `date`; echo
exit

