#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

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

for target in $targetList
do

  # build Row output

  # init the row cumulative
  let row_cumulative=0

  # create the column containers
  let i=$i+1

  # pad target name as necessary to have nice output
  tgtlen=`echo $target | awk '{print length($0)}'`

  if [ $tgtlen -eq 17 ] ; then
    row=$target\ 
  elif [ $tgtlen -eq 16 ] ; then
    row=$target\. 
  elif [ $tgtlen -eq 15 ] ; then
    row=$target\.. 
  elif [ $tgtlen -eq 14 ] ; then
    row=$target\... 
  elif [ $tgtlen -eq 13 ] ; then
    row=$target\.... 
  elif [ $tgtlen -eq 12 ] ; then
    row=$target\..... 
  elif [ $tgtlen -eq 11 ] ; then
    row=$target\...... 
  elif [ $tgtlen -eq 10 ] ; then
    row=$target\....... 
  else
    row=$target\........ 
  fi

  let j=0

  # get the received count for (to) this target
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
        cat /tmp/curcount.txt  | grep $target\.      > /tmp/curcount2.txt # filter on the target (row)
        cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt  # get the count
      else
        # UCAST
        cat /tmp/curcount.txt  | grep "length $MSGLEN" > /tmp/curcount2.txt # verify length
        cat /tmp/curcount2.txt | cut -d">" -f 1       > /tmp/curcount.txt  # get senders only
        cat /tmp/curcount.txt  | grep $target\\\.      > /tmp/curcount2.txt # filter on the target (row)
        cat /tmp/curcount2.txt | wc -l                > /tmp/curcount.txt  # get the count
      fi

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
        if echo $BLACKLIST | grep $target2 >/dev/null; then
           curcount="BLKL"
        else
           curcount="----"
        fi
      fi 2>/dev/null
    fi
    
    # append count to the row string
    row="$row $curcount"

  done # continue to next target

  row="$row"" "

  let ROW_SIZE=62
  let ROW_SIZE=66
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
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
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

#column_cumulative="$column_cumulative"" "

let ROW_SIZE=48
let ROW_SIZE=51
let ROW_SIZE=47
let ROW_SIZE=44
let ROW_SIZE=46
let ROW_SIZE=45
let ROW_SIZE=49
let rowlen=`echo $column_cumulative | awk '{print length($0)}'`
let padlen=$ROW_SIZE-$rowlen

# add the padding
let i=$padlen
while [ $i -gt 0 ];
do
  column_cumulative="$column_cumulative "
  let i=$i-1
done

#column_cumulative="$column_cumulative"" "

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
column_cumulative=$column_cumulative" "$column_cumulative_count

# Print a space
echo 
echo >> $TAGA_RUN_DIR/counts.txt
echo >> $TAGA_RUN_DIR/countsReceives.txt

# Print the final (Totals) row
row="Receiver Totals: $column_cumulative"
echo "$row"
echo "$row" >> $TAGA_RUN_DIR/counts.txt
echo "$row" >> $TAGA_RUN_DIR/countsReceives.txt

echo
