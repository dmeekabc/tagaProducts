#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#echo
#echo WARNING: This command will reboot the following: $OTHER_LIST
#echo
#echo Are you sure? \(y/n\) ?
#echo
#
## issue confirmation prompt
#$iboaUtilsDir/confirm.sh
#
#let response=$?
#if [ $response -eq 1 ]; then
#  echo; echo Rebooting $OTHER_LIST ....; echo
#else
#  echo; echo Reboot $OTHER_LIST Command Not Confirmed, Exiting without action...; echo
#  exit
#fi
#

# reset our interface
echo Interface is in suspect state - resetting! 
echo Interface is in suspect state - setting interface down!
sudo ifconfig $INTERFACE  down < $TAGA_CONFIG_DIR/passwd.txt
echo Retcode:$?
sleep 5
echo Interface is in suspect state - setting interface up!
sudo ifconfig $INTERFACE  up < $TAGA_CONFIG_DIR/passwd.txt
echo Retcode:$?

echo $0 Recovering Network \(Rebooting Others\)
echo $0 Recovering Network \(Rebooting Others\)
echo $0 Recovering Network \(Rebooting Others\)

# let interface recover from ifconfig command above
sleep 5

# reboot
for target in $OTHER_LIST
do
   echo
   echo processing $target
   if [ $target == $MYIP ]; then
      echo skipping self for now...
      continue
   fi
   echo rebooting $target .....
   ssh -l $MYLOGIN_ID $target sudo reboot <$TAGA_CONFIG_DIR/passwd.txt
done
echo

echo
echo Suspending while other nodes recover...
echo
$IBOA_UTILS_DIR/iboaDelay.sh 60 5
echo; echo Proceeding...; echo
