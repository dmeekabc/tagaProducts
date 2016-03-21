#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let DELAY=$1

echo
date

while [ $DELAY -ge 0 ]; 
do

   # if we have a modulus param, only print on the modulus
   if [ $# -eq 2 ]; then 
      let MODULUS=$2
      let MODULUS_VAL=$DELAY%$MODULUS
      if [ $MODULUS_VAL -eq 0 ]; then
         printf "%d" $DELAY 
         printf "%c" " " 
      fi
   else
     printf "%d" $DELAY 
     printf "%c" " " 
   fi

   let DELAY=$DELAY-1

   # don't sleep if we have hit 0
   if [ $DELAY -ge 0 ]; then
     sleep 1
   fi

done

echo
date

