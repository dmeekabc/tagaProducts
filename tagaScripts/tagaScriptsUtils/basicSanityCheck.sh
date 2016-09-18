#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################
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

# dlm temp, this whole file is somewhat OBE now, but still called and still in place
# dlm temp, this whole file is somewhat OBE now, but still called and still in place
# dlm temp, this whole file is somewhat OBE now, but still called and still in place
# dlm temp, this whole file is somewhat OBE now, but still called and still in place
# dlm temp, this whole file is somewhat OBE now, but still called and still in place

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo myip: $MYIP

# get MYLOGIN_ID from the config or the loginIdMap file if the file exists
MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`

if echo $MYLOGIN_ID | grep GoesHere >/dev/null ; then

   MYLOGIN_ID=`/usr/bin/whoami`
#   echo MYLOGIN_ID:$MYLOGIN_ID


#   echo
#   echo NOTICE: Config file missing required information.
#   echo
#   echo NOTICE: Please update one of the following three files with the information shown below:
#   echo  " 1. Config File: $TAGA_CONFIG_DIR/config "
#   echo  " 2. Config Overrides File: $TAGA_CONFIG_DIR/config_overrides "
#   echo  " 3. Login Map File: $TAGA_CONFIG_DIR/loginmap.txt "
#   echo
#   echo "     e.g. [ MYLOGIN_ID: $MYLOGIN_ID ] "
#   echo
#   echo Note: MYIP: $MYIP
#   echo Note: MYLOGIN_ID: $MYLOGIN_ID
#   echo
#   exit 255

       #elif echo $MYPASSWD | grep GoesHere >/dev/null ; then
       #   echo
       #   echo WARNING: It appears you have not updated the config file with your configuration information
       #   echo e.g. [ MYPASSWD: $MYPASSWD ]
       #   echo
       #   exit 255

else
   echo Basic Check Passed >/dev/null
fi

exit 0

