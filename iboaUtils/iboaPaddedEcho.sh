#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

PADVAR=";"
PADVAR=";"
PADVAR=":"
PADVAR=" "
PADVAR="x"
PADVAR="."

if [ $# -ne 2 ]; then
    echo $0: Error, two params required!
   echo "   required param 1: output param to be padded"
   echo "   required param 2: size of output after padding"
   exit 255
fi

outputParam=$1
printlen=$2

buflen=`echo $outputParam | awk '{print length($0)}'`

let padlen=$printlen-$buflen
# add the padding
let i=$padlen
while [ $i -gt 0 ];
do
  outputParam="$outputParam$PADVAR"
  let i=$i-1
done

echo $outputParam




