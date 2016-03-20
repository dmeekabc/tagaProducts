#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

IP_TO_KEEP_ALIVE=$MYIP
ITFC_TO_KEEP_ALIVE=$INTERFACE

let CURRENT_RX_BYTES=`ifconfig $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d\( -f 1`
let PREVIOUS_RX_BYTES=$CURRENT_RX_BYTES

#echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES
#echo PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES

function checkInterface {

   echo checking interface $INTERFACE

   let status=1
   let CURRENT_RX_BYTES=`ifconfig $INTERFACE | grep "RX bytes" | cut -d: -f 2 | cut -d\( -f 1`

   if [  $CURRENT_RX_BYTES -eq $PREVIOUS_RX_BYTES ] ; then
      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!!
      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!!
      echo Warning: $ITFC_TO_KEEP_ALIVE does not appear to be receiving traffic!!
      echo Warning: $ITFC_TO_KEEP_ALIVE does not appear to be receiving traffic!!
      echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES
      echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES

      let status=2

      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!!
      echo Warning: Potential Problem with Interface $ITFC_TO_KEEP_ALIVE Identified!!
   else
      echo Info: Interface $ITFC_TO_KEEP_ALIVE appears to be in a good state.
      echo Info: Interface $ITFC_TO_KEEP_ALIVE is receiving traffic.
      echo CURRENT_RX_BYTES:$CURRENT_RX_BYTES PREVIOUS_RX_BYTES:$PREVIOUS_RX_BYTES

      let status=1

      echo Info: Interface $ITFC_TO_KEEP_ALIVE appears to be in a good state.
   fi

   let PREVIOUS_RX_BYTES=$CURRENT_RX_BYTES

   return $status

}

############################
# MAIN
############################

# do this once initially to get the password out of the way
# note, we may be able to pass "< confirm.txt" ('y') as other option

echo sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
echo RetCode: $?

# do the delay here to ensure we have chance for rx byte count to change
$iboaUtilsDir/iboaDelay.sh 60 5

while true
do

   echo Keep Alive
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
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface!
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, resetting interface!
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE down
      echo RetCode: $?
      sleep 5
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface!
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface!
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $?
      sleep 1
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface!
      echo Possible Issue with $ITFC_TO_KEEP_ALIVE identified, restoring interface!
      sudo ifconfig $ITFC_TO_KEEP_ALIVE $IP_TO_KEEP_ALIVE up
      echo RetCode: $?
   fi

   $iboaUtilsDir/iboaDelay.sh 60 5

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
