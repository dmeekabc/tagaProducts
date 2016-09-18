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

echo; echo $0 : $MYIP :  executing at `date`; echo

# tick
$TAGA_UTILS_DIR/tick.sh &

# 2
# mlf alias
cp /opt/jtmnm/largeFilesDir/largeFile2.txt /opt/jtmnm/largeFilesDir/largeFile9.txt

# emr alias
sudo ip route add 224.0.0.0/4 dev wlan0   2>/dev/null        

cd /opt/jtmnm/scripts; cd yangScripts; ./stageJTX.sh `cat /opt/jtmnm/config/contentPath.txt`


# note, stageJTX.sh creates /tmp/tmp.txt conditionally based on inputs

# 2a

# normkill
sudo kill `ps -ef | grep normFileRecv | grep -v grep | cut -c 10-15`
mv /tmp/tmp.txt `cat /opt/jtmnm/config/contentPath.txt`

# 3
cd /opt/jtmnm/scripts; cd yangScripts; ./loadJTX.sh `cat /opt/jtmnm/config/contentPath.txt`


# 4
cd /opt/jtmnm/scripts; cd yangScripts; ./unstageJTX.sh `cat /opt/jtmnm/config/contentPath.txt`


