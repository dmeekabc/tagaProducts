#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let complete=0
let targetCount=`echo $targetList | wc -w`

rm /tmp/notify.dat

echo StartDTG: `date` > /tmp/notify.dat
#echo --------: >> /tmp/notify.dat
#date           >> /tmp/notify.dat

while [ $complete -eq 0 ] 
do
   let notifiedCount=0
   for target in $targetList
   do
      if cat /tmp/JTMNM_Notifications.$target.out | grep jteDone >/dev/null; then
         let notifiedCount=$notifiedCount+1
         if [ $notifiedCount ==  $targetCount ] ; then
             echo StopDTG:: `date` >> /tmp/notify.dat
             #echo --------: >> /tmp/notify.dat
             #date           >> /tmp/notify.dat
             let complete=1
             echo Notifications Complete!
         fi
      fi
   done
   echo targetCount:$targetCount notifiedCount:$notifiedCount
   sleep 1
done

