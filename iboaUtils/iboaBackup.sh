#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

BACKUP_DATE=`date +%j%H%M%S`
BACKUP_DIR=~/.iboaBackup/iboaBackup_$BACKUP_DATE
mkdir -p $BACKUP_DIR; cp ~/.bashrc* $BACKUP_DIR
echo IBOA backup: all .bashrc* files written to $BACKUP_DIR

