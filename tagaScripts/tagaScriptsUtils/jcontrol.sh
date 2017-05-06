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

TAGA_DIR=/cf/var/home/tagaxxx
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let VERBOSE=1
let VERBOSE=0
let DEBUG=1
let DEBUG=0

echo; echo $0 : $MYIP :  executing at `date`; echo

##########################
# Config Screen 
##########################

function singleParamHandling {

   if [ $1 == 'p' ] ; then
      $previous
   elif [ $1 == 'c' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      configScreen
      continue
   elif [ $1 == 't' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      testScreen
      continue
   elif [ $1 == 'q' ] ; then
      echo Quiting...
      exit
   elif [ $1 == 'x' ] ; then
      echo Exiting...
      exit
   fi

   if [ $1 -eq 5 ] ; then
      cat $tagaUtilsDir/context.txt
      echo
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 6 ] ; then
      echo Enabling Auto Confirm...
      sleep 1
      /opt/tagaxxx/scripts/utils/putAutoConfirm.sh 1
   elif [ $1 -eq 7 ] ; then
      echo Disabling Auto Confirm...
      sleep 1
      /opt/tagaxxx/scripts/utils/putAutoConfirm.sh 0
   elif [ $1 -eq 11 ] ; then
      echo Editing Target List...
      sleep 1
      vi $tagaConfigDir/targetList.sh
   elif [ $1 -eq 12 ] ; then
      echo Synching Target List...
      sleep 1
      $tagaUtilsDir/synchTargetList.sh
   else
      echo
      echo Single Param Handling Not Fully Implemented.
      echo Command option $1 not yet implemented.
      echo No action taken.
      echo
      sleep 2
   fi
}


function singleParamHandlingTestScreen {


   if [ $1 == 'p' ] ; then
      $previous
   elif [ $1 == 'c' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      configScreen
      continue
   elif [ $1 == 't' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      testScreen
      continue
   elif [ $1 == 'q' ] ; then
      echo Quiting...
      exit
   elif [ $1 == 'x' ] ; then
      echo Exiting...
      exit
   fi

   if [ $1 -eq 4 ] ; then
      echo Rebooting Network...
      $tagaUtilsDir/rebootAll.sh
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 10 ] ; then
      echo Network State, Polling Based...
      $tagaUtilsDir/networkStateWindow.sh
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 11 ] ; then
      echo Preparing Keys...
      $tagaUtilsDir/prep.sh
      $tagaUtilsDir/prepAll.sh
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 12 ] ; then
      echo Preparing Root Keys...
      $tagaUtilsDir/prepRoot.sh
      $tagaUtilsDir/prepRootAll.sh
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 31 ] ; then
      echo
      echo "Synchronizing Target List..."
      echo
      $tagaUtilsDir/synchTargetList.sh
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 32 ] ; then
      echo
      echo "ADDING Link Loss Rule for Entire Network..."
      echo
      $tagaUtilsDir/probeSetNetLoss.sh A  # A for Add Rule 
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 33 ] ; then
      echo
      echo "DELETING Link Loss Rule for Entire Network..."
      echo
      $tagaUtilsDir/probeSetNetLoss.sh D # D for Delete Rule
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 40 ] ; then
      echo
      echo "Subscribing for All Notifications..."
      echo
      # Do Business Logic Command Here
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   else
      echo
      echo Single Param Handling Not Fully Implemented.
      echo Command option $1 not yet implemented.
      echo No action taken.
      echo
      sleep 2
   fi
}



function doubleParamHandling {

   input1=$1
   input2=$2

   # Double Param Handling Below

   # re-source the config in case it changed while we were sitting at the user menu
   source $TAGA_CONFIG_DIR/config

   if [ $input1 -eq 1 ] || [ $input1 -eq 2 ] || [ $input1 -eq 3 ] || [ $input1 -eq 4 ] || [ $input1 -eq 5 ] ; then

      if [ $input2 == 'a' ] || [ $input2 == 'b' ] || [ $input2 == 'c' ]; then
         #echo input1:$input1
         #echo input2:$input2
         
         if [ $input1 -eq 1 ] ;then
            messageMode="TAGAMODE1"
         elif [ $input1 -eq 2 ] ;then
            messageMode="TAGAMODE2"
         elif [ $input1 -eq 3 ] ;then
            messageMode="TAGAMODE3"
         else
            messageMode="TAGAMODE1"
         fi

         if [ $input2 == 'a' ] ; then
            fileMode="PROTO1"
         elif [ $input2 == 'b' ] ; then
            fileMode="PROTO3"
         elif [ $input2 == 'c' ] ; then
            fileMode="PROTO2"
         else
            fileMode="PROTO1"
         fi

         echo
         echo Your Choices: MessageTransferMode:$messageMode  FileTransferMode:$fileMode
         echo

         if [ $input1 -eq 1 ] ;then
            echo Configuring for TAGAMODE1 message transfer mode
         elif [ $input1 -eq 2 ] ;then
            echo Configuring for TAGAMODE2 message transfer mode
         elif [ $input1 -eq 3 ] ;then
            echo Configuring for TAGAMODE3 message transfer mode
         elif [ $input1 -eq 4 ] ;then
            echo Configuring for PROTO3 message transfer mode
         elif [ $input1 -eq 5 ] ;then
            echo Configuring for PROTO3 message transfer mode
         else
            echo Configuring for TAGAMODE1 message transfer mode
         fi

         if [ $input2 == 'a' ] ; then
            echo Configuring for PROTO1 file transfer mode
         elif [ $input2 == 'b' ] ; then
            echo Configuring for PROTO2 file transfer mode
         elif [ $input2 == 'c' ] ; then
            echo Configuring for PROTO3 file transfer mode
         else
            echo Configuring for PROTO1 file transfer mode
         fi

         # Commit All Changes
         echo; echo Committing changes to the database...; echo

      else
         echo Invalid Input! Returning with no action!
      fi
   else
      echo Invalid Input! Returning with no action!
   fi

}

function doubleParamHandlingTest {

   input1=$1
   input2=$2

   # doubleaParamHandlingTest is in-line below
   # doubleaParamHandlingTest is in-line below

   # re-source the config in case it changed while we were sitting at the user menu
   source $TAGA_CONFIG_DIR/config

   if [ $input1 -eq 1 ] || [ $input1 -eq 2 ] || [ $input1 -eq 3 ] || [ $input1 -eq 4 ] || [ $input1 -eq 5 ] ; then

      if [ $input2 == 'a' ] || [ $input2 == 'b' ] || [ $input2 == 'c' ]; then
         #echo input1:$input1
         #echo input2:$input2
         
         if [ $input1 -eq 1 ] ;then
            tagaMode="RUN"
         elif [ $input1 -eq 2 ] ;then
            tagaMode="RUN"
         elif [ $input1 -eq 3 ] ;then
            tagaMode="RUN"
         elif [ $input1 -eq 4 ] ;then
            tagaMode="RUN"
         elif [ $input1 -eq 5 ] ;then
            tagaMode="RUN and MON"
         else
            tagaMode="RUN"
         fi

         if [ $input2 == 'a' ] ; then
            tagaRate="low"
         elif [ $input2 == 'b' ] ; then
            tagaRate="medium"
         elif [ $input2 == 'c' ] ; then
            tagaRate="high"
         else
            tagaRate="low"
         fi

         echo
         echo Your Choices: TagaMode::$tagaMode  tagaRate:$tagaRate
         echo

         if [ $input1 -eq 1 ] ;then
            echo Configuring for TAGA RUN mode
         elif [ $input1 -eq 2 ] ;then
            echo Configuring for TAGA RUN mode
         elif [ $input1 -eq 3 ] ;then
            echo Configuring for TAGA RUN mode
         elif [ $input1 -eq 4 ] ;then
            echo Configuring for TAGA RUN mode
         elif [ $input1 -eq 5 ] ;then
            echo Configuring for TAGA RUN mode
         else
            echo Configuring for TAGA RUN mode
         fi

         if [ $input2 == 'a' ] ; then
            echo Configuring for low TAGA rate
         elif [ $input2 == 'b' ] ; then
            echo Configuring for medium TAGA rate
         elif [ $input2 == 'c' ] ; then
            echo Configuring for high TAGA rate
         else
            echo Configuring for low TAGA rate
         fi

         # Start the TAGA RUN process
         /cf/var/home/tagaxxx/tagaScripts/tagaScriptsRun/runLoopWrapper.sh >/tmp/tcon_taga.out   2>/tmp/tcon_taga.err &

         # Start the Monitor
         TAGA_MON_DIR=/cf/var/home/tagaxxx/tagaRUN
         touch $TAGA_MON_DIR/counts.txt
         tail -f $TAGA_MON_DIR/counts.txt  > /tmp/tcon_taga_mon.out  & 

         echo Running TAGA in background... 
         echo Running TAGA MON in background... 

         echo See /tmp/tcon_taga.out and /tmp/tcon_taga.err for TAGA RUN stdout and stderr
         echo See /tmp/tcon_taga_mon.out for TAGA MON stdout 

         echo Opening Monitoring Windows...
         $tagaUtilsDir/tagaMon.sh

         sleep 5

         # Commit All Changes
         #echo; echo Committing changes to the database...; echo

      else
         echo Invalid Input! Returning with no action!
      fi
   else
      echo Invalid Input! Returning with no action!
   fi

}

function tripleParamHandling {

   if [ $DEBUG -eq 1 ] ; then
      echo param1:$1
      echo param2:$2
      echo param3:$3
   fi

   if [ $1 -eq 1 ] && [ $2 == 'a' ]; then
      if [ $3 -lt 1000000 ]; then
          echo ConfirmCommitTimer being set to $3... 
          $JUN_UTILS_DIR/putConfirmCommitTimer.sh $3
      else
          echo Invalid ConfirmCommitTimer, no action taken...
      fi  
   elif [ $1 -eq 1 ] && [ $2 == 'b' ]; then
      if [ $3 -lt 1000000 ]; then
          echo ActionTriggerInterval being set to $3... 
          $JUN_UTILS_DIR/putActionTriggerInterval.sh $3
      else
          echo Invalid ConfirmCommitTimer, no action taken...
      fi  
   else
      echo Triple Param Handling Not Fully Implemented.
      echo Triple Param Input - Not Fully Implemented.
      echo No action taken...
   fi
}


function tripleParamHandlingTest {

   if [ $DEBUG -eq 1 ] ; then
      echo param1:$1
      echo param2:$2
      echo param3:$3
   fi

   if [ $1 -eq 1 ] && [ $2 == 'a' ]; then
      echo
      echo "ADDING Link Loss Rule for Entire Network..."
      echo
      Percent=$3
      $tagaUtilsDir/probeSetNetLoss.sh A $Percent  # A for Add Rule 
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   elif [ $1 -eq 1 ] && [ $2 == 'b' ]; then
      echo
      echo "DELETING Link Loss Rule for Entire Network..."
      echo
      Percent=$3
      $tagaUtilsDir/probeSetNetLoss.sh D $Percent  # D for Delete Rule 
      echo;echo Sleeping for 10 seconds...;echo
      sleep 10
   else
      echo Triple Param Handling Not Fully Implemented.
      echo Triple Param Input - Not Fully Implemented.
      echo No action taken...
   fi
}


function configScreen {

   while true
   do

   # get the config
   source $TAGA_CONFIG_DIR/config

   let autoConfirm=`$tagaUtilsDir/getAutoConfirm.sh | cut -d: -f 2`

   # Okay, do the output here!
   clear

   # Reset input vars
   input1=""
   input2=""
   input3=""

   # issue the header display
   echo "                                                               Screen: Config"
   echo -------------------------------------------------------------------------------
   echo JUNOS Control : `date` 
   echo -------------------------------------------------------------------------------
   echo "Message-Transfer-Mode: $messageTransferMode                 AutoConfirm:$autoConfirm "
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $JUN_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo Single Param Section
   echo --------------------
   echo " 1. Enable  Logging                        5. Print context.txt     9.  KeyPrep"
   echo " 2. Disable Logging                        6. AUTO CONFIRM enable   10. KeyPrepRoot"
   echo " 3. Enable  Confirm Commit w/  Timeout     7. AUTO CONFIRM disable  11. Edit  Target List"
   echo " 4. Enable  Confirm Commit w/o Timeout     8. TBD8                  12. Synch Target List"
   echo --------------------
   echo "Single Parameter User Input : Please Enter a Selection 1-12."
   echo
   echo Double Param Section
   echo --------------------
   echo "Message Transfer Mode:      File Transfer Mode:" 
   echo "----------------------      --------------------" 
   echo " 1. TAGAMODE1                a. PROTO1"    
   echo " 2. TAGAMODE2                b. PROTO2"    
   echo " 3. TAGAMODE3                c. PROTO3"    
   echo --------------------
   echo "Please Enter a Message Transfer Mode and a File Transfer Mode, e.g. 1 a for TAGAMODE1 and PROTO1"
   echo "Double Parameter User Input : <MessageTransferMode FileTransferMode>?"
   echo
   echo Triple Param Section
   echo --------------------
   echo "Param1:               Param2:                                       Param3:" 
   echo "------------------    ------------------------------------------    ---------"
   echo " 1. PUT               a. ConfirmCommitTimer (secs < 1000000)        Value"    
   echo " 2. TBD2              b. ActionTriggerInterval min boundary)"    
   echo "                         (1, 2, 5, 10, 20, 30, or 60 mins)"
   echo " 3. TBD3              c. TBDc"    
   echo " 4. TBD4              d. TBDd"    
   echo " 5. TBD5              e. TBDe"    
   echo --------------------
   echo "Please Enter a Param1, Param2, and Param3 e.g. \"1 a 300\" for PUT ConfirmCommitTimer 300 secs."
   echo "Triple Parameter User Input : <Param1 Param2 Param3>?"
   echo
   echo "Please Enter Single, Double, or Triple Parameter Command Choice or one of the following:"
   echo "[ (p)revious | (c)onfig | (t)est | (q)uit | e(x)it) ]" 

   read input1 input2 input3

   if [ ! $input3 ] ; then
      if [ ! $input2 ] ; then
         if [ ! $input1 ] ; then
            echo No Input Provided, no action taken
            #return
         else
            singleParamHandling $input1 
            #return
         fi
      else
         doubleParamHandling  $input1 $input2
         #return
      fi
   else
      tripleParamHandling $input1 $input2 $input3
      #return
   fi

   done

}


function testScreen {

   while true
   do

   # get the config
   source $TAGA_CONFIG_DIR/config

   let autoConfirm=`$tagaUtilsDir/getAutoConfirm.sh | cut -d: -f 2`

   # Okay, do the output here!
   clear

   # Reset input vars
   input1=""
   input2=""
   input3=""

   # issue the header display
   echo "                                                                 Screen: Test"
   echo -------------------------------------------------------------------------------
   echo JUNOS Control : `date` 
   echo -------------------------------------------------------------------------------
   echo "Message-Transfer-Mode: $messageTransferMode                 AutoConfirm:$autoConfirm "
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $JUN_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo Single Param Section
   echo --------------------
   echo " 1. Enable  Logging 11. Key Prep       21. TagaXXX Parse                  31. Synch Target List"
   echo " 2. Disable Logging 12. Key Prep Root  22. TagaXXX Manager Monitor        32. Add Link Loss Rule"
   echo " 3. TBD             13. TBD            23. TagaXXX Subscription Monitor   33. Delete Link Loss Rule"
   echo " 4. Reboot Network  14. TBD            24. TagaXXX Subscription Mon Loop  34. TBD"
   echo " 5. TBD             15. TBD            25. TBD                            35. TBD"
   echo " 6. TBD             16. TBD            26. TBD                            36. TBD"
   echo " 7. TBD             17. TBD            27. TBD                            37. Subscribe for Taga1 Event"
   echo " 8. TBD             18. TBD            28. TBD                            38. Subscribe for Taga2 Event"
   echo " 9. TBD             19. TBD            29. TBD                            39. Subscribe for Taga3 Events"
   echo "10. Network Monitor 20. TBD            30. TBD                            40. Subscribe for All"
   echo --------------------
   echo "User Input : [ <1-40> ]:"
   echo
   echo Double Param Section
   echo --------------------
   echo "TAGA Msg Type:              Taga Rate: " 
   echo "----------------------      --------------------" 
   echo " 1. UCAST-TCP               a. Low"    
   echo " 2. UCAST-UDP               b. Medium"    
   echo " 3. MCAST-UDP               c. High"    
   echo --------------------
   echo "User Input : [ <TAGAMsgType> <TAGARate> ]:"
   echo
   echo Triple Param Section
   echo --------------------
   echo "Param1:                     Param2:                 Param3:" 
   echo "----------------------      --------------------    --------------------------" 
   echo " 1. Link Loss Rule          a. A (Add Rule)         Value"    
   echo " 2. TBD                     b. D (Delete Rule)"
   echo " 3. TBD                     c. TBD"
   echo " 4. TBD                     d. TBD"
   echo -------- -----------
   echo "User Input : [ <Param1> <Param2> <Param3> ]:"
   echo
   echo "User Input: [ <Param1> [<Param2>] [<Param3>] | (p)revious | (c)onfig | (t)est | (q)uit | e(x)it) ]:" 

   read input1 input2 input3

   if [ ! $input3 ] ; then
      if [ ! $input2 ] ; then
         if [ ! $input1 ] ; then
            echo No Input Provided, no action taken
            #return
         else
            singleParamHandlingTestScreen $input1 
            #return
         fi
      else
         doubleParamHandlingTest  $input1 $input2
         #return
      fi
   else
      tripleParamHandlingTest $input1 $input2 $input3
      #return
   fi

   done

}


##########################
# Next Screen (Business Logic)
##########################

function nextScreen {

while true
do
   # get the config
   source $TAGA_CONFIG_DIR/config

   echo
   echo Getting JUNOS Modes and Network Context from Database...
   echo

   # Get the MODES
   messageTransferMode=`cat /tmp/configRunning.out | grep tagaxxxaMessageTransferMode | cut -d: -f 2`
   fileTransferMode=`cat /tmp/configRunning.out    | grep tagaxxxaFileTransferMode    | cut -d: -f 2`

   let autoConfirm=`$tagaUtilsDir/getAutoConfirm.sh | cut -d: -f 2`

   # Okay, do the output here!
   clear

   # issue the header display
   echo "                                                                Screen: 2 of 2"
   echo -------------------------------------------------------------------------------
   echo JUNOS Control : `date` 
   echo -------------------------------------------------------------------------------
   echo "Message-Transfer-Mode: $messageTransferMode                 AutoConfirm:$autoConfirm "
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $JUN_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo
   echo Command Options:
   echo " 1. Accept All"    
   echo " 2. Accept All COA to COB"    
   echo " 3. Accept All COB to COA"    
   echo " 4. Accept Selected Nodes COA to COB"    
   echo " 5. Accept Selected Nodes COB to COA"    
   echo " 5. TBD"    
   echo " 6. TBD"    
   echo " 7. TBD"    
   echo " 8. TBD"    
   echo " 9. TBD"    
   echo "10. TBD"    
   echo "11. Deny All"    
   echo "12. Deny All COA to COB"    
   echo "13. Deny All COB to COA"    
   echo "14. Deny Selected Nodes COA to COB"    
   echo "15. Deny Selected Nodes COB to COA"    
   echo "16. TBD"    
   echo "17. TBD"    
   echo "18. TBD"    
   echo "19. TBD"    
   echo "20. TBD"    
   echo
   echo "Command Options: 1-20, p-previous screen, c-config screen, t-test screen, q-quit, x-exit"
   echo
   echo "Please Enter Command Choice : [ 1..20 | (p)revious | (c)onfig | (t)est | (q)uit | e(x)it) ]"
   echo

   read input

   # re-source the config in case it changed while we were sitting at the user menu
   source $TAGA_CONFIG_DIR/config

   if [ $input ] ; then

   if [ $input == 'p' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      previous=nextScreen
      previousScreen
      continue

   elif [ $input == 'c' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      configScreen
      continue

   elif [ $input == 't' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      testScreen
      continue

   elif [ $input == 'q' ] ; then
      echo Quiting...
      exit

   elif [ $input == 'x' ] ; then
      echo Exiting...
      exit

   elif [ $input -eq 1 ] ; then
      echo Commmand Choice $input proceeding...

      if [ $CONFIRM_COMMIT_ENABLED -eq 1 ] ; then
         # Do business logic here
         # Do business logic here
         # Do business logic here
      fi
      retCode=$?
      # if the user confirmed the operation and it completed, then change context
      if [ $retCode -ne 2 ] ; then
         echo
         echo "Please verify the following successful and complete JUNOS Network Context change to Network Context 2."
         echo
         sleep 2
         InfoToPrint="Change and Distribute Network Context to 2 now?"
         # issue confirmation prompt and check reponse
         $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
         response=$?; 
         if [ $response -ne 1 ]; then 
            echo Command Not Confirmed, please ensure proper network context 
         else 
             echo Command Confirmed, Proceeding...; 
             $tagaUtilsDir/contextChange.sh 2
         fi
      else
         echo User did not confirm , no action taken >/dev/null
      fi

   elif [ $input -eq 2 ] ; then
      echo Commmand Choice $input proceeding...

      # If confirm commit is enabled, we use the 'controlled' version of the changePresetTAGAX command.
      if [ $CONFIRM_COMMIT_ENABLED -eq 1 ] ; then
         # Do business logic here
         # Do business logic here
         # Do business logic here
      fi
      retCode=$?
      # if the user confirmed the operation and it completed, then change context
      if [ $retCode -ne 2 ] ; then
         echo
         echo "Please verify the following successful and complete JUNOS Network Context change to Network Context 2."
         echo
         #sleep 2
         #$tagaUtilsDir/contextChange.sh 2
         sleep 2
         InfoToPrint="Change and Distribute Network Context to 2 now?"
         # issue confirmation prompt and check reponse
         $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
         response=$?; 
         if [ $response -ne 1 ]; then 
            echo Command Not Confirmed, please ensure proper network context 
         else 
             echo Command Confirmed, Proceeding...; 
             $tagaUtilsDir/contextChange.sh 2
         fi
      else
         echo User did not confirm , no action taken >/dev/null
      fi

   elif [ $input -eq 3 ] ; then
      echo Commmand Choice $input proceeding...

      if [ $CONFIRM_COMMIT_ENABLED -eq 1 ] ; then
         # Do business logic here
         # Do business logic here
         # Do business logic here
      fi
      retCode=$?
      # if the user confirmed the operation and it completed, then change context
      if [ $retCode -ne 2 ] ; then
         echo
         echo "Please verify the following successful and complete JUNOS Network Context change to Network Context 3."
         echo
         #sleep 2
         #$tagaUtilsDir/contextChange.sh 3
         sleep 2
         InfoToPrint="Change and Distribute Network Context to 3 now?"
         # issue confirmation prompt and check reponse
         $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
         response=$?; 
         if [ $response -ne 1 ]; then 
            echo Command Not Confirmed, please ensure proper network context 
         else 
             echo Command Confirmed, Proceeding...; 
             $tagaUtilsDir/contextChange.sh 3
         fi
      else
         echo User did not confirm , no action taken >/dev/null
      fi

   elif [ $input -eq 4 ] ; then
      echo Commmand Choice $input proceeding...

      if [ $CONFIRM_COMMIT_ENABLED -eq 1 ] ; then
         # Do business logic here
         # Do business logic here
         # Do business logic here
      fi
      retCode=$?
      # if the user confirmed the operation and it completed, then change context
      if [ $retCode -ne 2 ] ; then
         echo
         echo "Please verify the following successful and complete JUNOS Network Context change to Network Context 3."
         echo
         #sleep 2
         #$tagaUtilsDir/contextChange.sh 3
         sleep 2
         InfoToPrint="Change and Distribute Network Context to 3 now?"
         # issue confirmation prompt and check reponse
         $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
         response=$?; 
         if [ $response -ne 1 ]; then 
            echo Command Not Confirmed, please ensure proper network context 
         else 
             echo Command Confirmed, Proceeding...; 
             $tagaUtilsDir/contextChange.sh 3
         fi
      else
         echo User did not confirm , no action taken >/dev/null
      fi

   elif [ $input -eq 5 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 6 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 7 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 8 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 9 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 10 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 11 ] ; then
      echo Commmand Choice $input proceeding...
      sleep 2
      echo; echo "Changing Network Context to Context 1 (Business Logic Here)"    
      $tagaUtilsDir/contextChange.sh 1

   elif [ $input -eq 12 ] ; then
      echo Commmand Choice $input proceeding...
      sleep 2
      echo; echo "Changing Network Context to Context 2 (Business Logic Here)"    
      $tagaUtilsDir/contextChange.sh 2

   elif [ $input -eq 13 ] ; then
      echo Commmand Choice $input proceeding...
      sleep 2
      echo; echo "Changing Network Context to Context 3 (Business Logic Here)"    
      $tagaUtilsDir/contextChange.sh 3

   elif [ $input -eq 14 ] ; then
      echo; echo Commmand Choice $input proceeding...
      sleep 2
      echo; echo "Changing Network Context to Context 4 (Business Logic Here)"    
      $tagaUtilsDir/contextChange.sh 4

   elif [ $input -eq 15 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 16 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 17 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 18 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 19 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 20 ] ; then
      echo Commmand Choice $input proceeding...
      echo "Pinging  TagaSelected Active Targets (Network Context based)"    
      $tagaUtilsDir/pingTaga.sh oneIterOnlyFlag

   elif [ $input -eq 21 ] ; then
      echo Commmand Choice $input proceeding...
      echo "Probing  TagaSelected Active Targets (Network Context based)"    
      $tagaUtilsDir/probeTaga.sh

   elif [ $input -eq 22 ] ; then
      echo Commmand Choice $input not yet implmented, no action taken...

   elif [ $input -eq 23 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/pingNet.sh singleLoopflag

   elif [ $input -eq 24 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probe.sh singleLoopflag

   elif [ $input -eq 25 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/probew.sh singleLoopflag
   elif [ $input -eq 26 ] ; then
      echo Commmand Choice $input proceeding...
      echo Committing candidate datastore changes to running datastore...
      sleep 1
      # Do Business Logic Command Here
   elif [ $input -eq 27 ] ; then
      echo Commmand Choice $input proceeding...
      echo Confirming Commit of candidate datastore...
      sleep 1
      # Do Business Logic Command Here
   elif [ $input -eq 28 ] ; then
      echo Commmand Choice $input proceeding...
      echo Canceling Commit of candidate datastore...
      sleep 1
      # Do Business Logic Command Here
   elif [ $input -eq 29 ] ; then
      #echo Commmand Choice $input not yet implmented, no action taken...
      echo Commmand Choice $input proceeding...
      echo Discarding Changes to candidate datastore...
      sleep 1
      # Do Business Logic Command Here
   elif [ $input -eq 30 ] ; then
      echo Commmand Choice $input proceeding...
      echo
      echo "Please verify the following successful and complete JUNOS Network Context change to Network Context 1."
      $tagaUtilsDir/confirm.sh $0 ""
      response=$?; if [ $response -ne 1 ]; then echo Command Not Confirmed, no action taken; continue; else echo Command Confirmed, Proceeding...; fi
      sleep 2
      $tagaUtilsDir/contextChange.sh 1
      # Do Business Logic Command Here
      echo

   else
      echo "Invalid Commmand Input, no action taken!"
      sleep 1
      continue
   fi
   else
      echo "No input provided, no action taken!"
      sleep 1
      continue
   fi

   sleep 2

   # Okay, do the output here!
   clear
   sleep 1

done


}


###############################
# Previous Screen (Main Screen) 
###############################

function previousScreen {

while true
do
   # get the config
   source $TAGA_CONFIG_DIR/config

   echo
   echo Getting JUNOS Modes and Network Context from Database...
   echo

      # Do Business Logic Command Here
   messageTransferMode=`cat /tmp/configRunning.out | grep tagaxxxaMessageTransferMode | cut -d: -f 2`
   fileTransferMode=`cat /tmp/configRunning.out    | grep tagaxxxaFileTransferMode    | cut -d: -f 2`

   let autoConfirm=`$tagaUtilsDir/getAutoConfirm.sh | cut -d: -f 2`

   # Okay, do the output here!
   clear

   # issue the header display
   echo "                                                                Screen: 1 of 2"
   echo -------------------------------------------------------------------------------
   echo JUNOS Control : `date`
   echo -------------------------------------------------------------------------------
   echo "Message-Transfer-Mode: $messageTransferMode                 AutoConfirm:$autoConfirm "
   echo File-Transfer-Mode...: $fileTransferMode 
   echo Network Context......: $JUN_CONTEXT 
   echo -------------------------------------------------------------------------------
   echo
   echo Command Options:
   echo " 1. Permit All"    
   echo " 2. Permit All COA to COB"    
   echo " 3. Permit All COB to COA"    
   echo " 4. Permit Selected Nodes COA PC1 to COB PC4"    
   echo " 5. Permit Selected Nodes COA PC2 to COB PC3"    
   echo " 6. Permit Selected Nodes COB PC4 to COA PC1"    
   echo " 7. Permit Selected Nodes COB PC3 to COA PC2"    
   echo " 5. TBD"    
   echo " 6. TBD"    
   echo " 7. TBD"    
   echo " 8. TBD"    
   echo " 9. TBD"    
   echo "10. TBD"    
   echo "11. Deny All"    
   echo "12. Deny All COA to COB"    
   echo "13. Deny All COB to COA"    
   echo "14. Deny Selected Nodes COA PC1 to COB PC4"    
   echo "15. Deny Selected Nodes COA PC2 to COB PC3"    
   echo "16. Deny Selected Nodes COB PC4 to COA PC1"    
   echo "17. Deny Selected Nodes COB PC3 to COA PC2"    
   echo "16. TBD"    
   echo "17. TBD"    
   echo "18. TBD"    
   echo "19. TBD"    
   echo "20. TBD"    
   echo
   echo "Command Options: 1-20, p-previous screen, c-config screen, t-test screen, q-quit, x-exit"
   echo
   echo "Please Enter Command Choice : [ 1..20 | (n)ext | (c)onfig | (t)est | (q)uit | e(x)it) ]"
   echo

   read input

   if [ $input ] ; then

   # re-source the config in case it changed while we were sitting at the user menu
   source $TAGA_CONFIG_DIR/config

   #echo input:$input

   if [ $input == 'n' ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      clear
      previous=nextScreen
      nextScreen
      continue

   elif [ $input == 'c' ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      clear
      configScreen
      continue

   elif [ $input == 't' ] ; then
      echo Commmand Choice $input proceeding...
      clear
      testScreen
      continue

   elif [ $input == 'q' ] ; then
      echo Quiting...
      exit

   elif [ $input == 'x' ] 2>/dev/null; then
      echo Exiting...
      exit

   elif [ $input -eq 1 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh

   elif [ $input -eq 2 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh AtoB

   elif [ $input -eq 3 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh BtoA

   elif [ $input -eq 4 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh A1toB4

   elif [ $input -eq 5 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh A2toB3

   elif [ $input -eq 6 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh B4toA1

   elif [ $input -eq 7 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jpermit.sh B3toA2

   elif [ $input -eq 8 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...

   elif [ $input -eq 9 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...

   elif [ $input -eq 10 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...

   elif [ $input -eq 11 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh

   elif [ $input -eq 12 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh AtoB

   elif [ $input -eq 13 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh BtoA

   elif [ $input -eq 14 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh A1toB4

   elif [ $input -eq 15 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh A2toB3

   elif [ $input -eq 16 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh B4toA1

   elif [ $input -eq 17 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...
      $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/jdeny.sh B3toA2

   elif [ $input -eq 18 ] 2>/dev/null; then
      echo Commmand Choice $input proceeding...

   elif [ $input -eq 19 ] 2>/dev/null; then
      echo Commmand Choice $input not implemented, no action taken!

   elif [ $input -eq 20 ] 2>/dev/null; then
      echo Commmand Choice $input not implemented, no action taken!

   else
      echo "Invalid Commmand Input, no action taken!"
      sleep 1
      continue
   fi
   else

      # re-source the config in case it changed while we were sitting at the user menu
      source $TAGA_CONFIG_DIR/config

      echo "No input provided, no action taken!"
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

# Call the first screen (aka previous screen)
previous=previousScreen
$previous

#previousScreen
