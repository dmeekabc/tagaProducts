#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#######################
# params example
# $1="Device1"
# $2="/tmp/device1.data"
# $3="/tmp/device1.out"
#######################

  # pad target name as necessary to have nice output
  IP_LEN=`echo $MYIP | awk '{print length($0)}'`

  if [ $IP_LEN -eq 17 ] ; then
    myip=$MYIP\ 
  elif [ $IP_LEN -eq 16 ] ; then
    myip=$MYIP\. 
  elif [ $IP_LEN -eq 15 ] ; then
    myip=$MYIP\.. 
  elif [ $IP_LEN -eq 14 ] ; then
    myip=$MYIP\... 
  elif [ $IP_LEN -eq 13 ] ; then
    myip=$MYIP\.... 
  elif [ $IP_LEN -eq 12 ] ; then
    myip=$MYIP\..... 
  elif [ $IP_LEN -eq 11 ] ; then
    myip=$MYIP\..... 
  elif [ $IP_LEN -eq 10 ] ; then
    myip=$MYIP\...... 
  else
    myip=$MYIP\....... 
  fi


if [ $1 == "Device1" ] ; then
  PAD=".."
elif [ $1 == "Device2" ] ; then
  PAD="....."
elif [ $1 == "Device3" ] ; then
  PAD=".........."
elif [ $1 == "Device4" ] ; then
  PAD=".............."
elif [ $1 == "Device5" ] ; then
  PAD=".................."
fi 


while true
do
   # output to terminal if enabled
   if [ $MAX_OUTPUT_ENABLED -eq 1 ]; then
      echo `date -Iseconds | cut -c1-19` $myip : $1:KnobSetting:$PAD: `cat $2 2>/dev/null` 
   fi
   # output to log file
   echo `date -Iseconds | cut -c1-19` $myip : $1:KnobSetting:$PAD: `cat $2 2>/dev/null` >> $3
   sleep 1
done
