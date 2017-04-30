####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

#######################################################
# function displayFilter
#######################################################

function displayFilter {
if [ $EXPERT_DISPLAY -eq 1 ] ;then
   # Expert display is on
   echo Nothing to Filter since Expert Display has no filters >/dev/null
else
   # Expert display is off # Check Filters for reduced display
   if [ $MAX_STAT_DISPLAY -eq 0 ] ;then
      echo MAX DISLAY is OFF but the Recd count is always displayed for UCAST_UDP!! >/dev/null
   elif [ $TAGA_TRAFFIC_GENERATOR == "BASH_SOCKET" ] ; then
      if [ $1 == "Commanded" ] ; then
         # Commanded Throughput is valid for BASH SOCKET unless TCP
         if [ $TESTTYPE == "UCAST_TCP" ]; then
            echo 
i           echo NOTICE: Test Type: $TESTTYPE not supported for BashSock Traffic Generator 
            echo >> $TAGA_RUN_DIR/counts.txt
            echo NOTICE: Test Type: $TESTTYPE not supported for BashSock Traffic Generator >> $TAGA_RUN_DIR/counts.txt
            buffer1="" # filter it
         fi
         echo Commanded Throughput is always valid for BASH_SOCKET>/dev/null
         #buffer1=""
      else
         # Percentage Lines Displays... check further...
         echo MAX DISPLAY is ON but BASH_SOCKET>/dev/null
         buffer1="" # filter it
         if [ $TESTTYPE == "MCAST" ]; then
            echo MAX DISPLAY is ON but BASH_SKT MCAST>/dev/null
            buffer1="" # filter it
         elif [ $TESTTYPE == "UCAST_TCP" ]; then
            echo MAX DISPLAY is ON but BASH_SKT UCAST_TCP>/dev/null
            buffer1="" # filter it
         fi
      fi
   elif [ $TAGA_TRAFFIC_GENERATOR == "IPERF" ] ; then
      echo MAX DISPLAY is ON but IPERF>/dev/null
      buffer1="" # filter it
      if [ $TESTTYPE == "MCAST" ]; then
         echo MAX DISPLAY is ON but IPERF MCAST>/dev/null
         buffer1="" # filter it
      elif [ $TESTTYPE == "UCAST_TCP" ]; then
         echo MAX DISPLAY is ON but IPERF UCAST_TCP>/dev/null
         #buffer1=""
      fi
   elif [ $TESTTYPE == "MCAST" ]; then
      echo MAX DISPLAY is ON but MGEN MCAST>/dev/null
      #buffer1=""
   elif [ $TESTTYPE == "UCAST_TCP" ]; then
      echo MAX DISPLAY is ON but MGEN UCAST_TCP>/dev/null
      #buffer1=""
   fi
fi
}


#######################################################
# MAIN
#######################################################


# If counts are disabled, exit now
if [ $COUNTS_DISABLED -eq 1 ]; then
   echo NOTICE: Counts are DISABLED, $0 exiting with no action!
   exit
fi

#################################################################
# Validate the Configuration based on TAGA_TRAFFIC_GENERATOR TYPE
#################################################################
# The GENERATOR_STR may be redudant (to $TAGA_TRAFFIC_GENERATOR) 
# ... or may be used to customize output
if [ $TAGA_TRAFFIC_GENERATOR == "BASH_SOCKET" ] ; then
   GENERATOR_STR=BASH_SOCKET
   GENERATOR_STR="BASE TRAFFIC"
   GENERATOR_STR="BashSock"
   if [ $MSGRATE_CONFIGURED -ne 1 ] ; then
      echo
      echo TAGA NOTICE: Configured Message Rate \($MSGRATE_CONFIGURED\) is not supported.
      echo TAGA NOTICE: Assuming Message Rate of One \(1\)
      echo
      MSGRATE=1
   fi
elif [ $TAGA_TRAFFIC_GENERATOR == "IPERF" ] ; then
   GENERATOR_STR=IPERF
else
   GENERATOR_STR=MGEN
fi


# get the inputs
outputDir=$1
iter=$2
startTime=$3
currentDelta=$4
deltaEpoch=$5
startDTG=$6

# get the average iteration duration

let averageDuration=$deltaEpoch/$iter
# special handling for iteration 1
if [ $iter -eq 1 ]; then
   let currentDelta=$averageDuration 
fi

# archive directory processing
if [ $TESTONLY -eq 1 ] ; then
  # use the testing directory for testing
  outputDir=$OUTPUT_DIR/output
fi 
# go to the output Directory for processing

if [ $TAGA_DISPLAY_SETTING -gt $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
  echo outputDir: $outputDir
fi

cd $outputDir


# add a line break and date to output and counts.txt
echo; echo >> $TAGA_RUN_DIR/counts.txt
date; date >> $TAGA_RUN_DIR/counts.txt

# add the header
echo ============================= TAGA Iteration:$iter =============================
echo ============================= TAGA Iteration:$iter ============================= >>  $TAGA_RUN_DIR/counts.txt

#echo TAGA:Iter:$iter StartDTG:$startTime Dur:$currentDelta\s AvgDur:$averageDuration\s TestType:$TESTTYPE $GENERATOR_STR
#echo TAGA:Iter:$iter StartDTG:$startTime Dur:$currentDelta\s AvgDur:$averageDuration\s TestType:$TESTTYPE $GENERATOR_STR >> $TAGA_RUN_DIR/counts.txt
echo TAGA:Iter:$iter StartDTG:$startTime Dur:$currentDelta\s AvgDur:$averageDuration\s TestType:$GENERATOR_STR $TESTTYPE 
echo TAGA:Iter:$iter StartDTG:$startTime Dur:$currentDelta\s AvgDur:$averageDuration\s TestType:$GENERATOR_STR $TESTTYPE >> $TAGA_RUN_DIR/counts.txt

# calculate the aggregate commanded throughput rate
let targetCount=0
for target in $targetList
do
   let targetCount=$targetCount+1
done

let BITS_PER_BYTE=8
let commandedRate=$MSGRATE*$targetCount*$MSGLEN*$BITS_PER_BYTE
let megabitRate=$commandedRate*1000/1000000
let kilobitRate=$commandedRate*1000/1000

# pad target name as necessary to have nice output
let ratelen=`echo $commandedRate | awk '{print length($0)}'`
if [ $ratelen -eq 8 ]; then
  megabitPrint=`echo $megabitRate | cut -c1-2`.`echo $megabitRate | cut -c3-4`
  let kilobitPrint=$kilobitRate/1000
elif [ $ratelen -eq 7 ]; then
  megabitPrint=`echo $megabitRate | cut -c1`.`echo $megabitRate | cut -c2-4`
  let kilobitPrint=$kilobitRate/1000
elif [ $ratelen -eq 6 ]; then
  megabitPrint=0.`echo $megabitRate | cut -c1-3`
  let kilobitPrint=$kilobitRate/1000
elif [ $ratelen -eq 5 ]; then
  megabitPrint=0.0`echo $megabitRate | cut -c1-2`
  kilobitPrint=`echo $kilobitRate | cut -c1-2`.`echo $kilobitRate | cut -c3-4`
elif [ $ratelen -eq 4 ]; then
  megabitPrint=0.00`echo $megabitRate | cut -c1`
  kilobitPrint=`echo $kilobitRate | cut -c1`.`echo $kilobitRate | cut -c2-4`
elif [ $ratelen -eq 3 ]; then
  megabitPrint=0.000
  kilobitPrint=0.`echo $kilobitRate | cut -c1-3`
elif [ $ratelen -eq 2 ]; then
  megabitPrint=0.000
  kilobitPrint=0.0`echo $kilobitRate | cut -c1-2`
else
  megabitPrint=0.000
fi

############################################
# Commaned Throughput Display
############################################
# build the buffer1
buffer1="TAGA:Iter:$iter: Commanded Throughput: $commandedRate bps ($kilobitPrint kbps)  ($megabitPrint mbps)" 

# filter it
displayFilter "Commanded"

# display it 
# (if we have a valid "Commanded" buffer)
if echo $buffer1 | grep Commanded >/dev/null; then 
   echo $buffer1 
   echo $buffer1 >> $TAGA_RUN_DIR/counts.txt
fi

# get Gross Received Count
let grossReceivedCount=0

# Get Multicast Received Counts
if [ $TESTTYPE == "MCAST" ]; then
  for target in $targetList
  do
    HOST=`cat $TAGA_CONFIG_DIR/hostsToIps.txt | grep $target\\\. | cut -d"." -f 5`
    SOURCE_FILE_TAG=$TEST_DESCRIPTION\_$HOST\_*$target\_
    # get our target receive count
    let targetReceivedCount=`cat $SOURCE_FILE_TAG* 2>/dev/null | grep -v $target | wc -l`
    let grossReceivedCount=$grossReceivedCount+$targetReceivedCount
  done
else
  # Get Unicast Received Counts
  for target in $targetList
  do
    HOST=`cat $TAGA_CONFIG_DIR/hostsToIps.txt | grep $target\\\. | cut -d"." -f 5`
    SOURCE_FILE_TAG=$TEST_DESCRIPTION\_$HOST\_*$target\_

    # dlm temp, 30 apr 2017, this is giving false positives, need to tighten our filter...
    # dlm temp, 30 apr 2017, this is giving false positives, need to tighten our filter...

    # get receivers only and only our target
    #let targetReceivedCount=`cat $SOURCE_FILE_TAG* 2>/dev/null | cut -d">" -f 2- | grep $target | wc -l`
    let targetReceivedCount=`cat $SOURCE_FILE_TAG* 2>/dev/null | cut -d">" -f 2- | grep $target | grep "length $MSGLEN" | wc -l`
    let grossReceivedCount=$grossReceivedCount+$targetReceivedCount

  done
fi

#####################################################
# Build the Top Line of the File
#####################################################
#####################################################

# calculate the expected line count
let expectedCount=$MSGCOUNT
let expectedCount2=0

for target in $targetList
do
   # count the nodes we send our message to
   # check the test type
   # if UCAST, each nodes sends a message to each node, except itself
   for target2 in $targetList
   do
     if [ $target2 != $target ]; then
       let expectedCount2=$expectedCount2+1
     fi
   done
done

let expectedCount=$expectedCount*$expectedCount2

let numerator=$grossReceivedCount
let printCount=$numerator
let numerator=$numerator*10000; let denominator=$expectedCount

if [ $denominator -gt 0 ]; then
   let percent=$numerator/$denominator 
else
   echo TAGA:Notice: Denominator of 0 detected.
fi


let checkValue=$numerator/10000 
if [ $checkValue -eq $denominator ]; then
  percent="100.00"
elif [ $checkValue -gt $denominator ]; then
  percent=`echo $percent | cut -c1-3`.`echo $percent | cut -c4-5`
else
  percent=`echo $percent | cut -c1-2`.`echo $percent | cut -c3-4`
  if [ $percent == "0." ]; then
     percent="0.0"
  fi
fi

# write blank line to output; write blank line to counts.txt file
echo; echo >> $TAGA_RUN_DIR/counts.txt

#################
# Build it
#################
# build up the buffer
buffer1="TAGA:Iter:$iter: Tot Files:`ls $outputDir | wc -l` Rec'd Count:$printCount / $expectedCount exp msgs "

#################
# Filter it
#################
# filter it
displayFilter "ReceivedCounts"

#if [ $EXPERT_DISPLAY -eq 1 ] ;then
#   # Expert display is on
#   echo Nothing to Filter since Expert Display has no filters >/dev/null
#else
#   # Expert display is off # Check Filters for reduced display
#   if [ $MAX_STAT_DISPLAY -eq 0 ] ;then
#      echo MAX DISLAY is OFF but the Recd count is always displayed for UCAST_UDP!! >/dev/null
#   elif [ $TAGA_TRAFFIC_GENERATOR == "BASH_SOCKET" ] ; then
#      echo MAX DISPLAY is ON but BASH_SOCKET>/dev/null
#      buffer1="" # filter it
#      if [ $TESTTYPE == "MCAST" ]; then
#         echo MAX DISPLAY is ON but BASH_SKT MCAST>/dev/null
#         buffer1="" # filter it
#      elif [ $TESTTYPE == "UCAST_TCP" ]; then
#         echo MAX DISPLAY is ON but BASH_SKT UCAST_TCP>/dev/null
#         buffer1="" # filter it
#      fi
#   elif [ $TAGA_TRAFFIC_GENERATOR == "IPERF" ] ; then
#      echo MAX DISPLAY is ON but IPERF>/dev/null
#      buffer1="" # filter it
#      if [ $TESTTYPE == "MCAST" ]; then
#         echo MAX DISPLAY is ON but IPERF MCAST>/dev/null
#         buffer1="" # filter it
#      elif [ $TESTTYPE == "UCAST_TCP" ]; then
#         echo MAX DISPLAY is ON but IPERF UCAST_TCP>/dev/null
#         #buffer1=""
#      fi
#   elif [ $TESTTYPE == "MCAST" ]; then
#      echo MAX DISPLAY is ON but MGEN MCAST>/dev/null
#      #buffer1=""
#   elif [ $TESTTYPE == "UCAST_TCP" ]; then
#      echo MAX DISPLAY is ON but MGEN UCAST_TCP>/dev/null
#      #buffer1=""
#   fi
#fi

#################
# Display it
#################

# pad the buffer
buflen=`echo $buffer1 | awk '{print length($0)}'`

let ROW_SIZE=82  # Note, this is in two spots
let ROW_SIZE=72  # Note, this is in two spots
let ROW_SIZE=68  # Note, this is in two spots

# If we have something of interest, display it, otherwise print blank line!
if [ $buflen -gt 0 ] ; then
   let padlen=$ROW_SIZE-$buflen
   # add the padding
   let i=$padlen
   while [ $i -gt 0 ];
   do
     buffer1="$buffer1."
     let i=$i-1
   done
   # add the percent at the end of the buffer
   buffer2="$buffer1 ($percent%)"
   # write buffer line to output; write buffer line to counts.txt file
   echo $buffer2 ; echo $buffer2 >> $TAGA_RUN_DIR/counts.txt
else
   echo >/dev/null
fi


#####################################################
# Build the Second Line of the File
#####################################################
#####################################################
# calculate the expected line count
let expectedCount=$MSGCOUNT
let expectedCount2=0
let expectedCount3=0
for target in $targetList
do
   # count the nodes we send our message to
   # check the test type

   # if UCAST, each nodes sends a message to each node, except itself
   # but this expected message count is even valid for the MCAST 
   # since we count on the receive side
   for target2 in $targetList
   do
      #if [ $target2 != $MYIP ]; then
      if [ $target2 != $target ]; then
         let expectedCount2=$expectedCount2+1
      fi
   done

   # accumulate the mcast sends counts
   if [ $TESTTYPE == "MCAST" ]; then
      # if MCAST, we send only one message per all nodes
      let expectedCount3=$expectedCount3+1
   fi

done

if [ $TESTTYPE == "MCAST" ]; then
   let expectedCount=$expectedCount*1
else
   let expectedCount=$expectedCount*2
fi

if [ $TESTTYPE == "MCAST" ]; then
   let expectedCount=$expectedCount*$expectedCount2
   let expectedCount3=$expectedCount3*$MSGCOUNT
   let expectedCount=$expectedCount+$expectedCount3
else
   let expectedCount=$expectedCount*$expectedCount2
fi

let numerator=`cat $outputDir/* 2>/dev/null | wc -l`
let numerator=$numerator*10000
let denominator=$expectedCount
let percent=$numerator/$denominator 2>/dev/null 

let checkValue=$numerator/10000 
if [ $checkValue -eq $denominator ]; then
  percent="100.00"
elif [ $checkValue -gt $denominator ]; then
  percent=`echo $percent | cut -c1-3`.`echo $percent | cut -c4-5`
else
  percent=`echo $percent | cut -c1-2`.`echo $percent | cut -c3-4`
  if [ $percent == "0." ]; then
     percent="0.0"
  fi
fi

# build up the buffer

# dlm temp, 30 apr 2017, this is giving false positives, need to tighten our filter...
# dlm temp, 30 apr 2017, this is giving false positives, need to tighten our filter...
#printCount=`cat $outputDir/*$TEST_DESCRIPTION* 2>/dev/null | wc -l`
printCount=`cat $outputDir/*$TEST_DESCRIPTION* 2>/dev/null | grep "length $MSGLEN" | wc -l`

buffer1="TAGA:Iter:$iter: Tot Files:`ls $outputDir | wc -l` Total Count:$printCount / $expectedCount exp msgs "

if [ $EXPERT_DISPLAY -eq 1 ] ;then
   # Expert display is on
   echo Nothing to Filter since Expert Display has no filters >/dev/null
else
   if [ $MAX_STAT_DISPLAY -eq 0 ] ;then
      echo MAX DISPLAY is OFF >/dev/null
      buffer1=""
   elif [ $TAGA_TRAFFIC_GENERATOR == "BASH_SOCKET" ] ; then
      echo MAX DISPLAY is ON but BASH_SOCKET>/dev/null
      buffer1="" # filter it
      if [ $TESTTYPE == "MCAST" ]; then
         echo MAX DISPLAY is ON but BASH_SKT MCAST>/dev/null
         buffer1="" # filter it
      elif [ $TESTTYPE == "UCAST_TCP" ]; then
         echo MAX DISPLAY is ON but BASH_SKT UCAST_TCP>/dev/null
         buffer1="" # filter it
      fi
   elif [ $TAGA_TRAFFIC_GENERATOR == "IPERF" ] ; then
      echo MAX DISPLAY is ON but IPERF>/dev/null
      buffer1="" # filter it
      if [ $TESTTYPE == "MCAST" ]; then
         echo MAX DISPLAY is ON but IPERF MCAST>/dev/null
         buffer1="" # filter it
      elif [ $TESTTYPE == "UCAST_TCP" ]; then
         echo MAX DISPLAY is ON but IPERF UCAST_TCP>/dev/null
         #buffer1=""
      fi
   elif [ $TESTTYPE == "MCAST" ]; then
      echo MAX DISPLAY is ON but MGEN MCAST>/dev/null
      #buffer1=""
   elif [ $TESTTYPE == "UCAST_TCP" ]; then
      echo MAX DISPLAY is ON but MGEN UCAST_TCP>/dev/null
      #buffer1=""
   fi
fi

#if [ $MAX_STAT_DISPLAY -eq 0 ] ;then
#   echo MAX DISPLAY is OFF >/dev/null
#   buffer1=""
#elif [ $TESTTYPE == "MCAST" ]; then
#   echo MAX DISPLAY is ON but MCAST>/dev/null
#   buffer1=""
#elif [ $TESTTYPE == "UCAST_TCP" ]; then
#   echo MAX DISPLAY is ON but UCAST_TCP>/dev/null
#   #buffer1=""
#elif [ $TAGA_TRAFFIC_GENERATOR == "BASH_SOCKET" ] ; then
#   echo MAX DISPLAY is ON but BASH_SOCKET>/dev/null
#   buffer1=""
#elif [ $TAGA_TRAFFIC_GENERATOR == "IPERF" ] ; then
#   echo MAX DISPLAY is ON but IPERF>/dev/null
#   buffer1=""
#fi


if [ $printCount == $expectedCount ]; then
  mynewpercent="100.00"
elif [ $printCount > $expectedCount ]; then
  let mynewpercent=$printCount*100
  let mynewpercent=$mynewpercent/$expectedCount
  #mynewpercent=`echo $mynewpercent | cut -c1-2`.`echo $mynewpercent | cut -c3-4`
  mynewpercent=`echo $mynewpercent | cut -c1-3`.`echo $mynewpercent | cut -c4-5`
else
  let mynewpercent=$printCount*100
  let mynewpercent=$mynewpercent/$expectedCount
  #mynewpercent=`echo $mynewpercent | cut -c1-3`.`echo $mynewpercent | cut -c4-5`
  mynewpercent=`echo $mynewpercent | cut -c1-2`.`echo $mynewpercent | cut -c3-4`
fi

# pad the buffer
buflen=`echo $buffer1 | awk '{print length($0)}'`

#echo buflen$buflen

let ROW_SIZE=82  # Note, this is in two spots
let ROW_SIZE=72  # Note, this is in two spots
let ROW_SIZE=68  # Note, this is in two spots

# If we have something of interest, display it, otherwise print blank line!
if [ $buflen -gt 0 ] ; then
   let padlen=$ROW_SIZE-$buflen
   # add the padding
   let i=$padlen
   while [ $i -gt 0 ];
   do
     buffer1="$buffer1."
     let i=$i-1
   done
   # add the percent at the end of the buffer
   #buffer2="$buffer1 ($percent%)"
   buffer2="$buffer1 ($mynewpercent%)"

   # write buffer line to output; write buffer line to counts.txt file
   echo $buffer2 ; echo $buffer2 >> $TAGA_RUN_DIR/counts.txt
else
  # we do this once already, so no line needed here
  echo >/dev/null
fi


##################################################################
# PRINT HEADER ROWS
##################################################################
$tagaScriptsStatsDir/printSendersHeader.sh "SENDERS" $iter $startTime $startDTG

###################
# MAIN COUNT/SORT
###################

curcount="xxxx"

let m=0 # index

for target in $targetList
do

  # increment the index
  let m=$m+1
  if [ $m -lt 10 ]; then
    #mprint=0$m
    mprint=" $m"
  else
    mprint="$m."
  fi 

#  row="$mprint. $row"

  # build Row output

  # init the row cumulative
  let row_cumulative=0

  # pad target name as necessary to have nice output
  tgtlen=`echo $target | awk '{print length($0)}'`

  if [ $tgtlen -eq 17 ] ; then
    row="$target $mprint" 
  elif [ $tgtlen -eq 16 ] ; then
    row="$target...$mprint"
  elif [ $tgtlen -eq 15 ] ; then
    row="$target....$mprint"
  elif [ $tgtlen -eq 14 ] ; then
    row="$target.....$mprint"
  elif [ $tgtlen -eq 13 ] ; then
    row="$target......$mprint"
  elif [ $tgtlen -eq 12 ] ; then
    row="$target.......$mprint"
  elif [ $tgtlen -eq 11 ] ; then
    row="$target........$mprint"
  elif [ $tgtlen -eq 10 ] ; then
    row="$target.........$mprint"
  elif [ $tgtlen -eq 9 ] ; then
    row="$target..........$mprint"
  else
    row="$target...........$mprint"
  fi


  # get the sent count for (to) this target
  let rownodeCount=0
  for target2 in $targetList
  do
    if [ $target == $target2 ] ; then
      # skip self
      curcount="xxxx"
    else

      # else get the count for this target
      HOST=`cat $TAGA_CONFIG_DIR/hostsToIps.txt | grep $target\\\. | cut -d"." -f 5`
      #echo HOST:$HOST

      SOURCE_FILE_TAG=$TEST_DESCRIPTION\_$HOST\_*$target\_
      #echo SOURCE:$SOURCE_FILE_TAG

      # make sure we are starting with empty files
      rm /tmp/curcount.txt /tmp/curcount2.txt 2>/dev/null
      touch /tmp/curcount.txt /tmp/curcount2.txt
      
      # write to the curcount.txt file
      cat $SOURCE_FILE_TAG* 2>/dev/null | grep $target\\\. > /tmp/curcount.txt 2>/dev/null

      # mcast or ucast? 
      if [ $TESTTYPE == "MCAST" ]; then
        # MCAST
        target2=$MYMCAST_ADDR
        # dlm temp, changed 29 apr 2017 to support BASH Traffic (no specific source port)
        # dlm temp, changed 29 apr 2017 to support BASH Traffic (no specific source port)
        # dlm temp, consider if we need a GENERATOR_TYPE switch here instead of reducing the filter for all
        # dlm temp, consider if we need a GENERATOR_TYPE switch here instead of reducing the filter for all
        if [ $TAGA_TRAFFIC_GENERATOR == "BASH_SOCKET" ] ; then
           #cat /tmp/curcount.txt  | grep $target2\. | grep $target.$SOURCEPORT > /tmp/curcount2.txt # filter
           cat /tmp/curcount.txt  | grep $target2\. | grep $target. > /tmp/curcount2.txt # filter
        else
           cat /tmp/curcount.txt  | grep $target2\. | grep $target.$SOURCEPORT > /tmp/curcount2.txt # filter
           #cat /tmp/curcount.txt  | grep $target2\. | grep $target. > /tmp/curcount2.txt # filter
        fi
        cat /tmp/curcount2.txt  | grep "length $MSGLEN" > /tmp/curcount.txt  # verify length
        cat /tmp/curcount.txt  > /tmp/curcount2.txt   # copy the output to temp file curcount2.txt
        cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt   # get the count
      elif [ $TESTTYPE == "UCAST_TCP" ]; then
        # UCAST_TCP
        # Note, this UCAST_TCP case is currently the same as the UCAST_UDP case below
        # Note, if this UCAST_TCP case requires special update in the future, similar
        # changes may require a similar block update in the countReceives.sh file
        cat /tmp/curcount.txt  | cut -d">" -f 2-      > /tmp/curcount2.txt  # get receivers only
        cat /tmp/curcount2.txt | grep $target2\\\.      > /tmp/curcount.txt   # remove all except target2 rows
        cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt  # verify length
        cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt   # get the count
      else
        # UCAST_UDP
        cat /tmp/curcount.txt  | cut -d">" -f 2-      > /tmp/curcount2.txt  # get receivers only
        cat /tmp/curcount2.txt | grep $target2\\\.      > /tmp/curcount.txt   # remove all except target2 rows
        cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt  # verify length
        cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt   # get the count
      fi

      # populate curcount from the curcount.txt file
      let curcount=`cat /tmp/curcount.txt`

      # add this count to the cumulative
      let row_cumulative=$row_cumulative+$curcount

      # pad as necessary
      let mycount=$curcount
      if [ $mycount -lt 10 ] ; then
        # pad
        echo 000$curcount > /dev/null
        curcount=000$curcount
      elif [ $mycount -lt 100 ] ; then
        # pad
        echo 00$curcount > /dev/null
        curcount=00$curcount
      elif [ $mycount -lt 1000 ] ; then
        # pad
        echo 0$curcount > /dev/null
        curcount=0$curcount
      else
        # no pad needed
        echo $node > /dev/null
      fi

      if [ -f  $SOURCE_FILE_TAG*$target_ ] ; then
        echo file exists! >/dev/null
      else
        #if echo $BLACKLIST | grep "$target " >/dev/null; then
        if echo $BLACKLIST | grep -e "$target " -e "$target$" >/dev/null; then
           curcount="BLKL"
        else
           curcount="----"
        fi
      fi 2>/dev/null
    fi 
    
    # append count to the row string
    row="$row $curcount"

    # dlm temp scalability stuff
    let rownodeCount=$rownodeCount+1

    if [ $NARROW_DISPLAY -eq 1 ]; then
      let modVal=$rownodeCount%10
    elif [ $WIDE_DISPLAY -eq 1 ]; then
      let modVal=$rownodeCount%50
    else
      let modVal=$rownodeCount%25
    fi

    if  [ $modVal -eq 0 ]; then
        #echo $row
        echo "$row"
        echo "$row" >> $TAGA_RUN_DIR/counts.txt
        echo "$row" >> $TAGA_RUN_DIR/countsSends.txt
        row=".................."
    fi

  done # continue to next target

  row="$row"" "

  if [ $NARROW_DISPLAY -eq 1 ]; then
    let ROW_SIZE=66
    let ROW_SIZE=70
  elif [ $WIDE_DISPLAY -eq 1 ]; then
    let ROW_SIZE=166
  else
    let ROW_SIZE=118
    let ROW_SIZE=138
    let ROW_SIZE=142
  fi

  let rowlen=`echo $row | awk '{print length($0)}'`
  let padlen=$ROW_SIZE-$rowlen

  # add the padding
  let i=$padlen
  while [ $i -gt 0 ];
  do
     row="$row "
     let i=$i-1
  done


  # get the row padding
  let valuelen=`echo $row_cumulative | awk '{print length($0)}'`
  # pad it
  if [ $valuelen -eq 3 ] ; then
     row_cumulative=0$row_cumulative
  elif [ $valuelen -eq 2 ] ; then
     row_cumulative=00$row_cumulative
  elif [ $valuelen -eq 1 ] ; then
     row_cumulative=000$row_cumulative
  else
     echo nothing to pad >/dev/null
  fi

  # append the cumulative row total to the row output
  row="$row $row_cumulative"

#  # increment the index
#  let m=$m+1
#  if [ $m -lt 10 ]; then
#    #mprint=0$m
#    mprint=" $m"
#  else
#    mprint=$m
#  fi 

#  row="$mprint. $row"

  echo "$row"
  echo "$row" >> $TAGA_RUN_DIR/counts.txt
  echo "$row" >> $TAGA_RUN_DIR/countsSends.txt

done

