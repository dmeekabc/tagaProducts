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
TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

########################
# Sensitive Info Section (Sanitize before distributing)
########################
COMMAND=xxxxxx
COMMAND=make_sil_dir_pro

############################################################
# Primary Module Directory and Template File Configuration
# Note: Ensure these are properly set for your system
############################################################
TEMPLATE_TOKEN=jtmnm  # token to use as clone source
TEMPLATE_TOKEN=taga   # token to use as clone source
TEMPLATE_TOKEN=tlm   # token to use as clone source
MODULE_DIR=/usr/share/yumapro/modules/netconfcentral
SOURCE_DIR=~/yangModules
SOURCE_DIR=~/

echo; echo $0 : $MYIP :  executing at `date` ; echo

# get the parameter input if provided
if [ $# -ge 1 ]; then

   TEMPLATE_TOKEN=$1

   # Strip off .yang extension if it was included in the input parameter
   if echo $TEMPLATE_TOKEN | grep "\.yang" >/dev/null; then
      TEMPLATE_TOKEN_TMP=`echo $TEMPLATE_TOKEN | sed -e s/\.yang//g`
      TEMPLATE_TOKEN=$TEMPLATE_TOKEN_TMP
      echo Input: $1 : Assuming TEMPLATE_TOKEN:$TEMPLATE_TOKEN; echo
   fi
fi

# provide the info to print into the confirmation request
InfoToPrint="$MODULE_DIR/$1.yang will be used to generate or regenerate source code at the following location: $HOME/$TEMPLATE_TOKEN. Files at this location will be deleted if they exist. The $TEMPLATE_TOKEN module will be built and installed. Please RENAME FILES IF NECESSARY to avoid permanent deletion."

# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo


#############################3
# DO IT
#############################3

# change to home
cd

# Remote the Old Token-based Directory
rm -rf $TEMPLATE_TOKEN

# Auto-generate source from token module
$COMMAND $TEMPLATE_TOKEN

# Change to the newly generated source
cd $TEMPLATE_TOKEN/src

# Make it and Install it (e.g. Build on Steroids)
sudo make clean
sudo make
sudo make install


echo
pwd
echo

