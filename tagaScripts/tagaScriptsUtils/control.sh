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

TAGA_DIR=/opt/taga
TAGA_CONFIG_DIR=$TAGA_DIR/config
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

function previousScreen {

while true
do
   # get the config
   source $TAGA_CONFIG_DIR/config

   echo
   echo Getting TAGA Modes and Network Context from Database...
   echo

   messageTransferMode="TagaMessageTransferMode"
   fileTransferMode="TagaFileTransferMode"

   # Okay, do the output here!
   clear

   # issue the header display
   echo "                                                                Screen 1 of 2"
   echo -------------------------------------------------------------------------------
   echo TAGA Control : `date` 
   echo -------------------------------------------------------------------------------
   echo Message-Transfer-Mode: $messageTransferMode
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $TAGA_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo
   echo Command Options:
   echo " 1. Network Ping"    
   echo " 2. Network Probe - Brief"    
   echo " 3. Network Probe - Verbose"    
   echo " 4. Network State - Polling-based"    
   echo " 5. Network State - Polling-based ------ Run/Watch/Repeat"    
   echo
   echo "Please Enter Command Choice (1..5) or 'n' for next screen or '0' to Exit:"

   read input

   #echo input:$input

   if [ $input ] ; then

   if [ $input == 'n' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      nextScreen
      continue

   elif [ $input -eq 1 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/pingNet.sh singleLoopflag

   elif [ $input -eq 2 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probe.sh singleLoopflag

   elif [ $input -eq 3 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probew.sh singleLoopflag

   elif [ $input -eq 4 ] ; then
      echo Commmand Choice $input proceeding...
      sleep 1; clear; echo; date
      /opt/taga/scripts/getStateTAGA.sh
      sleep 2

   elif [ $input -eq 5 ] ; then
      while true
         do
         echo Commmand Choice $input proceeding...
         sleep 1; clear; echo; date
         /opt/taga/scripts/getStateTAGA.sh
         sleep 2
      done

   elif [ $input -eq 0 ] ; then
      echo Exiting...
      exit

   else
      echo Invalid Commmand Input \($input\) , no action taken!
      sleep 1
      continue
   fi
   else
      echo No input provided, no action taken!
      sleep 1
      continue
   fi

   sleep 2

   # Okay, do the output here!
   clear
   sleep 1

done

}


function nextScreen {

while true
do
   # get the config
   source $TAGA_CONFIG_DIR/config

   echo
   echo Getting TAGA Modes and Network Context from Database...
   echo

   messageTransferMode="TagaMessageTransferMode"
   fileTransferMode="TagaFileTransferMode"

   # Okay, do the output here!
   clear

   # issue the header display
   echo "                                                                Screen 2 of 2"
   echo -------------------------------------------------------------------------------
   echo TAGA Control : `date` 
   echo -------------------------------------------------------------------------------
   echo Message-Transfer-Mode: $messageTransferMode
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $TAGA_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo
   echo Command Options:
   echo " 1. Network Ping"    
   echo " 2. Network Probe - Brief"    
   echo " 3. Network Probe - Verbose"    
   echo " 4. Network State - Polling-based"    
   echo " 5. Network State - Polling-based ------ Run/Watch/Repeat"    
   echo
   echo "Please Enter Command Choice (1..5) or 'p' for previous screen or '0' to Exit:"

   read input

   if [ $input ] ; then

   if [ $input == 'p' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      previousScreen
      continue

   elif [ $input -eq 1 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/pingNet.sh singleLoopflag

   elif [ $input -eq 2 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probe.sh singleLoopflag

   elif [ $input -eq 3 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probew.sh singleLoopflag

   elif [ $input -eq 4 ] ; then
      echo Commmand Choice $input proceeding...
      sleep 1; clear; echo; date
      /opt/taga/scripts/getStateTAGA.sh
      sleep 2

   elif [ $input -eq 5 ] ; then
      while true
         do
         echo Commmand Choice $input proceeding...
         sleep 1; clear; echo; date
         /opt/taga/scripts/getStateTAGA.sh
         sleep 2
      done

   elif [ $input -eq 0 ] ; then
      echo Exiting...
      exit

   else
      echo Invalid Commmand Input \($input\) , no action taken!
      sleep 1
      continue
   fi
   else
      echo No input provided, no action taken!
      sleep 1
      continue
   fi

   sleep 2

   # Okay, do the output here!
   clear
   sleep 1

done


}

###############
# MAIN
###############

while true
do
   # get the config
   source $TAGA_CONFIG_DIR/config

   echo
   echo Getting TAGA Modes and Network Context from Database...
   echo

   messageTransferMode="TagaMessageTransferMode"
   fileTransferMode="TagaFileTransferMode"

   # Okay, do the output here!
   clear

   # issue the header display
   echo "                                                                Screen 1 of 2"
   echo -------------------------------------------------------------------------------
   echo TAGA Control : `date`
   echo -------------------------------------------------------------------------------
   echo Message-Transfer-Mode: $messageTransferMode
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $TAGA_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo
   echo Command Options:
   echo " 1. Network Ping"    
   echo " 2. Network Probe - Brief"    
   echo " 3. Network Probe - Verbose"    
   echo " 4. Network State - Polling-based"    
   echo " 5. Network State - Polling-based ------ Run/Watch/Repeat"    
   echo
   echo "Please Enter Command Choice (1..5) or 'n' for next screen or '0' to Exit:"

   read input

   if [ $input ] ; then

   #echo input:$input

   if [ $input == 'n' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      nextScreen
      continue

   elif [ $input -eq 1 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/pingNet.sh singleLoopflag

   elif [ $input -eq 2 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probe.sh singleLoopflag

   elif [ $input -eq 3 ] ; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probew.sh singleLoopflag

   elif [ $input -eq 4 ] ; then
      echo Commmand Choice $input proceeding...
      sleep 1; clear; echo; date
      /opt/taga/scripts/getStateTAGA.sh
      sleep 2

   elif [ $input -eq 5 ] ; then
      while true
         do
         echo Commmand Choice $input proceeding...
         sleep 1; clear; echo; date
         /opt/taga/scripts/getStateTAGA.sh
         sleep 2
      done

   elif [ $input -eq 0 ] ; then
      echo Exiting...
      exit

   else
      echo Invalid Commmand Input \($input\) , no action taken!
      sleep 1
      continue
   fi
   else
      echo No input provided, no action taken!
      sleep 1
      continue
   fi

   sleep 2

   # Okay, do the output here!
   clear
   sleep 1

done
