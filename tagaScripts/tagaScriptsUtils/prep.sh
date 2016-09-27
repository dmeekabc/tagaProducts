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

# Single Machine Commands

MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYLOCALLOGIN_ID=`echo $MYLOCALLOGIN_ID`

# Taga:TODO: Add logic to check if this has been done

# Call this script with a 'flag' parameter  to generate a key
# DO THIS ONE TIME ONLY ON SOURCE MACHINE AND ONLY IF NEEDED
# any param is a flag indicating to generate a key before copying the id
if [ $# -gt 0 ] ; then
   ssh-keygen
fi

######################################
######################################
######################################

# DO THIS FOR EACH DEST MACHINE

echo $targetList

for target in $targetList
do

   TAGA_DIR=~/scripts/taga
   TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
   source $TAGA_CONFIG_DIR/config

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 
   
   TAGA_DIR=`echo $TAGA_DIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   TAGA_DIR=`echo $TAGA_DIR | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

  ssh-copy-id $MYLOGIN_ID@$target

  #let PREP_TCPDUMP_ENABLED=0
  let PREP_TCPDUMP_ENABLED=1
  
  # prep tcpdump (TBD if this is needed)
  if [ $PREP_TCPDUMP_ENABLED -eq 1 ]; then
    ssh -l $MYLOGIN_ID $target $TAGA_DIR/tagaScripts/tagaScriptsUtils/prepTcpdump.sh
  fi

done

