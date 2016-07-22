#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# set defaults; support operation without input
iter=0
TEST_LABEL="Config1" # default to Config1

echo $0 : Test Label : $TEST_LABEL

# get the input (iteration number and test label) if provided
if [ $# -ge 1 ] ; then
  iter=$1
fi
if [ $# -ge 2 ] ; then
  TEST_LABEL=$2
fi

# init cleanup 
rm /tmp/mark* 2>/dev/null

NAME=`basename $0`
IPPART=`$iboaUtilsDir/iboa_padded_echo.sh $MYIP $IP_PAD_LEN`
NAMEPART=`$iboaUtilsDir/iboa_padded_echo.sh $NAME $NAME_PAD_LEN`

if [ $MID_CYCLE_TESTS_ENABLED == 1 ]; then
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo "$IPPART : $NAMEPART : executing at `date`"
  fi
#  echo `basename $0` Start of Cycle Tests 1 Enabled - proceeding...
else
  if [ $TAGA_DISPLAY_SETTING -ge $TAGA_DISPLAY_ENUM_VAL_4_VERBOSE ]; then
    echo "$IPPART : $NAMEPART : disabled at `date`"
  fi
#  echo `basename $0` Start of Cycle Tests 1 Disabled - Exiting
  exit
fi

# If we get here, we are enabled, we need to remove (unset) the  
# "complete" flag file and create (set) our "in progress" flag file

rm /tmp/mark.out 2>/dev/null
rm /tmp/markSecs1.dat 2>/dev/null
rm /tmp/midCycleTests.sh.Complete.dat 2>/dev/null

#START TEST

echo "iter:$iter TEST:$TEST_LABEL In Progress" > /tmp/midCycleTests.sh.InProgress.dat
echo StartDTG: `date` > /tmp/midCycleTest.dat

#mark1 begin
date -Ins > /tmp/mark.out

#mark2 begin
~/scripts/taga/tagaScripts/tagaScriptsTimer/timeDeltaCalcSeconds.sh midCycleTestTimer


PAD=""
PAD0="..."

# simulate a test
echo Simulating a Test for 10 seconds...
for i in 1 2 3 4 5 6 7 8 9 10
do
   PAD="$PAD$PAD0"
  #echo $PAD$i
  echo $i$PAD
  sleep 1
done
echo DONE Simulating a Test for 10 seconds...

# WE are DONE
echo StopDTG:: `date` >> /tmp/midCycleTestTimer.dat

#mark1 end
~/scripts/taga/tagaScripts/tagaScriptsTimer/timeDeltaCalc.sh > /tmp/midCycleTestTimer.dat
rm /tmp/mark.out 2>/dev/null

#mark2 end
~/scripts/taga/tagaScripts/tagaScriptsTimer/timeDeltaCalcSeconds.sh midCycleTestTimer > /tmp/midCycleTestTimer_mark.dat

echo iter:$iter: $TEST:$TEST_LABEL: `cat /tmp/midCycleTestTimer_mark.dat` >> /tmp/midCycleTestTimer_mark_cum.dat
echo iter:$iter: $TEST:$TEST_LABEL: `cat /tmp/midCycleTestTimer_mark.dat` >> /tmp/midCycleTestTimer_mark_cum.dat

echo;echo; echo /tmp/midCycleTestTimer.dat; echo -------------; cat /tmp/midCycleTestTimer.dat
echo;echo; echo /tmp/midCycleTestTimer_mark.dat; echo -------------; cat /tmp/midCycleTestTimer_mark.dat
echo;echo; echo /tmp/midCycleTestTimer_mark_cum.dat; echo -------------; cat /tmp/midCycleTestTimer_mark_cum.dat

echo;echo; echo /tmp/midCycleTestTimer.dat; echo -------------; cat /tmp/midCycleTestTimer.dat
echo;echo; echo /tmp/midCycleTestTimer_mark.dat; echo -------------; cat /tmp/midCycleTestTimer_mark.dat
echo;echo; echo /tmp/midCycleTestTimer_mark_cum.dat; echo -------------; cat /tmp/midCycleTestTimer_mark_cum.dat
echo;echo; 

# Clear the "In Progress" and Set the "Complete" Flag Files

rm /tmp/midCycleTests.sh.InProgress.dat
echo Complete > /tmp/midCycleTests.sh.Complete.dat

