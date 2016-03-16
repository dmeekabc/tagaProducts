####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# vars
DELTA_FILE=/tmp/iboa/log/delta.out
PCAP_DATA_FILE=/tmp/iboa/log/ppc.out
TMP_FILE=/tmp/iboa/log/tmp.txt
TMP2_FILE=/tmp/iboa/log/tmp2.txt

# init
rm $DELTA_FILE ; touch $DELTA_FILE 
cp $PCAP_DATA_FILE $TMP_FILE 

# get line count
let lines=`cat $TMP_FILE | wc -l`

let i=0
while [ $lines -gt 1 ] 
do

   input=`head -n 1 $TMP_FILE`
   echo $input > input.txt
   read input1 input2 < input.txt
#   echo input1: $input1 
#   echo input2: $input2 

   let delta=$input1-$input2
#   echo $delta
   echo $delta >> $DELTA_FILE 

   let i=$i+1

   let MOD=$i%100

   let lines=`cat $TMP_FILE | wc -l`

   if [ $MOD -eq 0 ] ; then
      echo $i lines processed : $lines lines remain
   fi

   cat $TMP_FILE | sed 1d > $TMP2_FILE
   mv $TMP2_FILE $TMP_FILE

done


echo; echo Deltas are in $DELTA_FILE; echo

