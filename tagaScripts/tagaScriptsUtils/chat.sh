#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2018
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
TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

if [ -f ~/Downloads/ssh-chat/ssh-chat ] ; then
	echo okay >/dev/null
else
	echo
	echo "Error: The file ~/Downloads/ssh-chat/ssh-chat does not exist."
	echo "Please install ssh-chat at ~/Downloads/ssh-chat/ssh-chat, exiting..."
	echo
	exit
fi

CHAT_HEAD=$TAGA_HEAD

echo
echo "Usage: chat [ Chat_Server_IP | Hostname ] (Chat_Server_IP defaults to TAGA HEAD)"
echo
echo "Example Usage:"
echo " chat           # Chat using the default SSH CHAT Server (default is TAGA HEAD)"
echo " chat localhost # Chat using myself as the SSH CHAT Server"
echo " chat 1.2.3.4   # Chat using alternate SSH CHAT Server 1.2.3.4"
echo

if [ $# -ge 1 ] ; then
   CHAT_HEAD=$1
fi

LOGFILE=/tmp/`basename $0`.log
ERRFILE=/tmp/`basename $0`.err

echo; echo $0 : $MYIP :  executing at `date`; echo
echo $0 : $MYIP :  executing at `date` >> $LOGFILE

echo $0 : Enter a Chat ID of 16 chars or less. 
echo $0 : Enter a Chat ID of 16 chars or less.  >> $LOGFILE
echo

read MY_CHAT_ID

if [ $MY_CHAT_ID == "" ] ; then
   echo
   echo Invalid Chat ID, exiting...
   echo
   exit
fi

let chatIdSize=`echo $MY_CHAT_ID | wc -c`

let chatIdSize=$chatIdSize-1 # account for extra char

if [ $chatIdSize -gt 16 ] ; then
   echo "Invalid Chat ID Size ($chatIdSize), exiting..."
   exit
fi


if [ $MYIP == $CHAT_HEAD ] || [ "localhost" == $CHAT_HEAD ] ; then
   #echo TAGA HEAD: Starting SSH Chat Server if not already started...
   echo
   if ps -ef | grep ssh-chat | grep -v grep >/dev/null ; then
      echo SSH Chat Server is already running... > /dev/null
   else
      echo TAGA HEAD: Starting SSH Chat Server...; echo
      cd; cd Downloads/ssh-chat;./ssh-chat > $LOGFILE 2> $ERRFILE & 

      let started=0
      while [ $started -eq 0 ]
      do
         echo SSH Chat Server is Initializing...
         sleep 1
         if ps -ef | grep ssh-chat | grep -v grep >/dev/null ; then
            let started=1
         fi
      done

   fi
fi

echo

echo $0 : Starting SSH CHAT Client with chat ID: $MY_CHAT_ID. 
echo $0 : Starting SSH CHAT Client with chat ID: $MY_CHAT_ID. >> $LOGFILE

echo

echo $0 : Note: Enter ctrl-D to exit SSH CHAT Client. 
echo $0 : Note: Enter ctrl-D to exit SSH CHAT Client. >> $LOGFILE

echo

ssh -l $MY_CHAT_ID $CHAT_HEAD -p 2022

if [ $? -eq 0 ]; then
   echo okay >/dev/null
else
   echo
   echo Note: ssh failed. Please ensure $CHAT_HEAD is a valid IP Address or Hostname, ensure connectivity to $CHAT_HEAD, and ensure SSH Chat Server is running there.
   echo
   if [ $TAGA_HEAD == $CHAT_HEAD ] ; then
      echo "Note: SSH Chat Server can be started on $CHAT_HEAD by typing 'chat' on $CHAT_HEAD"
   else
      echo "Note: If $CHAT_HEAD is a valid IP address or hostname, then SSH Chat Server can be started on $CHAT_HEAD by typing 'chat $CHAT_HEAD' on $CHAT_HEAD"
   fi
   echo
fi

