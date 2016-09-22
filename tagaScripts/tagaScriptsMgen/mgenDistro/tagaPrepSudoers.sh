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
TAGA_FULL_INSTALL=1 # use this with FULL TAGA INSTALL
TAGA_FULL_INSTALL=0 # use this with PARTIAL TAGA INSTALL


SUDOERS_FILE=/etc/sudoers
SUDOERS_FILE=/tmp/sudoers.txt


if [ $TAGA_FULL_INSTALL -eq 1 ]; then
   TAGA_DIR=~/scripts/taga
else
   TAGA_DIR=/tmp/tagaMini
fi
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

if [ $# -ge 1 ] ; then
if [ $1 == -h ] || [ $1 == --help ] || [ $1 == -help ]; then
   echo Usage: $0 [[optionalFileList] [optionalTargetList]]
   echo 'Example: $0 ".bashrc.iboa .bashrc.iboa.user.1000" "192.168.43.124 192.168.43.208"'
   echo
   echo Notice: A Param 2 optionalTargetList requires a Param 1 optionalFileList
   echo
   echo Notice: If no Params are provided, the SCP_SOURCE_STR List embedded in this script will be used to all targets.
   echo
   exit
fi
fi

# get my login id for this machine and create the path name based on variable user ids
MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYDIR=`pwd`
MYDIR=`echo $MYDIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`

# provide the info to print into the confirmation request
InfoToPrint=" $MYDIR will be installed and/or synchronized. "
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi


#if sudo cat /etc/sudoers.txt | grep iboaInstall ; then

if sudo cat $SUDOERS_FILE | grep iboaInstall ; then
  echo iboaInstall already updated sudoers - exiting with no action
  # exit now
  exit
else

  echo iboaInstall updating sudoers file ...


  echo " " >> $SUDOERS_FILE 
  echo " " >> $SUDOERS_FILE 
  echo "# iboaInstall auto update of sudoers file" >> $SUDOERS_FILE 
  echo " " >> $SUDOERS_FILE 
  echo " " >> $SUDOERS_FILE 
  echo "# iboaInstall auto update of sudoers file" >> $SUDOERS_FILE 

  commandList="/usr/sbin/tcpdump /usr/sbin/ifconfig /usr/bin/vi /usr/bin/ssh /usr/bin/scp /bin/kill /usr/bin/wireshark /sbin/reboot /bin/cat /usr/bin/apt-get"
  commandList="/usr/bin/apt-get"

  for command in $commandList
  do
     echo $MYLOGIN_ID $MYIP = \(root\) NOPASSWD: $command >> $SUDOERS_FILE 
  done

fi

