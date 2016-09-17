#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

echo; echo $0 : Initializing...; echo

# this provides our inter-process comms, 
# it is not bullet proof, but better than nothing...
#clear the reboot in progress flag
#rm /tmp/rebootInProgress.dat


echo 0

rm $NET_RESET_IN_PROG_FLAG_FILE 2> /dev/null
echo 0a
rm $TAGA_LOCAL_MODE_FLAG_FILE 2> /dev/null
echo 0b


# dlm temp, changed 16 sept 2016
# dlm temp, changed 16 sept 2016
# dlm temp, changed 16 sept 2016
# remove old *.dat and mark* files
#sudo chmod 777 /tmp/*.dat
#rm /tmp/*.dat 2>/dev/null
sudo chmod 777 /tmp/*taga*.dat 2>/dev/null
rm /tmp/*taga*.dat 2>/dev/null
echo 0c

rm /tmp/mark* 2>/dev/null

echo 0d

# clean old /tmp/tagaRun* files from all targets
# TODO!!

# remove old in progress flag if it exists
rm /tmp/startOfCycleTests.sh.InProgress.dat 2>/dev/null

echo 1

# basic sanity check, to ensure password updated etc
$tagaScriptsUtilsDir/basicSanityCheck.sh
if [ $? -eq 255 ]; then
  echo Basic Sanith Check Failed - see warning above - $0 Exiting...
  echo
  exit 255
fi

echo 1a

# dlm temp
# Force checks to get the password entry out of the way...
# dlm temp remove this if not necessary!!!
# dlm temp remove this if not necessary!!!
# dlm temp remove this if not necessary!!!
#$TAGA_UTILS_DIR/checkInterface.sh "forceChecks"

#exit

START_STATS=`$tagaScriptsStatsDir/adminstats.sh` 
let TX_STATS=`$tagaScriptsStatsDir/adminstats.sh TXonly`
let RX_STATS=`$tagaScriptsStatsDir/adminstats.sh RXonly`
let START_TX_STATS=$TX_STATS
let START_RX_STATS=$RX_STATS
#echo TX_STATS:$TX_STATS
#echo RX_STATS:$RX_STATS


# Do this to get the password entry out of the way
# dlm temp remove this if not necessary!!!
# dlm temp remove this if not necessary!!!
# dlm temp remove this if not necessary!!!
#$TAGA_UTILS_DIR/resetInterface.sh

echo 1b

#########################################
# Update the MASTER entry in the config
#########################################
# strip old MASTER entries and blank lines at end of file
cat $TAGA_CONFIG_DIR/config | sed -e s/^MASTER=.*$//g |     \
      sed -e :a -e '/./,$!d;/^\n*$/{$d;N;;};/\n$/ba' \
           > $TAGA_CONFIG_DIR/tmp.config
# move temp to config
mv $TAGA_CONFIG_DIR/tmp.config $TAGA_CONFIG_DIR/config
# Update the MASTER entry in the config
echo MASTER=$MYIP >> $TAGA_CONFIG_DIR/config
#########################################
# DONE Update the MASTER entry in the config
#########################################

# set the flag in the flag file
echo $ENVIRON_SIMULATION > /tmp/simulationFlag.txt

# source again due to above as well as other boot strap-like dependencies
# note, this may not be necessary and is candidate to investigate 
source $TAGA_CONFIG_DIR/config

echo 1c

echo;echo
if [ $TESTONLY -eq 1 ] ; then
  # use the testing directory for testing
  echo NOTE: Config file is configured for TESTONLY!!
  echo NOTE: Output Dir is NOT being Archived!!
else
  # use the archive directory for archiving
  echo NOTE: Config file is configured for ARCHIVING.
  echo NOTE: Output Dir IS being Archived!!
fi 

sleep 1

echo
#echo;echo
#echo $0 initializing....  please be patient...
#echo;echo

# check time synch if enabled
if [ $TIME_SYNCH_CHECK_ENABLED -eq 1 ]; then
  $tagaScriptsTimerDir/timeSynchCheck.sh
fi

#echo 1d

# probe if enabled
if [ $PROBE_ENABLED -eq 1 ]; then
  $tagaScriptsUtilsDir/probe.sh
fi

# get ping times if enabled
#if [ $PING_TIME_CHECK_ENABLED -eq 1 ]; then
#  $tagaScriptsUtilsDir/pingTimes.sh
#fi

# get resource usage if enabled
if [ $RESOURCE_MON_ENABLED -eq 1 ]; then
  $tagaScriptsUtilsDir/wrapResourceUsage.sh
fi
sleep 1


# stop the Simulation Always 
if [ true ] ; then
  $tagaScriptsStopDir/stopXXX.sh
fi

# stop the Simulation and Data Generation in case it is still running somewhere
# use alt list which is used at run begin only and includes interfaceMonitor and keepAlive process
$tagaScriptsStopDir/runStop.sh "useAltList"

let iter=0
let k=0
startTime="`date +%T`"
startDTG="`date`"
startEpoch=`date +%s`

# five iterations to converge
let beforeLastLastLastAvgDelta=0
let beforeLastLastAvgDelta=0
let beforeLastAvgDelta=0
let lastAvgDelta=0
let currentAvgDelta=0

let lastEpoch=0

LAST_CONVERGED="Not Yet Converged"

printableDeltaCum=""
printableAverageDeltaCum=""

# flag to indicate if we have reset the net
let resetflag=0

while true
do

   # get a fresh config
   source $TAGA_CONFIG_DIR/config

   # Increment the iterator
   let iter=$iter+1

   echo
   echo =================================================================
   echo TAGA:Iter:$iter:PreTrafficPhase: Iteration $iter Begin  
   echo =================================================================

   # this provides our inter-process comms, 
   # it is not bullet proof, but better than nothing...
   #clear the reboot in progress flag
   rm $NET_RESET_IN_PROG_FLAG_FILE 2> /dev/null

   let k=$k+1


   # new 15 jan 2016
   # Update the MASTER entry in the config
   # strip old MASTER entries and blank lines at end of file
   cat $TAGA_CONFIG_DIR/config | sed -e s/^MASTER=.*$//g |     \
         sed -e :a -e '/./,$!d;/^\n*$/{$d;N;;};/\n$/ba' \
             > $TAGA_CONFIG_DIR/tmp.config
   mv $TAGA_CONFIG_DIR/tmp.config $TAGA_CONFIG_DIR/config

   # Update the MASTER entry in the config
   echo MASTER=$MYIP >> $TAGA_CONFIG_DIR/config
   echo $ENVIRON_SIMULATION > /tmp/simulationFlag.txt

   # get the config again in case it has changed
   source $TAGA_CONFIG_DIR/config

   while [ $ALL_TESTS_DISABLED -eq 1 ] 
   do
      # refresh the flag to check again
      source $TAGA_CONFIG_DIR/config
      echo
      echo TAGA:PreTrafficPhase: `date` Main Test Loop Disabled ............
      sleep 5
   done

   while [ $iter -gt $MAX_ITERATIONS ] 
   do
      # refresh config in case it has changed
      source $TAGA_CONFIG_DIR/config

      if [ $EXIT_ON_MAX_ITERATIONS -eq 1 ] ; then
         echo; echo TAGA:PreTrafficPhase: `date` Max Iterations \($MAX_ITERATIONS\) Reached - Exiting ..........
         exit
      else
         echo; echo TAGA:PreTrafficPhase: `date` Max Iterations \($MAX_ITERATIONS\) Reached - Disabling ............
      fi
      sleep 5

   done

   if [ $STEPWISE_ITERATIONS -eq 1 ]; then
      echo; echo INFO: Step-wise iterations configured...
      echo `date` 
      echo Iterations \($iter\) Reached - Waiting confirmation to proceed
      echo; echo Press \[Enter\] to proceed...
      read input 
   elif [ $STEPWISE_ITERATIONS -ne 0 ]; then
      let modVal=$iter%$STEPWISE_ITERATIONS
      if [ $modVal -eq 0 ]; then 
         echo; echo INFO: Double Iteration Step-wise iterations configured...
         echo `date` 
         echo Iterations \($iter\) Reached - Waiting confirmation to proceed
         echo; echo Press \[Enter\] to proceed...
         read input 
      fi
   fi

   # Increment the iterator
   #let iter=$iter+1

   echo
   echo TAGA:PreTrafficPhase: `date` Main Test Loop Enabled ............

   # check time synch if enabled
   if [ $TIME_SYNCH_CHECK_ENABLED -eq 1 ]; then
     $tagaScriptsTimerDir/timeSynchCheck.sh
   fi

   # probe if enabled
   if [ $PROBE_ENABLED -eq 1 ]; then
     $tagaScriptsUtilsDir/probe.sh
   fi

   # get ping times if enabled
   if [ $PING_TIME_CHECK_ENABLED -eq 1 ]; then
     $tagaScriptsUtilsDir/pingTimes.sh
   fi

   # get resource usage if enabled
   if [ $RESOURCE_MON_ENABLED -eq 1 ]; then
      let mod=$k%$RESOURCE_DISPLAY_MODULUS
      if [ $mod -eq 0 ] ; then
        echo k:$k
        $tagaScriptsUtilsDir/wrapResourceUsage.sh
      fi
   fi



   # exit now if simulation only
   if [ $SIMULATION_ONLY -eq 1 ]; then
      echo TAGA:PreTrafficPhase: `date` Simulation Only Flag is True
      echo TAGA:PreTrafficPhase: `date` Background Traffic is Disabled ............
   fi


   echo
   echo TAGA:PreTrafficPhase: `date` Regenerating HostToIpMap File ............

   # build the map each iteration
   $tagaScriptsUtilsDir/createHostToIpMap.sh

   #echo `date` Regenerating HostToIpMap File ............ DONE
   echo


   # resource the config in case it has changed
   source $TAGA_CONFIG_DIR/config 


   if [ $CONTINUOUS_SYNCH -eq 1 ]; then
     # synch everything 
     $tagaScriptsUtilsDir/synch.sh
   else
     # synch config only
     if [ $CONFIG_SYNCH_DISABLED -ne 1 ]; then
         if [ $TAGA_DISPLAY_SETTING -gt $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
            echo TAGA:PreTrafficPhase: Notice: Config Synch is Enabled.
            let MANAGED_EXECUTE_WAIT_TIME=$MANAGED_WAIT_FACTOR*$TARGET_COUNT
            let MANAGED_EXECUTE_WAIT_TIME=$MANAGED_EXECUTE_WAIT_TIME*2
            $tagaScriptsUtilsDir/managedExecute.sh -t $MANAGED_EXECUTE_WAIT_TIME \
                       $tagaScriptsUtilsDir/synchConfig.sh

            if [ $? -ne 0 ] ; then
               # not okay
               echo $? is mangedExecuteReturnCode
               echo WARNING: Config did not synch!
               echo NOTICE: Please perform manual Config Synch!
               echo NOTICE:   i.e.  ~/scripts/taga/tagaConfig/synchme.sh
            else
               # okay
               echo $? is mangedExecuteReturnCode > /dev/null
            fi

         else
            # suppress output to stdout
            $tagaScriptsUtilsDir/managedExecute.sh $tagaScriptsUtilsDir/synchConfig.sh
            echo $? is mangedExecuteReturnCode
        fi
   
     else
        echo TAGA:PreTrafficPhase: Notice: Config Synch is Disabled!  
        echo TAGA:PreTrafficPhase: Notice: Please, ensure no config changes require distribution.
     fi
   fi

   # baseline the aggregate log file
   cp /tmp/runLoop.sh.out /tmp/runLoop.sh.out.before

   # temp/test directory
   mkdir -p $OUTPUT_DIR

   # archive directory
   outputDir=$OUTPUT_DIR/output_`date +%j%H%M%S` 

   echo $0 : Creating Output Dir: $outputDir
   mkdir -p $outputDir

   # start the Simulation 
   if [ $START_SIMULATION -eq 1 ] ; then

     # Init the sims (cleanup old files/sockets)
     $tagaScriptsSimDir/simulateInit.sh

     # Init the selected sims (cleanup old files/sockets)
     # XXX RUN SCRIPT
     if [ $XXX_ON -eq 1 ]; then
       $tagaScriptsRunDir/runXXX.sh
     fi
   fi

   # check/repair the interface
#   $TAGA_UTILS_DIR/checkInterface.sh

   # if first iteration, use special flag to also start keepAlive processes
   if [ $iter -eq 1 ] ; then
     # MAIN RUN SCRIPT (primary sim server and traffic)
     $tagaScriptsRunDir/run.sh "iteration1Flag"
   else
     # MAIN RUN SCRIPT (primary sim server and traffic)
     $tagaScriptsRunDir/run.sh  
   fi

   # Start of cycle tests
   #sleep $SERVER_INIT_DELAY
   let i=$SERVER_INIT_DELAY/2
   while [ $i -gt 0 ]; 
   do
      let i=$i-1
      echo TAGA:PreTrafficPhase: Servers Initializing.... $i
      sleep 2
   done

   echo TAGA:PreTrafficPhase: Pre-Traffic Phase complete! 
   echo
   echo TAGA:TrafficPhase: Traffic Phase Beginning...
   #echo

   # dlm temp find me

   # for some reason this file is not being created by script below 
   # so create it here instead
   echo 1 > /tmp/startOfCycleTests.sh.InProgress.dat 

   # dlm temp, 6 sept 2016 output start of cycle tests to log file
   #$tagaScriptsTestDir/startOfCycleTests.sh $iter $TEST_LABEL & # run in background/parallel
   $tagaScriptsTestDir/startOfCycleTests.sh $iter $TEST_LABEL > /tmp/startOfCycleTests.$iter.out & # run in background/parallel

   # check/repair the interface
#   $TAGA_UTILS_DIR/checkInterface.sh

   let i=$DURATION1

   #echo DLM TMP: i:  $i

   while [ $i -gt 0 ]
   do
      let tot=$DURATION2+$i

      #echo DLM TMP 11111: i:  $i

      #SECS_REMAINING_STR="TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i"
      #SECS_REMAINING_STR="TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i"
      SECS_REMAINING_STR="TAGA:TrafficPhase: Secs Remain Part 1: $i : Secs Remain Total: $tot"

      if [ $tot -gt 1000 ]; then
         let modVal=$tot%50
         if [ $modVal -eq 0 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
         elif [ $i -lt 50 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
         fi
      elif [ $tot -gt 100 ]; then
         let modVal=$tot%10
         if [ $modVal -eq 0 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
         elif [ $i -lt 10 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
         fi
      elif [ $tot -gt 10 ]; then
         let modVal=$tot%5
         if [ $modVal -eq 0 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
         elif [ $i -lt 5 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
         fi
      else
         echo $SECS_REMAINING_STR
         #echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 1: $i
      fi

      #echo DLM TMP 11111aaaaaa: i:  $i

      sleep 1
      let i=$i-1

      #echo DLM TMP 2222: i:  $i

   done

   # Mid cycle tests
   $tagaScriptsTestDir/midCycleTests.sh & # run in background/parallel

   # check/repair the interface
#   $TAGA_UTILS_DIR/checkInterface.sh

   # run the variable test
   $tagaScriptsTestDir/$VARIABLE_TEST
   #echo TAGA: Executing variable test..... $VARIABLE_TEST

   let i=$DURATION2
   while [ $i -gt 0 ]
   do

      let tot=$i

      #SECS_REMAINING_STR="TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i"
      SECS_REMAINING_STR="TAGA:TrafficPhase: Secs Remain Part 2: $i : Secs Remain Total: $tot"

      if [ $tot -gt 1000 ]; then
         let modVal=$tot%50
         if [ $modVal -eq 0 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i
         elif [ $i -lt 50 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i
         fi
      elif [ $tot -gt 100 ]; then
         let modVal=$tot%10
         if [ $modVal -eq 0 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i
         elif [ $i -lt 10 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i
         fi
      elif [ $tot -gt 10 ]; then
         let modVal=$tot%5
         if [ $modVal -eq 0 ]; then
            echo $SECS_REMAINING_STR
         #   echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i
         fi
      else
         echo $SECS_REMAINING_STR
         #echo TAGA:TrafficPhase: Total Secs Remain: $tot : Secs Remain Part 2: $i
      fi

#      echo Total Secs Remain: $tot : Secs Remain Part 2: $i

      sleep 1
      let i=$i-1

   done


   #####################################################
   # DURATION3, this is expected to be 0 time but is provided for contingency
   #####################################################

   echo TAGA:TrafficPhase: Traffic Phase complete! 
   echo
   echo TAGA:PostTrafficPhase: Beginning...

   #sleep $DURATION3

   let i=$DURATION3
   while [ $i -gt 0 ]
   do
      SECS_REMAINING_STR="TAGA:PostTrafficPhase: Additional Delay Secs Remain Part 3: $i "
      echo $SECS_REMAINING_STR
      sleep 1
      let i=$i-1
   done


   #####################################################
   # Wait for Start of Cycle Tests to Complete
   # dlm temp new July 2016
   #####################################################

   if [ $START_OF_CYCLE_TESTS_ENABLED == 1 ]; then
      let i=0
      while [ -f /tmp/startOfCycleTests.sh.InProgress.dat ]
      do
         SECS_WAITING_STR="TAGA:PostTrafficPhase: Waiting for Start of Cycle Test To Complete! $i "
         echo $SECS_WAITING_STR
         let i=$i+1
         sleep 1
      done
   fi


   #####################################################
   # Client-Side Test Stimulations
   #####################################################

   # End of cycle tests
   $tagaScriptsTestDir/endOfCycleTests.sh
   $tagaScriptsTestDir/endOfCycleTests2.sh
   $tagaScriptsTestDir/endOfCycleTests3.sh

   #####################################################
   # Client-Side Specialized Test Stimulations
   #####################################################

   # check/repair the interface
#   $TAGA_UTILS_DIR/checkInterface.sh

   if [ $XXX_ON -eq 1 ]; then
     $tagaScriptsTestDir/testXXX.sh
   fi

   sleep 1

   # stop the Simulation each iteration 
   if [ $STOP_SIMULATION -eq 1 ] ; then
      $tagaScriptsStopDir/stopXXX.sh
   fi



   # dlm temp, new, 7 sept 2016

   if [ $EARLY_COLLECT -eq 1 ] ; then

      echo Early Collection is Enabled, collecting data now...

      # collect and clean
      # dlm temp , new 6 sept 2016, make directory in case it does not yet exist
      mkdir -p $outputDir 2>/dev/null
      echo $tagaScriptsUtilsDir/collect.sh $outputDir > /tmp/managedRunLoopCollect.sh
      chmod 755 /tmp/managedRunLoopCollect.sh
      # double the managedExecute timeout since this can take awhile...
      let MANAGED_WAIT_TIME=$MANAGED_WAIT_FACTOR*$TARGET_COUNT
      let MANAGED_WAIT_TIME=$MANAGED_WAIT_TIME*2
      #$tagaScriptsUtilsDir/managedExecute.sh -t 20 /tmp/managedRunLoopCollect.sh
      $tagaScriptsUtilsDir/managedExecute.sh -t $MANAGED_WAIT_TIME /tmp/managedRunLoopCollect.sh

      # now, stop the Remaining Simulation and Data Generation
      $tagaScriptsStopDir/runStop.sh

   else

      echo Early Collection is Disabled, collecting data after stopping processes...

      if [ $TAGA_TURBO_MODE -eq 1 ] ; then
         # stop processes in uncontrolled manner ( in the background)
         # stop the Remaining Simulation and Data Generation
         $tagaScriptsStopDir/runStop.sh &
      else
         # stop processes in controlled manner ( in the foreground)
         # stop the Remaining Simulation and Data Generation
         $tagaScriptsStopDir/runStop.sh
      fi

      # collect and clean
      # dlm temp , new 6 sept 2016, make directory in case it does not yet exist
      mkdir -p $outputDir 2>/dev/null
      echo $tagaScriptsUtilsDir/collect.sh $outputDir > /tmp/managedRunLoopCollect.sh
      chmod 755 /tmp/managedRunLoopCollect.sh
      # double the managedExecute timeout since this can take awhile...
      let MANAGED_WAIT_TIME=$MANAGED_WAIT_FACTOR*$TARGET_COUNT
      let MANAGED_WAIT_TIME=$MANAGED_WAIT_TIME*2
      #$tagaScriptsUtilsDir/managedExecute.sh -t 20 /tmp/managedRunLoopCollect.sh
      $tagaScriptsUtilsDir/managedExecute.sh -t $MANAGED_WAIT_TIME /tmp/managedRunLoopCollect.sh
   fi

   echo $tagaScriptsUtilsDir/cleanAll.sh $outputDir > /tmp/managedRunLoopCleanAll.sh 
   chmod 755 /tmp/managedRunLoopCleanAll.sh
   # double the managedExecute timeout since it is called inside also
   let MANAGED_WAIT_TIME=$MANAGED_WAIT_FACTOR*$TARGET_COUNT
   #$tagaScriptsUtilsDir/managedExecute.sh -t 20 /tmp/managedRunLoopCleanAll.sh
   $tagaScriptsUtilsDir/managedExecute.sh -t $MANAGED_WAIT_TIME /tmp/managedRunLoopCleanAll.sh

   # check/repair the interface
#   $TAGA_UTILS_DIR/checkInterface.sh

   # remove old and put current data in generic output directory
   rm -rf $OUTPUT_DIR/output
   cp -r $outputDir $OUTPUT_DIR/output

   currentEpoch=`date +%s`

   let currentDelta=$currentEpoch-$lastEpoch
   let lastEpoch=$currentEpoch
   let deltaEpoch=$currentEpoch-$startEpoch


#   #############################################
#   # Recover Net if Necessary
#   #############################################
#   #if [ $currentDelta -ge 200 ]; then
#   if [ $currentDelta -ge 150 ]; then
#      echo Network is in a bad state... 
#      echo Attempting to Recover Network....
#
#      $TAGA_UTILS_DIR/recoverNet.sh &
#
#      echo Suspending while the network recovers...  
#      $IBOA_UTILS_DIR/iboaDelay.sh 150 5
#      echo Continuing....
#   fi
#   #############################################
#   # End Recover Net if Necessary
#   #############################################
   

   # special handling for iteration 1
   if [ $iter -eq 1 ]; then
      # use the delta epoch instead of current delta
      printableDeltaCum="$printableDeltaCum D: $deltaEpoch "
      printableAverageDeltaCum="$printableAverageDeltaCum A: "
   else 
      printableDeltaCum="$printableDeltaCum $currentDelta"
      printableAverageDeltaCum="$printableAverageDeltaCum $currentAvgDelta"
   fi

   #############################################################
   # create the log dir
   #############################################################
   mkdir -p $LOG_DIR
   mkdir -p $DATA_DIR

   #############################################################
   # Print to the Delta Cumlative Log File
   #############################################################

   # make the log dir
   mkdir -p $LOG_DIR

   # expert displsy to standard output?
   if [ $TAGA_DISPLAY_EXPERT -eq 1 ] ; then 
     echo; echo TAGA: Convergence:
     echo $printableDeltaCum
     echo $printableAverageDeltaCum
     echo
   fi
   # expert displsy always to expertDisplay.dat file
   echo; echo TAGA: Convergence:         >> /tmp/expertDisplay.dat
   echo $printableDeltaCum         >> /tmp/expertDisplay.dat
   echo $printableAverageDeltaCum  >> /tmp/expertDisplay.dat
   echo

   # stats output
   echo $printableDeltaCum > /tmp/deltaCum.out
   echo $printableDeltaCum > $LOG_DIR/deltaCum.out
   echo $printableDeltaCum > $LOG_DIR/_deltaCum.out
   echo $printableDeltaCum > $LOG_DIR/d_deltaCum.out
   echo $printableDeltaCum > /tmp/both.out
   echo $printableDeltaCum > $LOG_DIR/both.out


   #############################################################
   # Print to the Average Delta Cumlative Log File
   #############################################################

   echo $printableAverageDeltaCum > /tmp/averageDeltaCum.out
   echo $printableAverageDeltaCum > $LOG_DIR/averageDeltaCum.out
   echo $printableAverageDeltaCum > $LOG_DIR/_averageDeltaCum.out
   echo $printableAverageDeltaCum > $LOG_DIR/d_averageDeltaCum.out
   echo $printableAverageDeltaCum >> /tmp/both.out
   echo $printableAverageDeltaCum >> $LOG_DIR/both.out


   #these are really avgs not deltas
   let beforeLastLastLastAvgDelta=$beforeLastLastAvgDelta
   let beforeLastLastAvgDelta=$beforeLastAvgDelta
   let beforeLastAvgDelta=$lastAvgDelta
   let lastAvgDelta=$currentAvgDelta
   let currentAvgDelta=$deltaEpoch/$iter

   # add if converged check here

   if [ $beforeLastLastLastAvgDelta -eq $beforeLastLastAvgDelta ] ; then
   if [ $beforeLastLastAvgDelta -eq $beforeLastAvgDelta ] ; then
   if [ $beforeLastAvgDelta -eq $lastAvgDelta ] ; then
      if [ $beforeLastAvgDelta -eq $currentAvgDelta ] ; then
          echo TAGA: Converged: $currentAvgDelta has converged 
          echo TAGA: Converged: $currentAvgDelta has converged >> $TAGA_RUN_DIR/counts.txt
          # store it
          LAST_CONVERGED=$currentAvgDelta
      else
         echo TAGA: Not Converged marker 1 >/dev/null
      fi
    else
      echo TAGA: Not Converged marker 2 >/dev/null
   fi
   fi
   fi

   echo TAGA: LastConverged: $LAST_CONVERGED >> $TAGA_RUN_DIR/counts.txt

   # new header
   echo `date` LastConverged: $LAST_CONVERGED >> $TAGA_RUN_DIR/counts.txt

   # count and sort and display results matrix
   # note, startDTG must be last param since includes spaces

   if [ $COUNTS_DISABLED -eq 1 ]; then
      echo Counts Disabled, Skipping countSends and countReceives scripts
   elif [ $SENT_COUNTS_DISABLED -eq 1 ]; then
      echo Sent Counts Disabled, Skipping countSends scripts
      $tagaScriptsStatsDir/countReceives.sh $outputDir $iter $startTime $startDTG 
   else
      $tagaScriptsStatsDir/countSends.sh $outputDir $iter $startTime $currentDelta $deltaEpoch $startDTG
      $tagaScriptsStatsDir/countReceives.sh $outputDir $iter $startTime $startDTG 
   fi


   for i in 1 2 #3 4 5 6 # 7 8 9 10 11
   do
      let ticker=6-$i
      echo TAGA: Configuration Change Window: Change Configuration Now... $ticker
      sleep 2
   done

   CURRENT_STATS=`$tagaScriptsStatsDir/adminstats.sh`

   echo
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
      echo "TAGA:Iter:$iter DELTA_RX_STATS:      $DELTA_RX_STATS \($megabytePrint MB RX\)"
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
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($megabytePrint MB RX per Iter\)
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($megabytePrint MB RX per Iter\)
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per Iter\)
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per Iter\)
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_RX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER \($kilobytePrint KB RX per Iter\)
   else
      echo TAGA:Iter:$iter DELTA_RX_STATS_ITER: $DELTA_RX_STATS_ITER
   fi

   let DELTA_TX_STATS_ITER=$DELTA_TX_STATS/$iter

   wordlen=`echo $DELTA_TX_STATS_ITER | awk '{print length($0)}'`
   if [ $wordlen -eq 8 ]; then
      let MBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1-2`.`echo $MBytes | cut -c3`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($megabytePrint MB TX per Iter)"
   elif [ $wordlen -eq 7 ]; then
      let MBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let MBytes=$MBytes/1000000
      megabytePrint=`echo $MBytes | cut -c1`.`echo $MBytes | cut -c2`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($megabytePrint MB TX per Iter)"
   elif [ $wordlen -eq 6 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-3`.`echo $KBytes | cut -c4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per Iter)"
   elif [ $wordlen -eq 5 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1-2`.`echo $KBytes | cut -c3-4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per Iter)"
   elif [ $wordlen -eq 4 ]; then
      let KBytes=$DELTA_TX_STATS_ITER*10 # multiply by 10 to get fraction
      let KBytes=$KBytes/1000
      kilobytePrint=`echo $KBytes | cut -c1`.`echo $KBytes | cut -c2-4`
      echo "TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER ($kilobytePrint KB TX per Iter)"
   else
      echo TAGA:Iter:$iter DELTA_TX_STATS_ITER: $DELTA_TX_STATS_ITER
   fi

   sleep 2

   # move output to the archive
   mv $TAGA_RUN_DIR/output/output_* $TAGA_DIR/archive 2>/dev/null

   # re-baseline the aggregate log file
   cp /tmp/runLoop.sh.out /tmp/runLoop.sh.out.after

   # create output specific to this iteration from the two baseline files
   diff /tmp/runLoop.sh.out.before /tmp/runLoop.sh.out.after | cut -c3- > /tmp/runLoop.sh.out.iter

   # sleep end of iteration delay time
   
   # End of Iteration Delay
   if [ $TAGA_DISPLAY_SETTING -gt $TAGA_DISPLAY_ENUM_VAL_1_SILENT ]; then
     $iboaUtilsDir/iboaDelay.sh $END_OF_ITER_DELAY $END_OF_ITER_DELAY_PRINT_MODULUS
   else
     sleep $END_OF_ITER_DELAY 
   fi


   #############################################
   # Recover Net if Necessary
   #############################################
   if [ $currentDelta -ge $MAX_ITER_DUR_BEFORE_REBOOT ]; then
      # don't do it on first iter
      if [ $iter -ge 2 ] ; then
      # if we recovered net already, don't do it twice in a row
      if [ $resetflag -eq 1 ]; then
         # reset the flag
         let resetflag=0
      else

         echo TAGA: Notice: Network is in a bad state... 
         echo TAGA: Notice: Attempting to Recover Network....

         # this provides our inter-process comms, 
         # it is not bullet proof, but better than nothing...
         #echo 1 > /tmp/rebootInProgress.dat
         echo 1 > $NET_RESET_IN_PROG_FLAG_FILE

         $TAGA_UTILS_DIR/recoverNet.sh "doNotResetInterface" &

         echo TAGA: Suspending while the network recovers...  
         $IBOA_UTILS_DIR/iboaDelay.sh 150 5

         # this provides our inter-process comms, 
         # it is not bullet proof, but better than nothing...
         #clear the reboot in progress flag
         #rm /tmp/rebootInProgress.dat
         #rm $NET_RESET_IN_PROG_FLAG_FILE
         rm $NET_RESET_IN_PROG_FLAG_FILE 2> /dev/null

         # set the flag so we don't reboot next iteration
         let resetflag=1

         echo TAGA: Continuing....

      fi
      fi
   else
      # reset the flag
      let resetflag=0
   fi
   #############################################
   # End Recover Net if Necessary
   #############################################

   echo
   echo =================================================================
   echo TAGA:Iter:$iter:PostTrafficPhase: Iteration $iter Complete
   echo =================================================================
   echo

   #echo TAGA:PreTrafficPhase: `date` Main Test Loop Enabled ............

   # check/repair the interface
#   $TAGA_UTILS_DIR/checkInterface.sh

done

