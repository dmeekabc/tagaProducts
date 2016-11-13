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

CONVERT_FROM_SOURCE=tlm

echo; echo $0 : $MYIP :  executing at `date`; echo

if [ $# -eq 1 ] ; then
   MODULE_TO_CONVERT=$1
   DIRECTORY_TO_CONVERT=$HOME/$MODULE_TO_CONVERT/src
else
   echo Error: Single param \(module to convert\) is required, exiting...
   exit
fi

# provide the info to print into the confirmation request
InfoToPrint="$DIRECTORY_TO_CONVERT will be regenerated from $HOME/$CONVERT_FROM_SOURCE/src"

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

#### Remote the old module directory if it existed
######cd; rm -rf $MODULE_TO_CONVERT

cd $DIRECTORY_TO_CONVERT

cat ~/$CONVERT_FROM_SOURCE/src/$CONVERT_FROM_SOURCE.c | sed -e s/$CONVERT_FROM_SOURCE/$MODULE_TO_CONVERT/g       \
  > $MODULE_TO_CONVERT.c

cat ~/$CONVERT_FROM_SOURCE/src/$CONVERT_FROM_SOURCE.h | sed -e s/$CONVERT_FROM_SOURCE/$MODULE_TO_CONVERT/g       \
  > $MODULE_TO_CONVERT.h

cat ~/$CONVERT_FROM_SOURCE/src/$CONVERT_FROM_SOURCE.c.start | sed -e s/$CONVERT_FROM_SOURCE/$MODULE_TO_CONVERT/g \
  > $MODULE_TO_CONVERT.c.start

cat ~/$CONVERT_FROM_SOURCE/src/$CONVERT_FROM_SOURCE.h.start | sed -e s/$CONVERT_FROM_SOURCE/$MODULE_TO_CONVERT/g \
  > $MODULE_TO_CONVERT.h.start


sudo make clean
sudo make 
sudo make install

