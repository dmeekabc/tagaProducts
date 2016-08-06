#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let DELAY=$1

TAGADELAY_DAT_FILE=/tmp/tagaDelay.dat

#echo
date

while [ $DELAY -ge 0 ]; 
do

   # if we have a modulus param, only print on the modulus
   if [ $# -eq 2 ]; then 
      let MODULUS=$2
      let MODULUS_VAL=$DELAY%$MODULUS
      if [ $MODULUS_VAL -eq 0 ]; then
        # conditional output to standard out
        if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "%d" $DELAY; printf "%c" " " ; fi
        # non-conditional output to outfile
        printf "%d" $DELAY >> $TAGADELAY_DAT_FILE; printf "%c" " " >> $TAGADELAY_DAT_FILE
      fi
   else
     # conditional output to standard out
     if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then printf "%d" $DELAY; printf "%c" " " ; fi
     # non-conditional output to outfile
     printf "%d" $DELAY >> $TAGADELAY_DAT_FILE ; printf "%c" " " >> $TAGADELAY_DAT_FILE
   fi

   let DELAY=$DELAY-1

   # don't sleep if we have hit 0
   if [ $DELAY -ge 0 ]; then
     sleep 1
   fi

done

# we are done here...

# close output to standard out
printf "\n"  

#echo
date

# close output to out file
printf "\n" >> $TAGADELAY_DAT_FILE 
echo        >> $TAGADELAY_DAT_FILE 
date        >> $TAGADELAY_DAT_FILE 


