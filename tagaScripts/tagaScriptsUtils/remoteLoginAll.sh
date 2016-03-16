#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

for target in $targetList
do
   if [ $target == $MYIP ]; then
     echo processing $target
     echo
     echo skipping self \($target\) ...
     echo
   else
     echo processing $target
     echo
     echo Remotely logging into $target vis SSH ...
     echo
     ssh $target
     echo
     echo Exited Remote log into $target vis SSH ...
     echo
   fi
done

echo $0 returned to self...; echo
echo $0 complete!; echo


