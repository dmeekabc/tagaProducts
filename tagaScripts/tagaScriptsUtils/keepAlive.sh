#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

IP_TO_KEEP_ALIVE=$MYIP
ITFC_TO_KEEP_ALIVE=$INTERFACE

function checkInterface {

   let status=2
   let status=1

   echo checking interface $INTERFACE
   if [ $status -eq 1 ] ; then
      return 1
   else
      return 2
   fi
}

############################
# MAIN
############################

# do this once initially to get the password out of the way
# note, we may be able to pass "< confirm.txt" ('y') as other option

echo sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
echo RetCode: $?

while true
do

   echo Keep Alive
#   echo IP_TO_KEEP_ALIVE:$IP_TO_KEEP_ALIVE
#   echo ITFC_TO_KEEP_ALIVE:$ITFC_TO_KEEP_ALIVE
   echo IP_TO_KEEP_ALIVE: $IP_TO_KEEP_ALIVE ITFC_TO_KEEP_ALIVE: $ITFC_TO_KEEP_ALIVE
   checkInterface
   let status=$?

   echo returned status: $status
   echo returned status: $status
   echo returned status: $status

   if [ $status -eq 1 ] ; then
      echo "sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up"
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $?
   else
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface!
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface!
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE down
      echo RetCode: $?
      sleep 1
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE down
      echo RetCode: $?
      sleep 5
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $?
      sleep 1
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $?
      return 2
   fi

   $iboaUtilsDir/iboaDelay.sh 10 2

done



#IP_TO_KEEP_ALIVE=192.168.43.208
#ITFC_TO_KEEP_ALIVE=wlp2s0
#
#while true
#do
#  echo sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
#  sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
#  sleep 60
#  date
#done
