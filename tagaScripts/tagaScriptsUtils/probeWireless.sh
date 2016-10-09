#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=$HOME/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# basic sanity check, to ensure password updated etc
./basicSanityCheck.sh
if [ $? -eq 255 ]; then
  echo Basic Sanith Check Failed - see warning above - $0 Exiting...
  echo
  exit 255
fi

for target in $targetList
do

    # determine LOGIN ID for each target
    MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`

    #WIRELESS_INTERFACE="wlan0"

    WIRELESS_INTERFACE=`ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep HWaddr | grep ^wl | cut -d" " -f 1`

    #echo $WIRELESS_INTERFACE
    #continue


   if echo $BLACKLIST | grep $target ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo; echo `date` : probing $target
      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iwconfig $WIRELESS_INTERFACE `
      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw $WIRELESS_INTERFACE info`

      #echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iwconfig wlan0`
      #echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw wlan0 info`

      # echo DateBefore: $target: `ssh -l $MYLOGIN_ID $target date`
#      echo $target: `ssh -l $MYLOGIN_ID $target sudo /bin/date 072912202016`
      # echo $target: `ssh -l $MYLOGIN_ID $target sudo /bin/date 092215252016`
      # echo DateAfter: $target: `ssh -l $MYLOGIN_ID $target date`
     # echo `basename $0` processing $target .......
  #    echo $target: `ssh -l $MYLOGIN_ID $target hostname`
  #    echo $target: `ssh -l $MYLOGIN_ID $target date`

  #    echo $target: `ssh -l $MYLOGIN_ID $target cat /tmp/normRozn*.log | grep Server | grep id`

#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iwconfig wlan1 `
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw wlan1 info `
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/iw list`
#      echo
#      echo
#      echo $target: `ssh -l $MYLOGIN_ID $target traceroute 192.168.41.221`
#      echo
#      echo
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ip route`
#      echo $target: `ssh -l $MYLOGIN_ID $target /sbin/route`
  #    echo $target: `ssh -l $MYLOGIN_ID $target uptime`
#      echo $target: `ssh -l $MYLOGIN_ID $target ps -ef | grep mgen`
#      echo $target: `ssh -l $MYLOGIN_ID $target ps -ef | grep netconf`
  #    echo $target: `ssh -l $MYLOGIN_ID $target /sbin/ifconfig | grep HWaddr`
   fi
done
echo
