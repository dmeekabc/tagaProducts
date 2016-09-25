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

FILE=tagaMgenDistro.tgz

if [ -f  $FILE ] ; then
   echo $FILE Found!
   cp $FILE /tmp
   cd /tmp
   tar zxvf $FILE
   cd mgenDistro
   cp -r tagaMini /tmp
   pwd
   echo Running ./iboaMiniInstall.sh
   ./iboaMiniInstall.sh
   echo
   echo Running ./mcastMiniInstall.sh
   ./mcastMiniInstall.sh
   echo
   echo Running ./tagaUtilsMiniInstall.sh
   ./tagaUtilsMiniInstall.sh
   echo
   echo IBOA/TAGA Scipts and Aliases are available in /tmp/mgenDistro as follows:
   echo -------------------------------------------------------------------------

   sleep 2
   ls
   sleep 2
 
   echo
   echo IBOA/TAGA Scipts and Aliases are at the following:
   echo -------------------------------------------------------------------------
   pwd
   sleep 2
   echo

   echo Now Executing MCAST TEST \(LISTEN and SEND\) Commands
   echo -------------------------------------------------------------------------
   cd ~/tagaMini/mcastUtils
   echo "./mcastSend.sh \& ./mcastListen.sh"
   sleep 2
   ./mcastSend.sh & ./mcastListen.sh



else
   echo $FILE Not Found!
fi

