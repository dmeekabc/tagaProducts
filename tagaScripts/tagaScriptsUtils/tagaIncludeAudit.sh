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

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : $MYIP :  executing at `date`; echo

#TAGA_INCLUDE_FILE_TEMPLATE=/home/pi/scripts/taga/include/taga.h.template
#TAGA_INCLUDE_FILE=/home/pi/scripts/taga/include/taga.h

let VERBOSE=1
let VERBOSE=0

if [ $VERBOSE -eq 1 ] ; then
   # The Include Directory
   echo tagaIncludeDir:$tagaIncludeDir

   # The List of files to audit
   echo List:$TAGA_INCLUDE_FILE_LIST

fi

if cat $TAGA_INCLUDE_FILE | grep $MYIP >/dev/null; then
   echo Okay >/dev/null
else
   echo Notice: Taga Include Audit Failed, Reconstructing TAGA include file
   $tagaUtilsDir/createTagaInclude.sh
   echo Rebuiilding TAGA Include dependencies
   echo Rebuilding List:$TAGA_INCLUDE_FILE_LIST

   #echo $TAGA_INCLUDE_FILE_DEPENDS_MAP # ="taga.h /home/pi/nanomsg/tests/pipeline.c"
   #echo $TAGA_INCLUDE_FILE_DEPENDS_MAP # ="taga.h /home/pi/nanomsg/tests/pipeline.c"

   # Build Dependent Binaries
   cd /home/pi/nanomsg/build; make

fi

