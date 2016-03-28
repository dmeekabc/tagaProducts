#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# the tcpdump fails to be killed with this extra taga match string setting...
# for now, relax the restriiction (relax the match string)
EXTRA_MATCH_STRING="taga"
EXTRA_MATCH_STRING="t"

# order matters! stop generators (mgen) before monitors (tcpdump)
KILL_LIST=$TAGA_KILL_LIST 

# if called with a param, it is being told to use the alt list
if [ $# -eq 1 ]; then
  # alt case
  KILL_LIST=$TAGA_KILL_LIST_ALT
else
  # Normal case
  KILL_LIST=$TAGA_KILL_LIST 
fi


for proc_name in $KILL_LIST
do

   # Do the formatting work here
   # format the string
   procnamelen=`echo $proc_name | awk '{print length($0)}'`
   if [ $procnamelen -eq 3 ]; then
      filler="......."
   elif [ $procnamelen -eq 4 ]; then
      filler="......"
   elif [ $procnamelen -eq 5 ]; then
      filler="....."
   elif [ $procnamelen -eq 6 ]; then
      filler="...."
   elif [ $procnamelen -eq 7 ]; then
      filler="..."
   elif [ $procnamelen -eq 8 ]; then
      filler=".."
   elif [ $procnamelen -eq 9 ]; then
      filler="."
   fi

   # Do the real work here
   # Kill the process id(s) of the proc name
   #KILL_LIST2=`ps -ef | grep \$proc_name | grep -v grep | cut -c10-15` 
   KILL_LIST2=`ps -ef | grep \$proc_name | grep $EXTRA_MATCH_STRING | grep -v grep | cut -c10-15` 
   if [ $TAGA_DISPLAY_SETTING -gt $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
     echo killing $proc_name $filler Kill_list: $KILL_LIST2
   fi
   sudo kill -9 $KILL_LIST2 <$TAGA_CONFIG_DIR/passwd.txt # < $TAGA_CONFIG_DIR/passwd.txt

done

