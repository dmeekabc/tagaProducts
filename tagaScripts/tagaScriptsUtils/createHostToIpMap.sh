#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

##################################################################
# MAIN
##################################################################

# start with fresh file
rm $TAGA_CONFIG_DIR/hostsToIps.txt 2>/dev/null
rm $TAGA_CONFIG_DIR/hostList.txt 2>/dev/null

echo

# build the hostList from the targetList
for target in $targetList
do
   processCount=`ssh -l $MYLOGIN_ID $target ps -ef | wc -l`           
   targethostname=`ssh -l $MYLOGIN_ID $target hostname` 

   # echo $target $targethostname \(process count: $processCount\)

   # build up the buffer
   buffer1="$target $targethostname"
   # pad the buffer
   buflen=`echo $buffer1 | awk '{print length($0)}'`
   let ROW_SIZE=56
   let ROW_SIZE=52
   let padlen=$ROW_SIZE-$buflen
   # add the padding
   let i=$padlen
   while [ $i -gt 0 ];
   do
     buffer1="$buffer1."
     let i=$i-1
   done
   # add the percent at the end of the buffer
   #buffer2="$buffer1 ($percent%)"
   buffer2="$buffer1 (process count: $processCount)"

   # write buffer line to output; write buffer line to counts.txt file
   echo $buffer2 #; echo $buffer2 >> $TAGA_DIR/counts.txt


#####################################################
#####################################################

#   echo $target $targethostname \(process count: $processCount\)
   echo $targethostname >> $TAGA_CONFIG_DIR/hostList.txt
   echo $target.$targethostname >> $TAGA_CONFIG_DIR/hostsToIps.txt
done
echo
