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

# dlm temp DEBUG
#exit

##################################
# IBOA TAGA Standard Includes
##################################
TAGA_DIR=~/scripts/taga
TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

##################################
# IBOA TAGA Standard Defines
##################################
LOG_FILE=/tmp/`basename $0`.log
DAT_FILE=/tmp/`basename $0`.dat

AVER_STD_INPUT_FILE=/tmp/`basename $0`.aver-std-values-input.dat
AVER_STD_OUTPUT_FILE=/tmp/`basename $0`.aver-std.dat 

let DEBUG=1
let DEBUG=0

##################################
# IBOA TAGA Standard Init
##################################

# Standard Entry Print
echo; echo $0 : $MYIP :  executing at `date`; echo

# Standard Input Verification
if [ $# -ne 1 ] ; then
   echo "Warning: $0 expects one parameter (parameter missing)"
   echo continuing without iteration identifier...
   sleep 1
fi

# Get the iteration 
iteration=$1; echo iteration:$iteration

#################################
# Function -  IBOA TAGA Standard Log Output
#################################
function printLogStandard 
{
   /usr/bin/sudo /usr/bin/touch $LOG_FILE
   /usr/bin/sudo /bin/chmod 777 $LOG_FILE
   /usr/bin/sudo /bin/echo >> $LOG_FILE
   /usr/bin/sudo /bin/echo $0:`date`:Iter:$iteration >> $LOG_FILE
   /usr/bin/sudo /bin/echo >> $LOG_FILE
}

#########################################################
# Function -  IBOA TAGA Average and StdDev Stats Handling
#########################################################
function printAvgStdDevStats
{
   # Generate the $AVER_STD_OUTPUT_FILE file
   $tagaUtilsDir/aver-std.sh $AVER_STD_INPUT_FILE $AVER_STD_OUTPUT_FILE

   # Get the content from the $AVER_STD_OUTPUT_FILE file
   #avgStdDevSecsNvp="Avg/Stdev/Min/Max : `tail -n 1 $AVER_STD_OUTPUT_FILE` / $Min / $Max ;"

   let AVG=`tail -n 1 $AVER_STD_OUTPUT_FILE | cut -d\. -f 1`
   let AVERAGE=`tail -n 1 $AVER_STD_OUTPUT_FILE | cut -d\. -f 1`
   let STDEV=`tail -n 1 $AVER_STD_OUTPUT_FILE | cut -d" " -f 2 | cut -d\. -f 1`

   AVERAGE_PRINT_STR=`tail -n 1 $AVER_STD_OUTPUT_FILE | cut -c1-5`
   STDEV_PRINT_STR=`tail -n 1 $AVER_STD_OUTPUT_FILE | cut -c11-14`

   #echo -----------------
   #echo AVERAGE:$AVERAGE
   #echo STDEV:$STDEV
   #echo AVERAGE:$AVERAGE_PRINT_STR
   #echo STDEV:$STDEV_PRINT_STR
   #echo -----------------

   if echo $SRW_LIST_ACTIVE | grep $MYIP > /dev/null ; then
   avgStdDevSecsNvp="  Avg/Stdev/Min/Max : $AVERAGE_PRINT_STR/$STDEV_PRINT_STR/$Min/$Max;"
   echo average:$AVERAGE
   echo stdev:$STDEV
   echo AVERAGE:$AVERAGE
   let tmp=$AVERAGE
   # dlm temp: For some reason, these tmp vars are necessary, cannot read/write same var for some reason
   let tmp2=$tmp-$STDEV
   let tmp3=$tmp+$STDEV
   let tmp4=$tmp2-$STDEV
   let tmp5=$tmp3+$STDEV
   let LOWER_LIMIT=$tmp4 # -$STDEV
   let UPPER_LIMIT=$tmp5 # +$STDEV
   echo lower:$LOWER_LIMIT
   echo upper:$UPPER_LIMIT
   fi

   # Compute Two Standard Deviations Above and Below the Average
   # let LOWER_LIMT=$AVERAGE-$STDEV
   # let UPPER_LIMT=$AVERAGE+$STDEV

   # let LOWER_LIMT=$LOWER_LIMIT-$STDEV
   # let UPPER_LIMT=$UPPER_LIMIT+$STDEV

   # echo lower:$LOWER_LIMIT
   # echo upper:$UPPER_LIMIT

   outOfBoundsNvp=""

   #echo -222--------------
   #   echo $deltaSecs
   #   echo $UPPER_LIMT 
   #   echo $tmp5
   #echo ---222------------

   if echo $SRW_LIST_ACTIVE | grep $MYIP > /dev/null ; then
   #if [ $deltaSecs -gt $UPPER_LIMT ] ; then
   if [ $deltaSecs -gt $tmp5 ] ; then
      echo "WARNING: Delta Seconds Iteration Duration Delta Seconds outside of (larger than) expected bounds"
      echo deltaSecs:$deltaSecs UPPER_LIMIT:$UPPER_LIMIT
      outOfBoundsNvp="WARNING! : deltaSecs:$deltaSecs UPPER_LIMIT:$UPPER_LIMIT ;"
   #elif [ $deltaSecs -lt $LOWER_LIMT ] ; then
   elif [ $deltaSecs -lt $tmp4 ] ; then
      echo "WARNING: Delta Seconds Iteration Duration Delta Seconds outside of (smaller than) expected bounds"
      echo deltaSecs:$deltaSecs LOWER_LIMIT:$LOWER_LIMIT
      outOfBoundsNvp="WARNING! : deltaSecs:$deltaSecs LOWER_LIMIT:$LOWER_LIMIT ;"
   fi
   fi

   #echo AVG:$AVG STDEV:$STDEV

}


######################################################
# MAIN for TREND
######################################################


DATE_FILE_BASE="/tmp/date.dat"
DELTA_SECS_FILE_BASE="/tmp/deltaSecs"
DELTA_SECS_FILE_BASE="/tmp/deltaSeconds"


CRITERIA_FILE=/tmp/trendCriteriaFile.dat.1 
touch $CRITERIA_FILE

MIN_FILE="/tmp/`basename $0`.min.dat"
MAX_FILE="/tmp/`basename $0`.max.dat"


if [ $iteration -eq 1 ]; then

   echo 0 > $MIN_FILE
   echo 0 > $MAX_FILE

   echo 0 > $DATE_FILE_BASE.1
   echo 0 > $DATE_FILE_BASE.2

   date +%s > $DATE_FILE_BASE.1
   cp $DATE_FILE_BASE.1 $DATE_FILE_BASE.2

   echo 0 > $DELTA_SECS_FILE_BASE.10; echo 0 > $DELTA_SECS_FILE_BASE.9; echo 0 > $DELTA_SECS_FILE_BASE.8; echo 0 > $DELTA_SECS_FILE_BASE.7 
   echo 0 > $DELTA_SECS_FILE_BASE.6; echo 0 > $DELTA_SECS_FILE_BASE.5; echo 0 > $DELTA_SECS_FILE_BASE.4; echo 0 > $DELTA_SECS_FILE_BASE.3 
   echo 0 > $DELTA_SECS_FILE_BASE.2; echo 0 > $DELTA_SECS_FILE_BASE.1 
fi


if [ -f $CRITERIA_FILE ] ; then

   let deltaSecs=`cat $DATE_FILE_BASE.1`-`cat $DATE_FILE_BASE.2`
   if [ $DEBUG -eq 1 ] ; then
   echo DATE_FILE_BASE.1:$DATE_FILE_BASE.1
   echo DATE_FILE_BASE.2:$DATE_FILE_BASE.2
   let deltaSecs=`cat $DATE_FILE_BASE.1`-`cat $DATE_FILE_BASE.2`

   echo deltaSecs: $deltaSecs 
   fi


   mv $DATE_FILE_BASE.1 $DATE_FILE_BASE.2

   #echo $deltaSecs >> $DATE_FILE_BASE.1 
   date +%s > $DATE_FILE_BASE.1


   if [ $DEBUG -eq 1 ] ; then
      echo MIN_FILE:$MIN_FILE: content:`cat $MIN_FILE`
      echo MAX_FILE:$MAX_FILE: content:`cat $MAX_FILE`
   fi

   let Min=`cat $MIN_FILE`
   let Max=`cat $MAX_FILE`

   if [ $deltaSecs -gt $Max ] ; then
      Max=$deltaSecs
      echo $Max > $MAX_FILE
   fi
   if [ $deltaSecs -lt $Min ] ; then
      Min=$deltaSecs
      echo $Min > $MIN_FILE
   fi

   echo $deltaSecs >> $AVER_STD_INPUT_FILE

fi

##############################
# Do the Stats Work
##############################
printAvgStdDevStats

sudo chmod 777 /tmp/deltaS*

mv $DELTA_SECS_FILE_BASE.9 $DELTA_SECS_FILE_BASE.10 2>/dev/null
mv $DELTA_SECS_FILE_BASE.8 $DELTA_SECS_FILE_BASE.9 2>/dev/null
mv $DELTA_SECS_FILE_BASE.7 $DELTA_SECS_FILE_BASE.8 2>/dev/null
mv $DELTA_SECS_FILE_BASE.6 $DELTA_SECS_FILE_BASE.7 2>/dev/null
mv $DELTA_SECS_FILE_BASE.5 $DELTA_SECS_FILE_BASE.6 2>/dev/null
mv $DELTA_SECS_FILE_BASE.4 $DELTA_SECS_FILE_BASE.5 2>/dev/null
mv $DELTA_SECS_FILE_BASE.3 $DELTA_SECS_FILE_BASE.4 2>/dev/null
mv $DELTA_SECS_FILE_BASE.2 $DELTA_SECS_FILE_BASE.3 2>/dev/null
mv $DELTA_SECS_FILE_BASE.1 $DELTA_SECS_FILE_BASE.2 2>/dev/null
echo $deltaSecs > $DELTA_SECS_FILE_BASE.1

deltaSecsTrendNvp="  Trend: `cat $DELTA_SECS_FILE_BASE.1` `cat $DELTA_SECS_FILE_BASE.2` `cat $DELTA_SECS_FILE_BASE.3` `cat $DELTA_SECS_FILE_BASE.4` `cat $DELTA_SECS_FILE_BASE.5` `cat $DELTA_SECS_FILE_BASE.6` `cat $DELTA_SECS_FILE_BASE.7` `cat $DELTA_SECS_FILE_BASE.8` `cat $DELTA_SECS_FILE_BASE.9` `cat $DELTA_SECS_FILE_BASE.10`;"

#echo $deltaSecsTrendNvp
echo $deltaSecsTrendNvp | tee $DAT_FILE
