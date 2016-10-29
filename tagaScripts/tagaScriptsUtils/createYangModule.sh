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
TEMPLATE_TOKEN=taga
MODULE_DIR=/usr/share/yumapro/modules/$TEMPLATE_TOKEN
TEMPLATE_FILE=$MODULE_DIR/$TEMPLATE_TOKEN.yang
SOURCE_DIR=~/yangModules

echo; echo $0 : $MYIP :  executing at `date`; echo

if [ -f $MODULE_DIR/$1.yang ] ; then
  echo
  echo $MODULE_DIIR/$1.yang already exists! ... exiting with no action!
  echo
  exit
fi

# provide the info to print into the confirmation request
InfoToPrint="$MODULE_DIR/$1.yang will be created, source files generated, and objects built."

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

# get the parameter input
NEWYANGMODULETOKEN=$1
newyangmodule=$NEWYANGMODULETOKEN

cd $MODULE_DIR
cp $TEMPLATE_FILE $newyangmodule.yang
cat $newyangmodule.yang | sed -e s/$TEMPLATE_TOKEN/$newyangmodule/g > /tmp/$newyangmodule.yang
cp /tmp/$newyangmodule.yang .

mkdir -p $SOURCE_DIR 2>/dev/null
cd $SOURCE_DIR

make_sil_dir_pro $newyangmodule
ret=$?
if [ $ret -eq 0 ] ; then
   echo make_sil_dir_pro return:$ret >/dev/null
   echo Yang Module Source Directory SUCCESSFULLY CREATED - building $1 ...
else
   echo
   echo make_sil_dir_pro return:$ret >/dev/null
   echo Hint - Check for pre-existence of ~/yangModules/$1 directory ...
   echo ERROR - Yang Module Source Directory NOT SUCCESSFULLY CREATED - exiting
   echo
   exit
fi

cd $newyangmodule/src
sudo make
sudo make install

ls -lrt `pwd`
echo
echo New Yang Module is found at: $MODULE_DIR/$1.yang
echo New Yang Source Files are in: `pwd`
echo

