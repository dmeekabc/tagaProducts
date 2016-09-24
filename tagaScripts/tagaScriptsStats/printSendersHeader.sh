#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# get the input
iter=$2
startTime=$3
startDTG=$4

##################################################################
# Print Header Rows
##################################################################

# print header row
echo;echo
echo >> $TAGA_RUN_DIR/counts.txt

#echo `date` Iteration:$iter StartDTG: $startTime $startDTG $TESTTYPE
#echo `date` Iteration:$iter StartDTG: $startTime $startDTG $TESTTYPE >> $TAGA_RUN_DIR/counts.txt

if [ $NARROW_DISPLAY -eq 1 ]; then
  row="$1 TABLE         ------------------ RECEIVERS LIST ---------------------"
elif [ $WIDE_DISPLAY -eq 1 ]; then
  row="$1 TABLE         -----------------------------------------------------------------------------------------------------------------  RECEIVERS LIST -----------------------------------------------------------------------------------------------------------------------"
else
  row="$1 TABLE         -------------------------------------  RECEIVERS LIST ---------------------------------------------"
fi

echo "$row"
echo "$row" >> $TAGA_RUN_DIR/counts.txt

if [ $NARROW_DISPLAY -eq 1 ]; then
  row="    1    2    3    4    5    6    7    8    9    10   Tot"
elif [ $WIDE_DISPLAY -eq 1 ]; then
  row="       1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50"
else
  row="       1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20"
fi

echo "SENDERS LIST      $row"
echo "SENDERS LIST      $row" >> $TAGA_RUN_DIR/counts.txt

if [ $NARROW_DISPLAY -eq 1 ]; then
  row="-----------------     ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
elif [ $WIDE_DISPLAY -eq 1 ]; then
  row="------------------    ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
else
  row="------------------    ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----"
fi

echo "$row"
echo "$row" >> $TAGA_RUN_DIR/counts.txt

