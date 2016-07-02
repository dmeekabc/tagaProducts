#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# note this works from general to specific through the config and login map files

#echo MYLOGIN_ID=$MYLOGIN_ID

# assume no login map file
# note this will be superseded (last output wins) if login map file does exist
echo $MYLOGIN_ID

if [ -f $TAGA_CONFIG_DIR/loginmap.txt ]; then

   # look for network part match
   SEARCHSTRING=`echo $1 | cut -d. -f1-3`
   SEARCHSTRING=$SEARCHSTRING:
   cat $TAGA_CONFIG_DIR/loginmap.txt | grep $SEARCHSTRING | cut -d: -f 2

   # look for more specific exact IP match (last more specific output wins)
   SEARCHSTRING=`echo $1`
   SEARCHSTRING=$SEARCHSTRING:
   cat $TAGA_CONFIG_DIR/loginmap.txt | grep $SEARCHSTRING | cut -d: -f 2

fi
