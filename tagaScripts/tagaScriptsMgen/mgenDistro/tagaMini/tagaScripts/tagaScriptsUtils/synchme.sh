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
TAGA_DIR=/tmp/tagaMini
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

if [ $# -ge 1 ] ; then
if [ $1 == -h ] || [ $1 == --help ] || [ $1 == -help ]; then
   echo Usage: $0 [[optionalFileList] [optionalTargetList]]
   echo 'Example: $0 ".bashrc.iboa .bashrc.iboa.user.1000" "192.168.43.124 192.168.43.208"'
   echo
   echo Notice: A Param 2 optionalTargetList requires a Param 1 optionalFileList
   echo
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
InfoToPrint=" $MYDIR will be synchronized. "
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# Define SCP_SOURCE_STR here *** IF IT IS NOT PROVIDED as Param 1 Input ***
if [ $# -eq 0 ]; then
   # define the source string right here
   # note, this applies if this script called with no params!!
   # note, bottom assignment ONLY wins (iboa/taga scripting convention)
   # note, bottom assignment ONLY wins (iboa/taga scripting convention)
   SCP_SOURCE_STR="synchme.sh" # use this to synch this file only
   SCP_SOURCE_STR="$0" # use this to synch this file only
   SCP_SOURCE_STR="."          # use this to synch everything here and below
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

