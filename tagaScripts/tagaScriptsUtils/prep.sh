#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# Single Machine Commands

MYLOCALLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $MYIP | tail -n 1`
MYLOCALLOGIN_ID=`echo $MYLOCALLOGIN_ID`

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

   TAGA_DIR=~/scripts/taga
   TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
   source $TAGA_CONFIG_DIR/config

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 
   
   TAGA_DIR=`echo $TAGA_DIR | sed -e s/$MYLOCALLOGIN_ID/MYLOGIN_ID/g`
   TAGA_DIR=`echo $TAGA_DIR | sed -e s/MYLOGIN_ID/$MYLOGIN_ID/g`

  ssh-copy-id $MYLOGIN_ID@$target

  #let PREP_TCPDUMP_ENABLED=0
  let PREP_TCPDUMP_ENABLED=1
  
  # prep tcpdump (TBD if this is needed)
  if [ $PREP_TCPDUMP_ENABLED -eq 1 ]; then
    ssh -l $MYLOGIN_ID $target $TAGA_DIR/tagaScripts/tagaScriptsUtils/prep_tcpdump.sh
  fi

done

