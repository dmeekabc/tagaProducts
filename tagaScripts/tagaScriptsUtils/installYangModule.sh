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

############################################################
# Primary Module Directory and Template File Configuration
# Note: Ensure these are properly set for your system
############################################################
SOURCE_DIR=~/

########################
# Sensitive Info Section (Sanitize before distributing)
########################
SERVER=YourServerNameGoesHere
USER=YourUserIdGoesHere
PASSWORD=YourPasswordGoesHere

echo; echo $0 : $MYIP :  executing at `date`; echo

if [ -f $SOURCE_DIR/$1/src/Makefile ] ; then
  echo
  echo $SOURCE_DIR/$1/src/Makefile exists ... continuing...
  echo
else
  echo
  echo $SOURCE_DIR/$1/src/Makefile does not exist! ... exiting with no action...
  echo
  exit
fi

# provide the info to print into the confirmation request
InfoToPrint="$SOURCE_DIR/$1/src will be built, installed, and loaded into the running server"

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

# get the parameter input
YANGMODULE=$1
yangmodule=$YANGMODULE

cd $SOURCE_DIR/$1/src

sudo make clean
echo make clean ret: $?
sudo make
echo make ret: $?
sudo make install
echo make install ret: $?

ls -lrt `pwd`
echo
echo Newly Built Yang Module is found at: $SOURCE_DIR/$1/src
echo New Yang Source Files are in: `pwd`
echo

sleep 1

# Okay, Now Load it!
echo Loading new yang module into running system/server
yangScript=/tmp/yangcli-pro-loadModule.script
echo "connect --server=$SERVER --user=$USER --password=$PASSWORD"  > $yangScript
echo "load $1"                                                    >> $yangScript
echo "quit"                                                       >> $yangScript
yangcli-pro --run-script                                             $yangScript
