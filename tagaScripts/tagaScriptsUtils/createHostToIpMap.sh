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

   if echo $BLACKLIST | grep $target ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo `basename $0` processing $target .......
   fi

   # don't use ssh if local mode flag is set
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      if [ $target == $MYIP ]; then
         processCount=`ps -ef | wc -l`           
         targethostname=`hostname` 
      else
         processCount=`ssh -l $MYLOGIN_ID $target ps -ef | wc -l`           
         targethostname=`ssh -l $MYLOGIN_ID $target hostname` 
      fi
   else
      processCount=`ssh -l $MYLOGIN_ID $target ps -ef | wc -l`           
      targethostname=`ssh -l $MYLOGIN_ID $target hostname` 
   fi

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
   buffer2="$buffer1 (process count: $processCount)"

   # write buffer line to output
   echo $buffer2 

   # write the hostList.txt and hostsToIps.txt files
   echo $targethostname >> $TAGA_CONFIG_DIR/hostList.txt
   echo $target.$targethostname >> $TAGA_CONFIG_DIR/hostsToIps.txt

done
echo
