#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


SEARCHSTRING=`echo $1 | cut -d. -f1-3`
SEARCHSTRING=$SEARCHSTRING:
cat $TAGA_CONFIG_DIR/loginmap.txt | grep $SEARCHSTRING | cut -d: -f 2

SEARCHSTRING=`echo $1`
SEARCHSTRING=$SEARCHSTRING:
cat $TAGA_CONFIG_DIR/loginmap.txt | grep $SEARCHSTRING | cut -d: -f 2

