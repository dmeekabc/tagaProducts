#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# get the md5sum of the targetlist config so we know if it changes
configMd5sum=`md5sum $TAGA_CONFIG_DIR/targetList.sh | cut -d" " -f 1`

echo; echo `basename $0` : $MYIP :  executing at `date`; echo

# set the flag to enter the loop
let configChanged=1

# loop while config continues to change
while [ $configChanged -eq 1 ]
do

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 


   if echo $BLACKLIST | grep $target >/dev/null ; then
      echo The $target is in the black list, skipping...
      continue
   fi

   # do not use ssh or scp if target == MYIP and local mode flag set
   if cat $TAGA_LOCAL_MODE_FLAG_FILE 2>/dev/null | grep 1 >/dev/null ; then
     if [ $target == $MYIP ]; then
         echo TAGA: Notice: Skipping $MYIP Time Synch Check since Local Mode Flag is set
         exit
     fi
   fi

   # otherwise continue normally...

   # reinit
   let delay=0
   let valid=0
   let trycount=0

   while [ $valid -eq 0 ]
   do

   # resource the config in case the strict flag or other config is modified
   source $TAGA_CONFIG_DIR/config

   # reset mylogin id since config might revert it
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   # make sure this target is still in the list
   if echo $targetList | grep $target >/dev/null; then
      echo Target is still in the list >/dev/null
   else
      echo Target List has changed, $target no longer valid target.
      break
   fi

   #echo
   #echo $0 checking $target

   # get the DTS with nanoseconds granularity
   MY_TIME=`date -Ins` 
   TGT_TIME=`ssh -l $MYLOGIN_ID $target date -Ins` 
   let sshRetCode=$?
   if [ $sshRetCode -ne 0 ] ; then
      echo Notice: SSH RetCode: $sshRetCode
   fi

   # check the ssh return code
   #if [ $? -eq 0 ]; then
   if [ $sshRetCode -eq 0 ]; then
      # good return code
      echo okay keep going >/dev/null
   else

       let trycount=$trycount+1
       if [ $trycount -ge $BLACK_LIST_THRESH ] ; then
         # note, this black list section has been invoked
         # black list this node 
         # note, only one blacklist node currently supported
         echo >> $TAGA_CONFIG_DIR/config
         echo "# BLACKLIST" >> $TAGA_CONFIG_DIR/config
         # dlm temp july 2016
         #if [ $BLACK_LIST_PERSIST -eq 1 ]; then
         if [ true ]; then
            # dlm temp this did not work
            BLACKLIST="$BLACKLIST $target"
            #BLACKLIST=`echo $BLACKLIST | sed -e s/$BLACKLIST/$BLACKLIST\ $target/g`
         else
            BLACKLIST="$target"
         fi

         # dlm temp
         #BLACKLIST="192.1.1.1 192.2.2.2" 

         echo BLACKLIST=\"$BLACKLIST\" >> $TAGA_CONFIG_DIR/config
         echo
         echo Warning: $target has been black listed!!
         echo Warning: $target has been removed from this test!!
         echo
         break
         #continue
       elif [ $trycount -ge 10 ] ; then
         echo
         echo "WARNING: "
         echo "WARNING: Unable to obtain system time from $target"
         echo "WARNING: "
         echo
         sleep 2

         if [ $STRICT_TIME_SYNCH -eq 0 ];  then 
           echo "WARNING: "
           echo "WARNING: Continuing without time synch check with $target ....."
           echo "WARNING: "
           echo
           sleep 2
           # break from while loop
           break
         else
           echo NOTE:
           echo "NOTE: Strict Time Synch is Enabled."
           echo "NOTE: To proceed without time synch, set STRICT_TIME_SYNCH  = 0 in config."
           echo NOTE:
           echo
           sleep 2
         fi
       fi

      # bad return code
      echo 
      echo "WARNING: "
      echo "WARNING: Unable to obtain system time from $target"
      echo "WARNING: "
      echo 
      sleep 2
      continue
   fi

   # print the info
  # echo Target:$target T1: `echo $MY_TIME | cut -c11-29 ` T2: `echo $TGT_TIME | cut -c11-29 ` 

   # get the meaty part of the string
   MY_TIME2=`echo $MY_TIME | cut -c18-100 | cut -c1-12`
   TGT_TIME2=`echo $TGT_TIME | cut -c18-100 | cut -c1-12`

   # strip commas
   MY_TIME3=`echo $MY_TIME2 | sed -e s/,//g`
   TGT_TIME3=`echo $TGT_TIME2 | sed -e s/,//g`

   # strip leading 0s
   MY_TIME4=`echo $MY_TIME3 | sed -e s/^0//g | sed -e s/^0//g | sed -e s/^0//g | sed -e s/^0//g | sed -e s/^0//g`
   TGT_TIME4=`echo $TGT_TIME3 | sed -e s/^0//g | sed -e s/^0//g | sed -e s/^0//g | sed -e s/^0//g | sed -e s/^0//g`
   #TGT_TIME4=`echo $TGT_TIME3 | sed -e s/^0//g`

   # get the delta
   let DELTA=$TGT_TIME4-$MY_TIME4
   let retCode=$?

   # check validity
   if [ $retCode -eq 0 ] ; then
     # check validity
     if [ $DELTA -gt 0 ] ; then 

       # verify we are on the right minute
       # get mins
       MY_TIME2=`echo $MY_TIME | cut -c15-16`
       TGT_TIME2=`echo $TGT_TIME | cut -c15-16`

       # get hours
       MY_TIME3=`echo $MY_TIME | cut -c12-13` 
       TGT_TIME3=`echo $TGT_TIME | cut -c12-13`

       # strip off leading 0s
       MY_TIME4=`echo $MY_TIME2 | sed -e s/^0//g`
       TGT_TIME4=`echo $TGT_TIME2 | sed -e s/^0//g`
       let MINUTES=$TGT_TIME4-$MY_TIME4

       # strip off leading 0s
       MY_TIME5=`echo $MY_TIME3 | sed -e s/^0//g`
       TGT_TIME5=`echo $TGT_TIME3 | sed -e s/^0//g`
       let HOURS=$TGT_TIME5-$MY_TIME5

       # get the meaty part of the string
       MY_TIME2B=`echo $MY_TIME | cut -c18-100 | cut -c1-12`
       TGT_TIME2B=`echo $TGT_TIME | cut -c18-100 | cut -c1-12`

       # strip commas
       MY_TIME3B=`echo $MY_TIME2B | sed -e s/,//g`
       TGT_TIME3B=`echo $TGT_TIME2B | sed -e s/,//g`

       # check validity
       if [ $MINUTES -eq 0 ] ; then 
          # okay

          # set valid to true
          let valid=1

          # reset try count flag so we don't give false warnings
          let trycount=0

          deltalen=`echo $DELTA | awk '{print length($0)}'`

          if [ $deltalen -eq 1 ] ; then
             duration="(X < 1/100000000 sec)"
             let delay=0
          elif [ $deltalen -eq 2 ] ; then
             duration="(X < 1/10000000 sec)"
             let delay=0
          elif [ $deltalen -eq 3 ] ; then
             duration="(X < 1/1000000 sec)"
             let delay=0
          elif [ $deltalen -eq 4 ] ; then
             duration="(X < 1/100000 sec)"
             let delay=0
          elif [ $deltalen -eq 5 ] ; then
             duration="(X < 1/10000 sec)"
             let delay=0

          elif [ $deltalen -eq 6 ] ; then
             duration="(X < 1/1000 sec)"
             MICROSECS=`echo $DELTA | cut -c1-3`
             FRACTIONPART=`echo $DELTA | cut -c4`
             duration="(X > $MICROSECS.$FRACTIONPART usecs) ******* *******" 
             let delay=0
          elif [ $deltalen -eq 7 ] ; then
             duration="(X < 1/100 sec)"
             MILLISECS=`echo $DELTA | cut -c1`
             FRACTIONPART=`echo $DELTA | cut -c2`
             duration="(X > $MILLISECS.$FRACTIONPART msecs) ******* *******" 
             let delay=0
          elif [ $deltalen -eq 8 ] ; then
             duration="(X < 1/10 sec)"
             MILLISECS=`echo $DELTA | cut -c1-2`
             FRACTIONPART=`echo $DELTA | cut -c3`
             duration="(X > $MILLISECS.$FRACTIONPART msecs) ******* *******" 
             # pad DELTA value
             DELTA=000$DELTA
             let delay=0
          elif [ $deltalen -eq 9 ] ; then
             duration="(X < 1 sec)"
             MILLISECS=`echo $DELTA | cut -c1-3`
             FRACTIONPART=`echo $DELTA | cut -c4`
             duration="  $MILLISECS.$FRACTIONPART msecs :: (X > $MILLISECS.$FRACTIONPART msecs) " 
             # pad DELTA value
             DELTA=00$DELTA
             let delay=0
          elif [ $deltalen -eq 10 ] ; then
             duration="(1 sec < X < 10 secs) ********"
             SECS=`echo $DELTA | cut -c1`
             FRACTIONPART=`echo $DELTA | cut -c2`
             duration="(X > $SECS.$FRACTIONPART secs) ******* *******" 
             # pad DELTA value
             DELTA=0$DELTA
             let delay=0
          else
             duration="(X > 10 secs) ******* *******" 
             SECS=`echo $DELTA | cut -c1-2`
             FRACTIONPART=`echo $DELTA | cut -c3`
             duration="(X > $SECS.$FRACTIONPART secs) ******* *******" 
             let delay=0

             # new 21 mar 2016
             # Reboot Bad Nodes
             #if [ $SECS -gt 20 ]; then
             if [ $SECS -gt $MAX_TIME_DELTA_BEFORE_REBOOT ]; then
                echo The $target is a candidate for Reboot!!! 
                echo The $target is a candidate for Reboot!!! 
                if [ $target == $MYIP ]; then
                   # we may be having trouble with SSH locally
                   # swich to local mode for file transfer and such
                   echo Setting Local Mode in the Local Mode Flag File
                   echo Setting Local Mode in the Local Mode Flag File
                   echo 1 > $TAGA_LOCAL_MODE_FLAG_FILE
                else
                   $TAGA_UTILS_DIR/rebootOneB.sh $target & 
                                           # < $TAGA_CONFIG_DIR/confirm.txt
                   echo;echo $0 Suspending to let $target recover;echo
                   $IBOA_UTILS_DIR/iboaDelay.sh 60 5

                fi
             fi 
          fi

          # T1
#          echo ------------
#          echo $TGT_TIME3B - $MY_TIME3B = $DELTA
          #echo ------------
          echo "`$iboaUtilsDir/iboa_padded_echo.sh \"TAGA:Target:$target:\" 29` $duration $description"
       else

          echo MINUTES: $MINUTES : Minute Boundary Encountered

          # check validity
          if [ $MINUTES -ge 0 ] ; then 

          deltalen=`echo $DELTA | awk '{print length($0)}'`

          if [ $deltalen -eq 1 ] ; then
             let delay=0
          elif [ $deltalen -eq 2 ] ; then
             let delay=0
          elif [ $deltalen -eq 3 ] ; then
             let delay=0
          elif [ $deltalen -eq 4 ] ; then
             let delay=0
          elif [ $deltalen -eq 5 ] ; then
             let delay=0

          elif [ $deltalen -eq 6 ] ; then
             let delay=0
          elif [ $deltalen -eq 7 ] ; then
             let delay=0
          elif [ $deltalen -eq 8 ] ; then
             # pad DELTA value
             DELTA=000$DELTA
             let delay=0
          elif [ $deltalen -eq 9 ] ; then
             # pad DELTA value
             DELTA=00$DELTA
             let delay=0
          elif [ $deltalen -eq 10 ] ; then
             # pad DELTA value
             DELTA=0$DELTA
             let delay=0
          else
             let delay=0
          fi

             #echo MINUTES: $MINUTES
             if [ $MINUTES -eq 1 ]; then
                duration="(X > 1 min) ******* *******" 
             elif [ $MINUTES -eq 2 ]; then
                duration="(X > 2 mins) ****** *******" 
             elif [ $MINUTES -eq 3 ]; then
                duration="(X > 3 mins) ****** *******" 
             elif [ $MINUTES -eq 4 ]; then
                duration="(X > 4 mins) ****** *******" 
             elif [ $MINUTES -eq 5 ]; then
                duration="(X > 5 mins) ****** *******" 
             elif [ $MINUTES -eq 6 ]; then
                duration="(X > 6 mins) ****** *******" 
             elif [ $MINUTES -eq 7 ]; then
                duration="(X > 7 mins) ****** *******" 
             elif [ $MINUTES -eq 8 ]; then
                duration="(X > 8 mins) ****** *******" 
             elif [ $MINUTES -eq 9 ]; then
                duration="(X > 9 mins) ****** *******" 
             else
                duration="(X > 10+ mins) ****** *******" 
                #let MINUTES=$MINUTES-1
                duration="(X > $MINUTES mins) ****** *******" 
             fi

             # T2
             echo ------------
             echo "$count $TIMESTR 0$DELTA T2:$duration" Target: $target  $description #$count $TIMESTR
             echo ------------
             echo
          else
             # hour boundaries not supported
             #echo MINUTES: $MINUTES
             let MINUTES=$MINUTES+60
             #echo MINUTES: ~$MINUTES ?? 

             #echo "Negative Delta Minutes- Hour Boundaries Not Supported  " 
             #echo "Negative Delta Minutes- Hour Boundaries Not Supported  " 

             #echo HOURS: $HOURS
             #echo MINUTES: $MINUTES

             # dlm temp find me

             # check validity
             if [ $HOURS -eq 0 ] ; then 
                echo HOURS is 0, this is an anomaly?
                echo HOURS is 0, this is an anomaly?
                echo Anomaly1? : MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
                echo Anomaly1? : MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
             elif [ $HOURS -lt 0 ] ; then 
                echo HOURS is less than 0, day boundaries not supported
                echo HOURS is less than 0, day boundaries not supported
                echo Anomaly2? : MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
                echo Anomaly2? : MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
             else
                echo MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
                echo MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
                echo HOURS: $HOURS MINUTES: $MINUTES
                if [ $HOURS -eq 1 ]; then
                   duration="(X < 1 hour) (~$MINUTES mins) ****" 
                elif [ $HOURS -eq 2 ]; then
                   duration="(X > 1 hour) ****** *******" 
                elif [ $HOURS -eq 3 ]; then
                   duration="(X > 2 hours) ****** *******" 
                elif [ $HOURS -eq 4 ]; then
                   duration="(X > 3 hours) ****** *******" 
                elif [ $HOURS -eq 5 ]; then
                   duration="(X > 4 hours) ****** *******" 
                elif [ $HOURS -eq 6 ]; then
                   duration="(X > 5 hours) ****** *******" 
                elif [ $HOURS -eq 7 ]; then
                   duration="(X > 6 hours) ****** *******" 
                elif [ $HOURS -eq 8 ]; then
                   duration="(X > 7 hours) ****** *******" 
                elif [ $HOURS -eq 9 ]; then
                   duration="(X > 8 hours) ****** *******" 
                elif [ $HOURS -eq 10 ]; then
                   duration="(X > 9 hours) ****** *******" 
                else
                   duration="(X > 10+ hours) ****** *******" 
                   #let HOURS=$HOURS-1
                   duration="(X > $HOURS hours) ****** *******" 
                   #DELTA="xxxxxxxxxxxx"
                fi

                # T3
                echo HOURS: $HOURS : Hour Boundary Encountered
                echo ------------
                DELTA="xxxxxxxxxxxx"
                echo "$count $TIMESTR $DELTA T3:$duration" Target: $target  $description #$count $TIMESTR
                echo ------------
                echo
                echo T3: MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
                echo

             fi

             echo "Notice: T3: Negative Delta Mins - Hour Boundaries Not Fully Supported" 

          fi
       fi

     else

       # verify we are on the right minute
       # get mins
       MY_TIME2=`echo $MY_TIME | cut -c15-16`
       TGT_TIME2=`echo $TGT_TIME | cut -c15-16`

       # get hours
       MY_TIME3=`echo $MY_TIME | cut -c12-13` 
       TGT_TIME3=`echo $TGT_TIME | cut -c12-13`

       # strip off leading 0s
       MY_TIME4=`echo $MY_TIME2 | sed -e s/^0//g`
       TGT_TIME4=`echo $TGT_TIME2 | sed -e s/^0//g`
       let MINUTES=$TGT_TIME4-$MY_TIME4

       # strip off leading 0s
       MY_TIME5=`echo $MY_TIME3 | sed -e s/^0//g`
       TGT_TIME5=`echo $TGT_TIME3 | sed -e s/^0//g`
       let HOURS=$TGT_TIME5-$MY_TIME5

       # check validity
       if [ $MINUTES -gt 0 ] ; then 

          if [ $MINUTES -eq 1 ]; then

             # 15 Mar 2016, set valid to true here
             # set valid to true
             let valid=1

             DELTA2=`echo $DELTA | cut -c2-`
             let SECS=60000000000-$DELTA2
             let SECS=$SECS/1000
             let SECS=$SECS/1000
             let SECS=$SECS/1000
             let SECS=$SECS+1
             duration="(X < $SECS secs) ******* *******" 
          elif [ $MINUTES -eq 2 ]; then
             duration="(X < 2 mins) ****** *******" 
          elif [ $MINUTES -eq 3 ]; then
             duration="(X < 3 mins) ****** *******" 
          elif [ $MINUTES -eq 4 ]; then
             duration="(X < 4 mins) ****** *******" 
          elif [ $MINUTES -eq 5 ]; then
             duration="(X < 5 mins) ****** *******" 
          elif [ $MINUTES -eq 6 ]; then
             duration="(X < 6 mins) ****** *******" 
          elif [ $MINUTES -eq 7 ]; then
             duration="(X < 7 mins) ****** *******" 
          elif [ $MINUTES -eq 8 ]; then
             duration="(X < 8 mins) ****** *******" 
          elif [ $MINUTES -eq 9 ]; then
             duration="(X < 9 mins) ****** *******" 
          else
             duration="(X > 10+ mins) ****** *******" 
             let MINUTES=$MINUTES-1
             duration="(X > $MINUTES mins) ****** *******" 
             DELTA="xxxxxxxxxxxx"
          fi

          # T4
          echo "$count $TIMESTR $DELTA T4:$duration" Target: $target  $description #$count $TIMESTR
          echo

          # new 21 mar 2016
          # Reboot Bad Nodes
          #if [ $SECS -gt 20 ]; then
          if [ $SECS -gt $MAX_TIME_DELTA_BEFORE_REBOOT ]; then
             echo The $target is a candidate for Reboot!!! 
             echo The $target is a candidate for Reboot!!! 
                if [ $target == $MYIP ]; then
                   # we may be having trouble with SSH locally
                   # swich to local mode for file transfer and such
                   echo Setting Local Mode in the Local Mode Flag File
                   echo Setting Local Mode in the Local Mode Flag File
                   echo 1 > $TAGA_LOCAL_MODE_FLAG_FILE
                else
                   $TAGA_UTILS_DIR/rebootOneB.sh $target & 
                                           # < $TAGA_CONFIG_DIR/confirm.txt
                   echo;echo $0 Suspending to let $target recover;echo
                   $IBOA_UTILS_DIR/iboaDelay.sh 60 5

                fi
             #$TAGA_UTILS_DIR/rebootOneB.sh $target & # < $TAGA_CONFIG_DIR/confirm.txt
             #echo;echo $0 Suspending to let $target recover;echo
             #$IBOA_UTILS_DIR/iboaDelay.sh 60 5
          fi 

          #echo
          #echo T4: MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
          #echo
       else
          # hour boundary
          let MINUTES=$MINUTES+60

             # check validity
             if [ $HOURS -eq 0 ] ; then 
                echo Anomaly:$target:Back In Time! 
                echo "MY_TIME: $MY_TIME "
                echo "TGT_TIME:$TGT_TIME" 
                echo Anomaly:$target:Back In Time! 
                echo "MY_TIME: $MY_TIME "
                echo "TGT_TIME:$TGT_TIME" 
                #echo Anomaly:$target:Back In Time! MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME 
             elif [ $HOURS -lt 0 ] ; then 
                echo HOURS is less than 0, day boundaries not supported
                echo  MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
             else
                if [ $HOURS -eq 1 ]; then
                   duration="(X < 1 hour) (~$MINUTES mins) ****" 
                   #duration="(X < 1 hour) ******* *******" 
                elif [ $HOURS -eq 2 ]; then
                   duration="(X < 2 hours) ****** *******" 
                elif [ $HOURS -eq 3 ]; then
                   duration="(X < 3 hours) ****** *******" 
                elif [ $HOURS -eq 4 ]; then
                   duration="(X < 4 hours) ****** *******" 
                elif [ $HOURS -eq 5 ]; then
                   duration="(X < 5 hours) ****** *******" 
                elif [ $HOURS -eq 6 ]; then
                   duration="(X < 6 hours) ****** *******" 
                elif [ $HOURS -eq 7 ]; then
                   duration="(X < 7 hours) ****** *******" 
                elif [ $HOURS -eq 8 ]; then
                   duration="(X < 8 hours) ****** *******" 
                elif [ $HOURS -eq 9 ]; then
                   duration="(X < 9 hours) ****** *******" 
                elif [ $HOURS -eq 10 ]; then
                   duration="(X < 10 hours) ****** *******" 
                else
                   duration="(X > 10+ hours) ****** *******" 
                   let HOURS=$HOURS-1
                   duration="(X > $HOURS hours) ****** *******" 
                   #DELTA="xxxxxxxxxxxx"
                fi

                # T5
                DELTA="xxxxxxxxxxxx"
                echo HOURS: $HOURS : Hour Boundary Encountered
                echo "$count $TIMESTR $DELTA T5:$duration" Target: $target  $description #$count $TIMESTR
                echo
                echo T5: MY_TIME:$MY_TIME TGT_TIME:$TGT_TIME
                echo

             fi
       fi
     fi
   else
     echo ------------
     echo "Invalid Time Delta  Delta: (Invalid)" 
     echo ------------
   fi

   # delay if warning condition
   sleep $delay


   let trycount=$trycount+1
   if [ $trycount -ge $BLACK_LIST_THRESH ] ; then
     # note, this black list section has not yet been seen 
     # not sure we can actually get here...
     # black list this node 
     # note, only one blacklist node currently supported
     echo >> $TAGA_CONFIG_DIR/config
     echo "# BLACKLIST" >> $TAGA_CONFIG_DIR/config
     BLACKLIST="$target"
     echo BLACKLIST=$BLACKLIST >> $TAGA_CONFIG_DIR/config
     echo
     echo Warning: $target has been black listed!!
     echo Warning: $target has been removed from this test!!
     echo
     break
     #continue
   elif [ $trycount -ge 10 ] ; then
     echo
     echo "WARNING: "
     echo "WARNING: Unable to obtain system time from $target"
     echo "WARNING: "
     echo
     sleep 2

     if [ $STRICT_TIME_SYNCH -eq 0 ];  then 
       echo "WARNING: "
       echo "WARNING: Continuing without time synch check with $target ....."
       echo "WARNING: "
       echo
       sleep 2
       # break from while loop
       break
     else
       echo NOTE:
       echo "NOTE: Strict Time Synch is Enabled."
       echo "NOTE: To proceed without time synch, set STRICT_TIME_SYNCH  = 0 in config."
       echo NOTE:
       echo
       sleep 2
     fi
   fi

   # resource the config in case the strict flag is modified
   source $TAGA_CONFIG_DIR/config

   # reset mylogin id since config might revert it
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 


   # while not valid
   done



done # end targetList

# get the md5sum of the targetlist config so we know if it changes
configMd5sum2=`md5sum $TAGA_CONFIG_DIR/targetList.sh | cut -d" " -f 1`

if [ $configMd5sum == $configMd5sum2 ]; then
  let configChanged=0
fi

# rebaseline our targetlist config (md5sum) for next iteration check
configMd5sum=`md5sum $TAGA_CONFIG_DIR/targetList.sh | cut -d" " -f 1`

done  # end while

