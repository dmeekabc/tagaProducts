#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2017
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

echo; echo $0 : $MYIP :  executing at `date`; echo

PERL_COMMAND="perl jedit.pl -t -l tagaxxx -p tagaxxx1234 config.txt 192.168.1.1"

function confirmPrompt {
   # provide the info to print into the confirmation request
   InfoToPrint="If confirmed, all selected/configured packets will be permitted through Juniper XXX YYY"
   # issue confirmation prompt and check reponse
   $tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
   response=$?; if [ $response -ne 1 ]; then exit; fi
   # continue to execute the command
   echo $0 Proceeding.... at `date`; echo
}

# Prepare to Permit All

# Change to the working directory
cd ~/juniper/netconf-perl-master/examples; cd edit_configuration

if [ $# -eq 0 ] ;  then
   # Do the A to B Part
   cp config.txt.AtoB_PermitAll config.txt; confirmPrompt; $PERL_COMMAND
   # Do the B to A Part
   cp config.txt.BtoA_PermitAll config.txt; $PERL_COMMAND 
elif [ $1 == "AtoB" ] ;  then
   # Do the A to B Part Only
   cp config.txt.AtoB_PermitAll config.txt; confirmPrompt; $PERL_COMMAND 
elif [ $1 == "A1toB4" ] ;  then
   # Do the A1 to B4 Part Only
   cp config.txt.AtoB_PermitSelected_PC1_to_PC4 config.txt; confirmPrompt; $PERL_COMMAND 
elif [ $1 == "A2toB3" ] ;  then
   # Do the A2 to B3 Part Only
   cp config.txt.AtoB_PermitSelected_PC2_to_PC3 config.txt; confirmPrompt; $PERL_COMMAND 
elif [ $1 == "BtoA" ] ;  then
   # Do the B to A Part Only
   cp config.txt.BtoA_PermitAll config.txt; confirmPrompt; $PERL_COMMAND 
elif [ $1 == "B4toA1" ] ;  then
   # Do the A4 to B1 Part Only
   cp config.txt.BtoA_PermitSelected_PC4_to_PC1 config.txt; confirmPrompt; $PERL_COMMAND 
elif [ $1 == "B3toA2" ] ;  then
   # Do the B3 to A2 Part Only
   cp config.txt.BtoA_PermitSelected_PC3_to_PC2 config.txt; confirmPrompt; $PERL_COMMAND 

else
   echo Error: Invalid Input
   echo
   echo "Usage $0 [ AtoB | BtoA | A1toB4 | A2toB3 | B4toA1 | B3toA2 ]"
   echo
   exit
fi

# Commit the Changes
#cd ~/juniper/commitText; ssh tagaxxx@192.168.1.1 -p 22 -s netconf < commit.txt
