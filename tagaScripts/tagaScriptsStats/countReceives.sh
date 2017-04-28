####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

# If counts are disabled, exit now
if [ $COUNTS_DISABLED -eq 1 ]; then
   echo NOTICE: Counts are DISABLED, $0 exiting with no action!
   exit
fi

# get the inputs
outputDir=$1
iter=$2
startTime=$3
startDTG=$4

# archive directory processing
if [ $TESTONLY -eq 1 ] ; then
  # use the testing directory for testing
  outputDir=$OUTPUT_DIR/output
fi 

# go to the output Directory for processing
cd $outputDir

##################################################################
# PRINT HEADER ROWS
##################################################################
$tagaScriptsStatsDir/printReceiversHeader.sh RECEIVERS $iter $startTime $startDTG

###################
# MAIN COUNT/SORT
###################

curcount="xxxx"

# init the columns cumulative
let column_cumulative_count=0
let column_target_cumulative_count=0
let i=0
let j=0
for target in $targetList
do
     # create dynamic vars to hold the column counts and init to 0
     let j=$j+1
     p_val=$j
     active_id=$p_val
     declare "flag_$active_id"=0
done


let m=0 # index

for target in $targetList
do

  # increment the index
  let m=$m+1
  if [ $m -lt 10 ]; then
    mprint=" $m"
  else
    mprint=$m
  fi 

  #row="$mprint. $row"

  # build Row output

  # reset ALT COUNT FLAG each row
  ALT_COUNT_FLAG=0

  # init the row cumulative
  let row_cumulative=0

  # create the column containers
  let i=$i+1

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

#  if [ $tgtlen -eq 17 ] ; then
#    row=$target\ 
#  elif [ $tgtlen -eq 16 ] ; then
#    row=$target\. 
#  elif [ $tgtlen -eq 15 ] ; then
#    row=$target\.. 
#  elif [ $tgtlen -eq 14 ] ; then
#    row=$target\... 
#  elif [ $tgtlen -eq 13 ] ; then
#    row=$target\.... 
#  elif [ $tgtlen -eq 12 ] ; then
#    row=$target\..... 
#  elif [ $tgtlen -eq 11 ] ; then
#    row=$target\...... 
#  elif [ $tgtlen -eq 10 ] ; then
#    row=$target\....... 
#  elif [ $tgtlen -eq 9 ] ; then
#    row=$target\........ 
#  else
#    row=$target\......... 
#  fi

  let j=0

  # get the received count for (to) this target
  let rownodeCount=0
  for target2 in $targetList

  do

     # create the inner loop column containers
     let j=$j+1

    if [ $target == $target2 ] ; then
      # skip self
      curcount="xxxx"
    else

      # else get the count for this target

      HOST=`cat $TAGA_CONFIG_DIR/hostsToIps.txt | grep $target2\\\. | cut -d"." -f 5`
      DEST_FILE_TAG=$TEST_DESCRIPTION\_$HOST\_*$target2\_

      # write to the curcount.txt file
      cat $DEST_FILE_TAG* > /tmp/curcount.txt 2>/dev/null

      # mcast or ucast? 
      if [ $TESTTYPE == "MCAST" ]; then
        # MCAST
        cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt # verify length
        cat /tmp/curcount2.txt | cut -d">" -f 1       > /tmp/curcount.txt  # get senders only
        #cat /tmp/curcount.txt  | grep $target\.      > /tmp/curcount2.txt # filter on the target (row)
        cat /tmp/curcount.txt  | grep $target\\\.      > /tmp/curcount2.txt # filter on the target (row)
        cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt  # get the count
      else
        # UCAST
        cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt # verify length
        if [ $FILTER_OUT_GATEWAY_DUP_COUNTS -eq 1 ] ; then
           # make sure I am the destination (gateways can get extra messages destined elsewhere)
           # to do this, ensure the target2 is in the receivers field of the message string
           cat /tmp/curcount2.txt | grep $target2.....:   > /tmp/curcount.txt  # get messages destined for me
        else
           # otherwise, just copy/cat the file directly without additional filter
           cat /tmp/curcount2.txt                      > /tmp/curcount.txt  # get messages destined for me
        fi
        cat /tmp/curcount.txt | cut -d">" -f 1         > /tmp/curcount2.txt  # get senders only
        cat /tmp/curcount2.txt  | grep $target\\\.     > /tmp/curcount.txt # filter on the target (row)
        cat /tmp/curcount.txt | wc -l                  > /tmp/curcount2.txt  # get the count
        cp /tmp/curcount2.txt /tmp/curcount.txt                              # finalize
      fi

#     echo here111
#     cat /tmp/curcount.txt

      # check if we have a 0 count, if so, it is possible that the tcpdump output specified by
      # hostname rather than by IP address, so we have an option to check further
      # if the option is set, then examine the tcpdump output for hostname vice IP address

      ### reset ALT COUNT FLAG each target
      ### ALT_COUNT_FLAG=0

      # dlm temp, add real check here
      let CHECK_DUAL_INTERFACES_FOR_COUNTS=0
      let CHECK_DUAL_INTERFACES_FOR_COUNTS=1
      
      if [ $CHECK_DUAL_INTERFACES_FOR_COUNTS -eq 1 ] ; then
         mycurcount=`cat /tmp/curcount.txt`
         if [ $mycurcount -eq 0 ]; then
#           echo here1111
            echo Notice: Alternate Interface to $target Checked for Traffic Counts >> /tmp/tagaCountReceivesNotice.txt
#             echo dlm temp hi target is $target, current count is  $mycurcount, we found count of 0
             myalternateInterface=`cat ~/scripts/taga/tagaConfig/hostsToSharedIps.txt | grep $target\. | cut -d\. -f 6-9`
#             echo myalternateInterface:$myalternateInterface
             if [ ! $myalternateInterface ]; then
#           echo here2222
                echo No alternate interface found, no further checks >/dev/null
             else
#           echo here3333
                echo Alternate interface found, counts continue... >/dev/null
             # start over, once again, write to the curcount.txt file
             cat $DEST_FILE_TAG* > /tmp/curcount.txt 2>/dev/null
             
            # mcast or ucast? 
#            echo here222
            if [ $TESTTYPE == "MCAST" ]; then
              # MCAST
              cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt # verify length
              cat /tmp/curcount2.txt | cut -d">" -f 1       > /tmp/curcount.txt  # get senders only
              cat /tmp/curcount.txt  | grep $myalternateInterface\.      > /tmp/curcount2.txt # filter on the target (row)
              cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt  # get the count
            else
#              echo here333
#              echo myalternateInterface:$myalternateInterface
#              echo here333aaa
#              cat /tmp/curcount.txt  
#              echo here444
              # UCAST
              cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt # verify length
              cat /tmp/curcount2.txt | cut -d">" -f 1       > /tmp/curcount.txt  # get senders only
              cat /tmp/curcount.txt  | grep $myalternateInterface\\\.      > /tmp/curcount2.txt # filter on the target (row)
              cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt  # get the count
            fi

            mycurcount=`cat /tmp/curcount.txt`
            if [ $mycurcount -ne 0 ]; then
               # we changed our counts based on alternate ip address, set the flag so we can indicate it in the display
               ALT_COUNT_FLAG=1
            fi

            fi

         fi
      fi

#     echo here222
#     cat /tmp/curcount.txt

#      echo dlm temp hi target is $target
#      echo dlm temp hi target is $target, current count is  `cat /tmp/curcount.txt`
#      echo dlm temp hi target is $target, current count is  $mycurcount
#      echo dlm temp hi target is $target, current count is  $mycurcount

#      if [ $mycurcount -eq 0 ]; then
#          echo dlm temp hi target is $target, current count is  $mycurcount, we found count of 0
#         echo dlm temp hi target is $target, current count is  $mycurcount, we found count of 0
#         echo dlm temp hi target is $target, current count is  $mycurcount, we found count of 0
#         echo dlm temp hi target is $target, current count is  $mycurcount, we found count of 0
#         cat ~/scripts/taga/tagaConfig/hostsToIps.txt
#         cat ~/scripts/taga/tagaConfig/hostsToIps.txt | grep $target\. | cut -d\. -f 5
#         mytargethostname=`cat ~/scripts/taga/tagaConfig/hostsToIps.txt | grep $target\. | cut -d\. -f 5`
#         echo mytargethostname:$mytargethostname
#      fi


      # populate curcount from the curcount.txt file
      let curcount=`cat /tmp/curcount.txt`

      # add this count to the cumulative
      let row_cumulative=$row_cumulative+$curcount

      let column_cumulative_count=$column_cumulative_count+$curcount

      let column_target_cumulative_count=$column_target_cumulative_count+curcount

      p_val=$j
      active_id=$p_val

      let myvalue=$column_target_cumulative_count

      mytmpvar="flag_$active_id"
     
      let othertmp="${!mytmpvar}"+$curcount

      declare "$mytmpvar"=$othertmp

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

      if [ -f  $DEST_FILE_TAG* ] ; then
        echo file exists! >/dev/null
      else
        #if echo $BLACKLIST | grep "$target2$" >/dev/null; then
        if echo $BLACKLIST | grep -e "$target2 " -e "$target2$" >/dev/null; then
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
     #   echo $row
        echo "$row"
        echo "$row" >> $TAGA_RUN_DIR/counts.txt
        echo "$row" >> $TAGA_RUN_DIR/countsReceives.txt
        row="................."
    fi

  done # continue to next target

  row="$row"" "

  if [ $NARROW_DISPLAY -eq 1 ]; then
    let ROW_SIZE=66
    let ROW_SIZE=64
    let ROW_SIZE=66
  elif [ $WIDE_DISPLAY -eq 1 ]; then
    let ROW_SIZE=166
  else
    let ROW_SIZE=118
    let ROW_SIZE=138
    let ROW_SIZE=142
  fi

  #let ROW_SIZE=58
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

  # dlm temp find me
  if [ $ALT_COUNT_FLAG -eq 1 ]; then
     row="$row*"
  fi


  echo "$row"
  echo "$row" >> $TAGA_RUN_DIR/counts.txt
  echo "$row" >> $TAGA_RUN_DIR/countsReceives.txt
 
done


let count=0
for target in $targetList
do
  let count=$count+1
done

column_cumulative=""
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
do 

  v="flag_$i"

  value=`echo "${!v}"`

  let valuelen=`echo $value | awk '{print length($0)}'`
  # pad it
  if [ $valuelen -eq 3 ] ; then
     value=0$value
  elif [ $valuelen -eq 2 ] ; then
     value=00$value
  elif [ $valuelen -eq 1 ] ; then
     value=000$value
  else
     echo nothing to pad >/dev/null
  fi

  column_cumulative="$column_cumulative $value"

  let count=$count-1
  if [ $count -eq 0 ] ; then
    break
  fi

done


#if [ $NARROW_DISPLAY -eq 1 ]; then
#  let ROW_SIZE=48
#  let ROW_SIZE=49
#elif [ $WIDE_DISPLAY -eq 1 ]; then
#  let ROW_SIZE=48
#  let ROW_SIZE=49
#else
#  let ROW_SIZE=48
#  let ROW_SIZE=49
#  let ROW_SIZE=49
##fi


if [ $NARROW_DISPLAY -eq 1 ]; then
   let ROW_SIZE=66
   let ROW_SIZE=64
elif [ $WIDE_DISPLAY -eq 1 ]; then
   let ROW_SIZE=166
else
   let ROW_SIZE=118
   let ROW_SIZE=138
   let ROW_SIZE=142
   let ROW_SIZE=140
fi


let rowlen=`echo $column_cumulative | awk '{print length($0)}'`
# account for the "Receivers Total" label in the character count
let rowlen=$rowlen+15
let padlen=$ROW_SIZE-$rowlen

#echo rowlen:$rowlen
#echo padlen:$padlen

# add the padding
let i=$padlen
while [ $i -gt 0 ];
do
  column_cumulative="$column_cumulative "
  let i=$i-1
done

# get the padding
let valuelen=`echo $column_cumulative_count | awk '{print length($0)}'`
# pad it
if [ $valuelen -eq 3 ] ; then
  column_cumulative_count=0$column_cumulative_count
elif [ $valuelen -eq 2 ] ; then
  column_cumulative_count=00$column_cumulative_count
elif [ $valuelen -eq 1 ] ; then
  column_cumulative_count=000$column_cumulative_count
else
  echo nothing to pad >/dev/null
fi

# do it
column_cumulative="$column_cumulative $column_cumulative_count"

# Print a space
echo 
echo >> $TAGA_RUN_DIR/counts.txt
echo >> $TAGA_RUN_DIR/countsReceives.txt

# Print the final (Totals) row
row="Receiver Totals:     $column_cumulative"
echo "$row"
echo "$row" >> $TAGA_RUN_DIR/counts.txt
echo "$row" >> $TAGA_RUN_DIR/countsReceives.txt

echo
