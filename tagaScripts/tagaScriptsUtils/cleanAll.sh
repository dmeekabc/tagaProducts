#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      # do not use ssh if target == MYIP and local mode flag set
      if [ $target == $MYIP ]; then
        echo processing, cleaning $target
        $tagaScriptsUtilsDir/managedExecute.sh "$tagaScriptsUtilsDir/clean.sh"
      else
        echo processing, cleaning $target
        echo "ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh" > /tmp/managedExecuteScript.sh
        chmod 755 /tmp/managedExecuteScript.sh
        $tagaScriptsUtilsDir/managedExecute.sh /tmp/managedExecuteScript.sh
        #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
      fi
   else
        echo processing, cleaning $target
        echo "ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh" > /tmp/managedExecuteScript.sh
        chmod 755 /tmp/managedExecuteScript.sh
        $tagaScriptsUtilsDir/managedExecute.sh /tmp/managedExecuteScript.sh
        #$tagaScriptsUtilsDir/managedExecute.sh "ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh"
        #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
   fi
done

