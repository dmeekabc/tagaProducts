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

   ssh -l $MYLOGIN_ID $target mkdir -p /tmp/usr/local/lib
   scp -r /usr/local/lib/libnano* $MYLOGIN_ID@$target:/tmp/usr/local/lib <$TAGA_CONFIG_DIR/passwd.txt

   ssh -l $MYLOGIN_ID $target mkdir -p ~/code
   scp -r ~/code/* $MYLOGIN_ID@$target:~/code <$TAGA_CONFIG_DIR/passwd.txt

   ssh -l $MYLOGIN_ID $target mkdir -p $TAGA_DIR/code
   scp -r $TAGA_DIR/code/* $MYLOGIN_ID@$target:$TAGA_DIR/code <$TAGA_CONFIG_DIR/passwd.txt

done

