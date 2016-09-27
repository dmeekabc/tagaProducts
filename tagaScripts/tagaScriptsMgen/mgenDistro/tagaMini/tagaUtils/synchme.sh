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
# Set the TAGA DIR BASE
if [ -d ~/scripts/tagaXXXXXXXXXX ]; then
  TAGA_DIR=~/scripts/taga # new mar 2016, relocateable
elif [ -d ~/tagaMini ]; then
  TAGA_DIR=~/tagaMini     # new sept 2016, tagaMini version
else
  TAGA_DIR=/tmp/tagaMini  # new sept 2016, tagaMini version
fi

# Set and Source the TAGA CONFIG Dir
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let DEBUG=1
let DEBUG=0


# get the input
PARAM1=$1
PARAM2=$2

# print the params if in debug mode
if [ $DEBUG -eq 1 ]; then
   echo ArgCount:$#
   echo PARAM1:$PARAM1
   echo PARAM2:$PARAM2
   sleep 2
fi

# print the help info if help requested
if [ $# -ge 1 ] ; then

# we suppress stderr due to extraneous wild-card (*) related warnings which may cause undue alarm 
# this is with tradeoff of potentially hiding other errors which we will no longer see...
if [ $1 == -h ] 2>/dev/null || [ $1 == -help ] 2>/dev/null || [ $1 == --help ] 2>/dev/null ; then
   echo
   echo Usage: $0 -h \(this help text\)
   echo Usage: $0 -help \(this help text\)
   echo Usage: $0 --help \(this help text\)
   echo Usage: $0 [[optionalFileList] [optionalTargetList]]
   echo
   echo 'Example: $0 ".bashrc.iboa .bashrc.iboa.user.1000" "192.168.43.124 192.168.43.208"'
   echo
   echo Notice: A Param 2 optionalTargetList requires a Param 1 optionalFileList
   echo Notice: If no Param is provided, the SCP LIST embedded in this script will be used to all targets.
   echo
   exit
fi
fi

# get my login id for this machine and create the path name based on variable user ids
MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYDIR=`pwd`
MYDIR=`echo $MYDIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`

# provide the info to print into the confirmation request
InfoToPrint=" $MYDIR $PARAM1 will be synchronized. "

# dlm temp, move me to the config
# dlm temp, move me to the config
AUTO_CONFIRM_RESPONSE=1 # yes (enable  auto synch to other targets)
AUTO_CONFIRM_RESPONSE=0 # no  (disable auto synch to other targets)
AUTO_CONFIRM_RESPONSE=2 # neither, let the user decide and respond to the confirmation prompt

# issue confirmation prompt and check reponse
if [ $AUTO_CONFIRM_RESPONSE -eq 0 ]; then
   # respond NO to confirmation prompt to user
   $tagaUtilsDir/confirm.sh $0 "$InfoToPrint" < /tmp/tagaMini/iboaUtils/confirmNo.txt
elif [ $AUTO_CONFIRM_RESPONSE -eq 1 ]; then
   # respond YES to confirmation prompt to user
   $tagaUtilsDir/confirm.sh $0 "$InfoToPrint" < /tmp/tagaMini/iboaUtils/confirm.txt
else
   # issue confirmation prompt to user
   $tagaUtilsDir/confirm.sh $0 "$InfoToPrint" 
fi
response=$?; if [ $response -ne 1 ]; then exit; fi

# Define SCP_SOURCE_STR here *** IF IT IS NOT PROVIDED as Param 1 Input ***
if [ $# -eq 0 ]; then
   # define the source string right here
   # note, this applies if this script called with no params!!
   # note: Taga convention is to include multiple assignments for ease of editing, bottom one wins
   SCP_SOURCE_STR="."          # use this to synch everything here and below
   SCP_SOURCE_STR="synchme.sh" # use this to synch this file only
   SCP_SOURCE_STR="$0" # use this to synch this file only
else
   # use the input parameter if provided
   SCP_SOURCE_STR=$1
fi

# Support Alternate Target List as 2nd input param
if [ $# -ge 2 ]; then
  targetList=$2
fi
echo; echo targetList : $targetList

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # strip trailing blanks
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   MYDIR=`pwd`
   MYDIR=`echo $MYDIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   MYDIR=`echo $MYDIR | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   if [ $target == $MYIP ]; then
     echo
     echo skipping self \($target\) ...
     echo
     continue
   else
     echo
     echo processing, synchronizing $target

     # make the directory on remote (target) if it does not exist
     ssh -l $MYLOGIN_ID $target mkdir -p $MYDIR

     # send the files to the destination
     scp -r $SCP_SOURCE_STR $MYLOGIN_ID@$target:$MYDIR # <$SCRIPTS_DIR/taga/passwd.txt

   fi
done

