#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

IP_TO_KEEP_ALIVE=$MYIP
ITFC_TO_KEEP_ALIVE=$INTERFACE

MY_KA_LOG_FILE=/tmp/tagaKeepAlive.log

let CURRENT_RX_BYTES=`ifconfig $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d\( -f 1`
let PREVIOUS_RX_BYTES=$CURRENT_RX_BYTES

#echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES
#echo PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES

function checkInterface {

   echo checking interface $INTERFACE >> $MY_KA_LOG_FILE

   let status=1
   let CURRENT_RX_BYTES=`ifconfig $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d\( -f 1`

   if [  $CURRENT_RX_BYTES -eq $PREVIOUS_RX_BYTES ] ; then
      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!! >> $MY_KA_LOG_FILE
      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!! >> $MY_KA_LOG_FILE
      echo Warning: $ITFC_TO_KEEP_ALIVE does not appear to be receiving traffic!! >> $MY_KA_LOG_FILE
      echo Warning: $ITFC_TO_KEEP_ALIVE does not appear to be receiving traffic!! >> $MY_KA_LOG_FILE
      echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES >> $MY_KA_LOG_FILE
      echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES >> $MY_KA_LOG_FILE

      let status=2

      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!! >> $MY_KA_LOG_FILE
      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!! >> $MY_KA_LOG_FILE
   else
      echo Info: Interface $ITFC_TO_KEEP_ALIVE appears to be in a good state. >> $MY_KA_LOG_FILE
      echo Info: Interface $ITFC_TO_KEEP_ALIVE is receiving traffic. >> $MY_KA_LOG_FILE
      echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES >> $MY_KA_LOG_FILE

      let status=1

      echo Info: Interface $ITFC_TO_KEEP_ALIVE appears to be in a good state. >> $MY_KA_LOG_FILE
   fi

   let PREVIOUS_RX_BYTES=$CURRENT_RX_BYTES

   return $status

}

############################
# MAIN
############################

# do this once initially to get the password out of the way
# note, we may be able to pass "< confirm.txt" ('y') as other option

echo sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up >> $MY_KA_LOG_FILE
sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
echo RetCode: $? >> $MY_KA_LOG_FILE

# do the delay here to ensure we have chance for rx byte count to change
$iboaUtilsDir/iboaDelay.sh 60 5 >> $MY_KA_LOG_FILE

while true
do

   echo Keep Alive >> $MY_KA_LOG_FILE
   echo IP_TO_KEEP_ALIVE: $IP_TO_KEEP_ALIVE ITFC_TO_KEEP_ALIVE: $ITFC_TO_KEEP_ALIVE >> $MY_KA_LOG_FILE
   checkInterface
   let status=$?

   echo returned status: $status >> $MY_KA_LOG_FILE
   echo returned status: $status >> $MY_KA_LOG_FILE
   echo returned status: $status >> $MY_KA_LOG_FILE

   if [ $status -eq 1 ] ; then
      echo "sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up" >> $MY_KA_LOG_FILE
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $? >> $MY_KA_LOG_FILE
   else
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface! >> $MY_KA_LOG_FILE
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface! >> $MY_KA_LOG_FILE
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE down
      echo RetCode: $? >> $MY_KA_LOG_FILE
      sleep 1
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface! >> $MY_KA_LOG_FILE
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface! >> $MY_KA_LOG_FILE
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE down
      echo RetCode: $? >> $MY_KA_LOG_FILE
      sleep 5
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface! >> $MY_KA_LOG_FILE
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface! >> $MY_KA_LOG_FILE
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $? >> $MY_KA_LOG_FILE
      sleep 1
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface! >> $MY_KA_LOG_FILE
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface! >> $MY_KA_LOG_FILE
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $? >> $MY_KA_LOG_FILE
   fi

   $iboaUtilsDir/iboaDelay.sh 60 5 >> $MY_KA_LOG_FILE

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
