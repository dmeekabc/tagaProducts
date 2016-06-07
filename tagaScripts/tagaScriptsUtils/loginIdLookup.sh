#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


# default to the base configuration login id
echo $MYLOGIN_ID

# search the login id Map for a match and use that if found

if [ -f $TAGA_CONFIG_DIR/loginmap.txt ]; then

   # match the subnet address (three octets)
   SEARCHSTRING=`echo $1 | cut -d. -f1-3`
   SEARCHSTRING=$SEARCHSTRING:
   cat $TAGA_CONFIG_DIR/loginmap.txt | grep $SEARCHSTRING | cut -d: -f 2 

   # match the entire IP address (all four octets)
   SEARCHSTRING=`echo $1`
   SEARCHSTRING=$SEARCHSTRING:
   cat $TAGA_CONFIG_DIR/loginmap.txt | grep $SEARCHSTRING | cut -d: -f 2

fi
