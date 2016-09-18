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

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

NEW_LOCATION=/tmp/iboa
NEW_LOCATION_REPLACE_STRING="\\/tmp\\/iboa"
NEW_LOCATION=/opt/iboa
NEW_LOCATION_REPLACE_STRING="\\/opt\\/iboa"

echo
echo Notice: If confirmed, the TAGA dir will be relocated to: $NEW_LOCATION

# issue confirmation prompt
$iboaUtilsDir/confirm.sh
# check the response
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $0 continuing....; echo
else
  echo; echo Not Confirmed, $0 exiting with no action...; echo
  exit
fi

sudo mkdir -p $NEW_LOCATION
sudo chmod 777 $NEW_LOCATION

for file in config
do
  echo $file
  sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $NEW_LOCATION/$file
done

for file in *.sh #config
do
  echo $file
  sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $NEW_LOCATION/$file
done

for file in $NEW_LOCATION/*.sh
do
   echo $file
   sudo chmod 755 $file
   diff $file `basename $file`
done

# copy the additional files
others="*.template passwd.txt code"
sudo cp -r $others $NEW_LOCATION

echo; echo New TAGA Location: $NEW_LOCATION; echo

