#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`

for target in $targetList
do
   TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
   source $TAGA_CONFIG_DIR/config

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   remotetagaScriptsUtilsDir=`echo $tagaScriptsUtilsDir | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   remotetagaScriptsUtilsDir=`echo $remotetagaScriptsUtilsDir | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
      # do not use ssh if target == MYIP and local mode flag set
      if [ $target == $MYIP ]; then
        echo processing, cleaning $target
        $tagaScriptsUtilsDir/managedExecute.sh "$tagaScriptsUtilsDir/clean.sh"
      else
        echo processing, cleaning $target
        echo "ssh -l $MYLOGIN_ID $target $remotetagaScriptsUtilsDir/clean.sh" > /tmp/managedExecuteScript.sh
        chmod 755 /tmp/managedExecuteScript.sh
        $tagaScriptsUtilsDir/managedExecute.sh /tmp/managedExecuteScript.sh
        #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
      fi
   else
        echo processing, cleaning $target
        echo "ssh -l $MYLOGIN_ID $target $remotetagaScriptsUtilsDir/clean.sh" > /tmp/managedExecuteScript.sh
        chmod 755 /tmp/managedExecuteScript.sh
        $tagaScriptsUtilsDir/managedExecute.sh /tmp/managedExecuteScript.sh
        #$tagaScriptsUtilsDir/managedExecute.sh "ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh"
        #ssh -l $MYLOGIN_ID $target $tagaScriptsUtilsDir/clean.sh
   fi
done

