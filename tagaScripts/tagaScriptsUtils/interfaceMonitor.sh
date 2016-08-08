#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let TX_STATS=`$tagaScriptsStatsDir/adminstats.sh TXonly`
let RX_STATS=`$tagaScriptsStatsDir/adminstats.sh RXonly`
let START_TX_STATS=$TX_STATS
let START_RX_STATS=$RX_STATS

let iter=0

STARTDATE=`date`
START_STATS=`$tagaScriptsStatsDir/adminstats.sh` 

while true
do

   let iter=$iter+1

   CURRENTDATE=`date`
   CURRENT_STATS=`$tagaScriptsStatsDir/adminstats.sh`

   echo
   echo $MYIP
   echo $CURRENTDATE
   #echo $MYIP: START DTG: $STARTDATE  CURRENT DTG: $CURRENTDATE
   echo START DTG: $STARTDATE  CURRENT DTG: $CURRENTDATE
   echo "TAGA:Iter:$iter ITFC START: $START_STATS"
   echo "TAGA:Iter:$iter ITFC CURRENT: $CURRENT_STATS"

   let TX_STATS=`$tagaScriptsStatsDir/adminstats.sh TXonly`
   let RX_STATS=`$tagaScriptsStatsDir/adminstats.sh RXonly`
   let CURRENT_TX_STATS=$TX_STATS
   let CURRENT_RX_STATS=$RX_STATS
   let DELTA_TX_STATS=$CURRENT_TX_STATS-$START_TX_STATS
   let DELTA_RX_STATS=$CURRENT_RX_STATS-$START_RX_STATS

# GitHub Note: Consider refactoring the below four big blocks into a single script file
# .. several input params will be required

   wordlen=`echo $DELTA_RX_STATS | awk '{print length($0)}'`

   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($megabytePrint MB RX)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($megabytePrint MB RX)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($kilobytePrint KB RX)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($kilobytePrint KB RX)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_RX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS ($kilobytePrint KB RX)"
   else
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS" 
   fi

   wordlen=`echo $DELTA_TX_STATS | awk '{print length($0)}'`

   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($megabytePrint MB TX)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($megabytePrint MB TX)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($kilobytePrint KB TX)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($kilobytePrint KB TX)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_TX_STATS*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS ($kilobytePrint KB TX)"
   else
      echo "TAGA:Iter:$iter DELTA_TX_STATS:      $DELTA_TX_STATS" 
   fi

   let DELTA_RX_STATS_ITER=$DELTA_RX_STATS/$iter

   wordlen=`echo $DELTA_RX_STATS_ITER | awk '{print length($0)}'`
   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($megabytePrint MB RX per 5sec Iter\)
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($megabytePrint MB RX per 5sec Iter\)
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      #let kilobitPrint=$kilobytePrint*8 
      #let kilobitPrint=$kilobitPrint*8 
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/5000 # five secs, 5000 ms,  per iteration
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\) \($kilobitPrint kbps RX\)
      #echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobitPrint kbps RX\)
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      #let kilobitPrint=$kilobytePrint*8 
      #let kilobitPrint=$kilobytePrint
      #let kilobitPrint=$kilobitPrint*8 
      #let kilobitPrint=$KBytes*8
      #let kilobitPrint=$DELTA_RX_STATS_ITER*8
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\) \($kilobitPrint kbps RX\)
      #echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\)
      #echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobitPrint kbps RX\)
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      #let kilobitPrint=$kilobytePrint*8 
      #let kilobitPrint=$kilobytePrint
      #let kilobitPrint=$kilobitPrint*8 
      #let kilobitPrint=$KBytes*8
      #let kilobitPrint=$DELTA_RX_STATS_ITER*8
      let kilobitPrint=$DELTA_RX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\) \($kilobitPrint kbps RX\)
      #echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\)
      #echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobitPrint kbps RX\)
   else
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER
   fi

   let DELTA_TX_STATS_ITER=$DELTA_TX_STATS/$iter

   wordlen=`echo $DELTA_TX_STATS_ITER | awk '{print length($0)}'`
   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($megabytePrint MB TX per 5sec Iter)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($megabytePrint MB TX per 5sec Iter)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      #let kilobitPrint=$kilobytePrint*8 
      #let kilobitPrint=$kilobytePrint
      #let kilobitPrint=$kilobitPrint*8 
      #let kilobitPrint=$KBytes*8
      #let kilobitPrint=$DELTA_RX_STATS_ITER*8
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\) \($kilobitPrint kbps TX\)
      #echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per 5sec Iter)"
      #echo TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER \($kilobitPrint kbps TX\)
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      #let kilobitPrint=$kilobytePrint*8 
      #let kilobitPrint=$kilobytePrint
      #let kilobitPrint=$kilobitPrint*8 
      #let kilobitPrint=$KBytes*8
      #let kilobitPrint=$DELTA_RX_STATS_ITER*8
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\) \($kilobitPrint kbps TX\)
      #echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per 5sec Iter)"
      #echo TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER \($kilobitPrint kbps TX\)
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      #let kilobitPrint=$kilobytePrint*8 
      #let kilobitPrint=$kilobytePrint
      #let kilobitPrint=$kilobitPrint*8 
      #let kilobitPrint=$KBytes*8
      #let kilobitPrint=$DELTA_RX_STATS_ITER*8
      let kilobitPrint=$DELTA_TX_STATS_ITER*8 # convert to bits
      let kilobitPrint=$kilobitPrint/5000 # five secs , 5000 ms, per iteration
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per 5sec Iter\) \($kilobitPrint kbps TX\)
      #echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per 5sec Iter)"
      #echo TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER \($kilobitPrint kbps TX\)
   else
      echo TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER
   fi

   sleep 5

done



