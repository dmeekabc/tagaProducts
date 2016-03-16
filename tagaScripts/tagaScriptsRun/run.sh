#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   echo processing $target

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



