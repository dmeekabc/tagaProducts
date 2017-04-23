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

# List of possible current TAGA dirs, these may be the same but do not need to be the same
CURRENT_TAGA_DIR1=~/scripts/taga
CURRENT_TAGA_DIR2=/home/pi/scripts/taga

#echo CURRENT_TAGA_DIR1:$CURRENT_TAGA_DIR1
#echo CURRENT_TAGA_DIR2:$CURRENT_TAGA_DIR2

NEW_LOCATION=/var/home/tagaxxx
NEW_LOCATION_REPLACE_STRING="\\/var\\/home\\/tagaxxx"

NEW_OWNER=pi
NEW_GROUP=pi

############################################
# Issue Confirm Prompt
############################################
echo
echo Notice: If confirmed, the TAGA dir will be relocated to: $NEW_LOCATION
echo Notice: The $NEW_LOCATION will be overwritten if it previously exists.

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
############################################
# Issue Confirm Prompt
############################################

# Ensure we start fresh
sudo rm -rf     $NEW_LOCATION
sudo mkdir -p   $NEW_LOCATION
sudo chmod 777  $NEW_LOCATION

# Get the whole ball of wax
cd $CURRENT_TAGA_DIR1
sudo cp -r -f . $NEW_LOCATION

cd $CURRENT_TAGA_DIR2
sudo cp -r -f . $NEW_LOCATION

#cd $CURRENT_TAGA_DIR1

cd $NEW_LOCATION
for file in `find .`
do
   if [ -d $file ] ; then
      sudo chmod 777 $file
   fi
done

###########################################
# *.sh
###########################################
for file in `find . | grep \.sh`
do
   #ls $file
   sudo chmod 777 $file 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.1 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.2 2>/dev/null
   #pwd
   # Replace String 1
   echo "sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1"
   sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1
   # Replace String 2
   echo "sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2"
   sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2
   sudo chown $NEW_OWNER  $file
   sudo chgrp $NEW_GROUP  $file
   sudo chmod 755 $file

   cp $file.tagaRelocate.tmp.2 $file
#   sudo chmod 755 $file
   let CLEANUP=0
   let CLEANUP=1
   if [ $CLEANUP -eq 1 ] ; then
      rm $file.tagaRelocate.tmp.1 
      rm $file.tagaRelocate.tmp.2 
   fi
done

###########################################
# *.py
###########################################
for file in `find . | grep \.py`
do
   #ls $file
   sudo chmod 777 $file
   sudo chmod 777 $file.tagaRelocate.tmp.1
   sudo chmod 777 $file.tagaRelocate.tmp.2
   #pwd
   # Replace String 1
   echo "sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1"
   sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1
   # Replace String 2
   echo "sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2"
   sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2
   sudo chown $NEW_OWNER  $file
   sudo chgrp $NEW_GROUP  $file
   sudo chmod 755 $file
   cp $file.tagaRelocate.tmp.2 $file
#   sudo chmod 755 $file
   let CLEANUP=0
   let CLEANUP=1
   if [ $CLEANUP -eq 1 ] ; then
      rm $file.tagaRelocate.tmp.1 
      rm $file.tagaRelocate.tmp.2 
   fi
done

###########################################
# *.txt
###########################################
for file in `find . | grep \.txt`
do
   #ls $file
   sudo chmod 777 $file 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.1 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.2 2>/dev/null
   #pwd
   # Replace String 1
   echo "sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1"
   sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1
   # Replace String 2
   echo "sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2"
   sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2
   sudo chown $NEW_OWNER  $file
   sudo chgrp $NEW_GROUP  $file
   sudo chmod 755 $file
   cp $file.tagaRelocate.tmp.2 $file
#   sudo chmod 755 $file
   let CLEANUP=0
   let CLEANUP=1
   if [ $CLEANUP -eq 1 ] ; then
      rm $file.tagaRelocate.tmp.1 
      rm $file.tagaRelocate.tmp.2 
   fi
done

###########################################
# *.cpp
###########################################
for file in `find . | grep \.cpp`
do
   #ls $file
   sudo chmod 777 $file 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.1 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.2 2>/dev/null
   #pwd
   # Replace String 1
   echo "sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1"
   sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1
   # Replace String 2
   echo "sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2"
   sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2
   sudo chown $NEW_OWNER  $file
   sudo chgrp $NEW_GROUP  $file
   sudo chmod 755 $file
   cp $file.tagaRelocate.tmp.2 $file
#   sudo chmod 755 $file
   let CLEANUP=0
   let CLEANUP=1
   if [ $CLEANUP -eq 1 ] ; then
      rm $file.tagaRelocate.tmp.1 
      rm $file.tagaRelocate.tmp.2 
   fi
done

###########################################
# *config*
###########################################
for file in `find . | grep tagaConfig/config`
do
   #ls $file
   sudo chmod 777 $file 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.1 2>/dev/null
   sudo chmod 777 $file.tagaRelocate.tmp.2 2>/dev/null
   #pwd
   # Replace String 1
   echo "sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1"
   sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.1
   # Replace String 2
   echo "sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2"
   sudo cat $file.tagaRelocate.tmp.1 | sed s/\\/home\\/pi\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $file.tagaRelocate.tmp.2
   sudo chown $NEW_OWNER  $file
   sudo chgrp $NEW_GROUP  $file
   sudo chmod 755 $file
   cp $file.tagaRelocate.tmp.2 $file
#   sudo chmod 755 $file
   let CLEANUP=0
   let CLEANUP=1
   if [ $CLEANUP -eq 1 ] ; then
      rm $file.tagaRelocate.tmp.1 
      rm $file.tagaRelocate.tmp.2 
   fi
done


###########################################
# Wrapup
###########################################

cd $NEW_LOCATION
for file in `find .`
do
   if [ -d $file ] ; then
      sudo chown $NEW_OWNER  $file
      sudo chgrp $NEW_GROUP  $file
      sudo chmod 755 $file
   fi
done

echo; echo New TAGA Location: $NEW_LOCATION; echo

