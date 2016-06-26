#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# determine the time for traffic to begin flowing
let trafficStartEpoch=`date +%s`
let trafficStartEpoch=$trafficStartEpoch+$MGEN_SERVER_INIT_DELAY

for target in $targetList
do
   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   else
      echo `basename $0` processing $target .......
   fi

   #
   # if a paramater is passed, then that is special flag to start the keepAlive process 
   #   (i.e. this is done once per runLoop only)
   #
   if [ $# -eq 1 ] ; then
   if [ $TAGA_KEEP_ALIVE -eq 1 ] ; then
      echo running keepAlive.sh on $target
      ssh -l $MYLOGIN_ID $target "$tagaScriptsUtilsDir/keepAlive.sh <$TAGA_UTILS_DIR/confirm.txt >/dev/null " &
   fi
   fi

   if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_3_NORMAL ]; then
      # invoke the 'simulations' on each target 
      ssh -l $MYLOGIN_ID $target $tagaScriptsSimDir/simulate.sh       <$TAGA_CONFIG_DIR/passwd.txt &
   else
      # invoke the 'simulations' on each target 
      # suppress std out output
      ssh -l $MYLOGIN_ID $target $tagaScriptsSimDir/simulate.sh >/dev/null   <$TAGA_CONFIG_DIR/passwd.txt &
   fi

   # run traffic unless the 'simulation only' flag is set
   if [ $SIMULATION_ONLY -eq 0 ]; then
      if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_2_BRIEF ]; then
         ssh -l $MYLOGIN_ID $target $tagaScriptsTcpdumpDir/tcpdump.sh $target & 
         ssh -l $MYLOGIN_ID $target $tagaScriptsMgenDir/mgen.sh $target $trafficStartEpoch&
      else
         # suppress output to stdout
         ssh -l $MYLOGIN_ID $target $tagaScriptsTcpdumpDir/tcpdump.sh $target >/dev/null & 
         ssh -l $MYLOGIN_ID $target $tagaScriptsMgenDir/mgen.sh $target $trafficStartEpoch >/dev/null &
      fi
   fi

done



