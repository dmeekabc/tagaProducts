#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# Single Machine Commands

# Taga:TODO: Add logic to check if this has been done

# DO THIS ONE TIME ONLY ON SOURCE MACHINE AND ONLY IF NEEDED
#   ssh-keygen

######################################
######################################
######################################

# DO THIS FOR EACH DEST MACHINE

echo $targetList

for target in $targetList
do
  ssh-copy-id $MYLOGIN_ID@$target

  #let PREP_TCPDUMP_ENABLED=0
  let PREP_TCPDUMP_ENABLED=1
  
  # prep tcpdump (TBD if this is needed)
  if [ $PREP_TCPDUMP_ENABLED -eq 1 ]; then
    ssh -l $MYLOGIN_ID $target $TAGA_DIR/prep_tcpdump.sh
  fi

done

