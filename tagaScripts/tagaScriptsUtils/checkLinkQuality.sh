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

# Set Threshold Constats/Values

let MINOR_THRESHOLD=60
let MAJOR_THRESHOLD=50
let ALARM_THRESHOLD=40

let MINOR_THRESHOLD=60
let MAJOR_THRESHOLD=50
let ALARM_THRESHOLD=40


#################################################
# Get the Value of Interest
#################################################

# Get the link quality
linkQualityString=`iwconfig 2>/dev/null | grep Quality | cut -d= -f2 | cut -c1-2`

let linkQuality=$linkQualityString

#let i=0
#let linkQuality=0
#let stringLength=`echo $linkQualityString | wc -c`
#
## find the % character within the linkQualityString and
## use the preceding two characters as our linkQuality value.
#while [ $i -lt $stringLength ]
#do
#   let i=$i+1
#   charToExamine=`echo $linkQualityString | cut -c$i `
#   #echo charToExamine:$charToExamine
#   if [ $charToExamine == '%' ] 2>/dev/null; then
#      #echo found:$i
#      let startindex=$i-2
#      let stopindex=$i-1
#      let linkQuality=`echo $linkQualityString | cut -c$startindex-$stopindex`
#      #echo linkQuality:$linkQuality
#      break
#   fi
#done
#
#

#################################################
# DO IT, Check for Warning and Alarm Conditions
#################################################

# dlm temp, this whole note and check are probably not meaningful in this file, but we leave it anyway
# dlm temp, this whole note and check are probably not meaningful in this file, but we leave it anyway
# dlm temp, this whole note and check are probably not meaningful in this file, but we leave it anyway

# oddly enough, here, a linkQuality == 0 actually indicates 100% usage
if [ $linkQuality -eq 0 ]; then
   echo
   echo "'****** ******' ALARM!!: Link Quality (100%) is below ALARM_THRESHOLD ($ALARM_THRESHOLD%) '****** ******'"
   echo "'****** ******' ALARM!!: Link Quality (100%) is below ALARM_THRESHOLD ($ALARM_THRESHOLD%) '****** ******'"
   echo "'****** ******' ALARM!!: Link Quality (100%) is below ALARM_THRESHOLD ($ALARM_THRESHOLD%) '****** ******'"
   exit 1
elif [ $linkQuality -le $ALARM_THRESHOLD ]; then
   echo
   echo "'****** ******' ALARM!!: Link Quality ($linkQuality%) is below ALARM_THRESHOLD ($ALARM_THRESHOLD%) '****** ******'"
   echo "'****** ******' ALARM!!: Link Quality ($linkQuality%) is below ALARM_THRESHOLD ($ALARM_THRESHOLD%) '****** ******'"
   echo "'****** ******' ALARM!!: Link Quality ($linkQuality%) is below ALARM_THRESHOLD ($ALARM_THRESHOLD%) '****** ******'"
   exit 1
elif [ $linkQuality -le $MAJOR_THRESHOLD ]; then
   echo
   echo "'****** ******' WARNING: Link Quality ($linkQuality%) is below MAJOR_THRESHOLD ($MAJOR_THRESHOLD%) '****** ******'"
   echo "'****** ******' WARNING: Link Quality ($linkQuality%) is below MAJOR_THRESHOLD ($MAJOR_THRESHOLD%) '****** ******'"
   exit 1
elif [ $linkQuality -le $MINOR_THRESHOLD ]; then
   echo
   echo "'****** ******' WARNING: Link Quality ($linkQuality%) is below MINOR_THRESHOLD ($MINOR_THRESHOLD%) '****** ******'"
   exit 1
else
   echo
   echo INFO: Link Quality \($linkQuality%\) is below MINOR_THRESHOLD \($MINOR_THRESHOLD%\) \(Normal\)
   exit 0
fi
