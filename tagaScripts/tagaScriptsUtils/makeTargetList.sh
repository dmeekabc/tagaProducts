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

echo; echo $0 : $MYIP :  executing at `date`; echo

# provide the info to print into the confirmation request
InfoToPrint="Notice: This command will create and update the IBOA TAGA targetList.sh file."
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# continue to execute the command
echo $0 Proceeding.... at `date`; echo

echo
echo Current IP Address List : "$list"
echo
echo Enter an IP Address in Dotted Decimal Notation : a.b.c.d 
echo "  Or Enter 'd' if done"
echo

list="localhost"

while read address
do
  echo
 # echo 2
  if [ $address == 'd' ]; then
     echo Done entering addressess... creating targetList.sh file
     #exit
     break
  else
     echo
     #if echo $address | grep \*\.\*\.\*\.\* ; then
     if echo $address | grep [0-9]\.[0-9]\.[0-9]\.[0-9]; then
        echo valid IP address : $address
        list="$list $address"
     else
        echo Not a valid IP address : $address
     fi
     echo Current IP Address List : "$list"
     echo
     echo Enter an IP Address : Dotted Decimal Notation : a.b.c.d
     echo Enter an IP Address or \'d\' if done
     echo
  fi
done

echo
echo The new Target List is as follows:
echo
     echo "New List: << $list >>"

# provide the info to print into the confirmation request
InfoToPrint="Notice: If confirmed, the targetList.sh file will be updated to return the new list above:"
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi


