#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# gitHub TODO:
# gitHub TODO:
# gitHub Note: This should probably become single SSH command to kick off all this activity on remotes
# gitHub Note: This should probably become single SSH command to kick off all this activity on remotes
# gitHub TODO:
# gitHub Note: Consider real-time data flow and log implications of such a change
# gitHub Note: Consider real-time data flow and log implications of such a change
# gitHub TODO:
# gitHub TODO:


for target in $targetList
do
   echo processing $target

   if [ $TAGA_KEEP_ALIVE -eq 1 ] ; then
      echo running keepAlive.sh on $target
      #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/keepAlive.sh <$TAGA_UTILS_DIR/confirm.txt &
      #ssh -l $MYLOGIN_ID $target "$tagaScriptsUtilsDir/keepAlive.sh <$TAGA_UTILS_DIR/confirm.txt " &
      ssh -l $MYLOGIN_ID $target "$tagaScriptsUtilsDir/keepAlive.sh <$TAGA_UTILS_DIR/confirm.txt >/dev/null " &
   fi

   ssh -l $MYLOGIN_ID $target $tagaScriptsSimDir/simulate.sh       <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsSimDir/simulatePubSub.sh <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsSimDir/simulateXXX.sh    <$TAGA_CONFIG_DIR/passwd.txt &
   ssh -l $MYLOGIN_ID $target $tagaScriptsSimDir/simulateSIM1.sh   <$TAGA_CONFIG_DIR/passwd.txt &

   # run traffic unless simulation only flag is set
   if [ $SIMULATION_ONLY -eq 0 ]; then
      ssh -l $MYLOGIN_ID $target $tagaScriptsTcpdumpDir/tcpdump.sh $target & 
      ssh -l $MYLOGIN_ID $target $tagaScriptsMgenDir/mgen.sh $target &
   fi

done



