#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

NAME=`basename $0`
echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"

# get the input
# get MYIP to use
MY_PARAM_IP=$1
# time to start sending traffic
let TRAFFIC_START_EPOCH=$2

# default to UDP, this should be overriden by config
mgen_proto=UDP

###############################
# Init Part
###############################

# Set MYPORT
let i=0
let MYPORT=$PORTBASE
for target in $targetList
do
  let i=$i+1
  if [ $target == $MYIP ]; then
    let MYPORT=$MYPORT+$i
  fi 
done

###############################
# Server (Traffic Receiver) Part
###############################

# Start Server

if $TAGA_CONFIG_DIR/hostList.sh | grep `hostname` >/dev/null ; then
  if [ $TESTTYPE == "MCAST" ]; then
    # MCAST UDP
    # prep the mgen config 
    # create the script from the template
    sed -e s/mcastgroup/$MYMCAST_ADDR/g $TAGA_MGEN_DIR/script_mcast_rcvr.mgn.template \
            > $TAGA_MGEN_DIR/script_mcast_rcvr.mgn 
    # run it, joing the group
    if [ $TAGA_DISPLAY == "VERBOSE" ]; then
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn #&
    elif [ $TAGA_DISPLAY == "SILENT" ]; then
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn  >/dev/null 2> /dev/null #&
    else
      mgen input $TAGA_MGEN_DIR/script_mcast_rcvr.mgn >/dev/null #&
    fi

    # start the UDP listener in background
    #echo mgen port $MYMCAST_PORT 
    #mgen port $MYMCAST_PORT &
  elif [ $TESTTYPE == "UCAST_TCP" ]; then
    # UCAST TCP
    # override mgen_proto default value of UDP  
    mgen_proto=TCP
    # prep the mgen config 
    # create the script from the template
    sed -e s/port/$MYPORT/g $TAGA_MGEN_DIR/script_tcp_listener.mgn.template \
            > $TAGA_MGEN_DIR/script_tcp_listener.mgn  
    # start the TCP listener in background
    if [ $TAGA_DISPLAY == "VERBOSE" ]; then
      mgen input $TAGA_MGEN_DIR/script_tcp_listener.mgn & 
    elif [ $TAGA_DISPLAY == "SILENT" ]; then
      mgen input $TAGA_MGEN_DIR/script_tcp_listener.mgn > /dev/null 2> /dev/null & 
    else
      mgen input $TAGA_MGEN_DIR/script_tcp_listener.mgn > /dev/null & 
    fi
  else
    # UCAST UDP
    # start the UDP listener in background
    if [ $TAGA_DISPLAY == "VERBOSE" ]; then
      mgen port $MYPORT & 
    elif [ $TAGA_DISPLAY == "SILENT" ]; then
      mgen port $MYPORT > /dev/null 2>/dev/null & 
    else
      mgen port $MYPORT > /dev/null  & 
    fi
  fi
else
  echo `hostname` is not in the list of Traffic/PLI Receivers | tee $STATUS_FILE
  echo $0 Exiting with no action | tee $STATUS_FILE
  exit
fi

#sleep $SERVER_INIT_DELAY
let CURRENT_EPOCH=`date +%s`
let WAITTIME=$TRAFFIC_START_EPOCH-$CURRENT_EPOCH

if [ $WAITTIME -lt 0 ]; then
   echo
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo Warning: $0: negatie WAITTIME: $WAITTIME
   echo
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo Warning: Consider increasing MGEN_SERVER_INIT_DELAY
   echo
fi

#echo WAITTIME:$WAITTIME
#echo WAITTIME:$WAITTIME
#echo WAITTIME:$WAITTIME
#echo WAITTIME:$WAITTIME

if [ $WAITTIME -gt 0 ]; then
   if [ $TAGA_DISPLAY == "DEBUG" ]; then
     echo 1 waiting:$WAITTIME
     echo 1 waiting:$WAITTIME
#     echo 1 waiting:$WAITTIME
     $TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
     echo done waiting:$WAITTIME
   elif [ $TAGA_DISPLAY == "VERBOSE" ]; then
     echo 2 waiting:$WAITTIME
#     echo 2 waiting:$WAITTIME
#     echo 2 waiting:$WAITTIME
     $TAGA_UTILS_DIR/tagaDelay.sh $WAITTIME
     echo done waiting:$WAITTIME
   else
#     echo 3 waiting:$WAITTIME
#     echo 3 waiting:$WAITTIME
#     echo 3 waiting:$WAITTIME
     sleep $WAITTIME
   fi
fi

#echo done waiting:$WAITTIME
#echo done waiting:$WAITTIME
#echo done waiting:$WAITTIME

#if [ $TAGA_DISPLAY == "DEBUG" ]; then
#  $TAGA_UTILS_DIR/tagaDelay.sh $MGEN_SERVER_INIT_DELAY
#if [ $TAGA_DISPLAY == "VERBOSE" ]; then
#  $TAGA_UTILS_DIR/tagaDelay.sh $MGEN_SERVER_INIT_DELAY
#else
#  sleep $MGEN_SERVER_INIT_DELAY
#fi

###############################
# Traffic Generation (Client) Part
###############################

# reinit port-related vars
let i=0

# Start Traffic to other Nodes

# use the activated flag to stagger starts and ensure only one effective loop out of the two below
let activated=0

###############################
# MCAST processing (if testtype == MCAST)
###############################

if [ $TESTTYPE == "MCAST" ]; then
  
  let i=$i+1

  let DESTPORT=$MYMCAST_PORT
  target=$MYMCAST_ADDR
  
  # prep the mgen config 
  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TAGA_MGEN_DIR/script.mgn.temp  # create temp from template
  sed -e s/destport/$DESTPORT/g $TAGA_MGEN_DIR/script.mgn.temp      > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/sourceport/$SOURCEPORT/g $TAGA_MGEN_DIR/script.mgn.temp2 > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
  sed -e s/count/$MSGCOUNT/g $TAGA_MGEN_DIR/script.mgn.temp         > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/rate/$MSGRATE/g $TAGA_MGEN_DIR/script.mgn.temp2          > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
  sed -e s/proto/$mgen_proto/g $TAGA_MGEN_DIR/script.mgn.temp       > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/len/$MSGLEN/g $TAGA_MGEN_DIR/script.mgn.temp2            > $TAGA_MGEN_DIR/script.mgn       # finalize

  # some cleanup
  rm $TAGA_MGEN_DIR/script.mgn.temp $TAGA_MGEN_DIR/script.mgn.temp2

  if [ $TAGA_DISPLAY == "VERBOSE" ]; then
    echo ---------------------
    cat $TAGA_MGEN_DIR/script.mgn
    echo ---------------------
    mgen input $TAGA_MGEN_DIR/script.mgn
  elif [ $TAGA_DISPLAY == "SILENT" ]; then
    mgen input $TAGA_MGEN_DIR/script.mgn > /dev/null 2> /dev/null
  else
    mgen input $TAGA_MGEN_DIR/script.mgn #>/dev/null
  fi
  
  # we are done, exit the script
  exit

fi # if multicast flag is true


###############################
# UCAST processing (if testtype == UCAST)
###############################

###############################
# First Half of UCAST Loop
###############################
for target in $targetList
do
  
  let i=$i+1

  if [ $target == $MYIP ]; then
    #echo target is MYIP , skipping self... 
    let activated=1
    continue
  fi

  # use the activated flag to stagger starts and ensure only one effective loop out of the two loops
  # if not activated, continue to top
  if [ $activated -eq 0 ]; then
    continue
  fi

  let DESTPORT=$PORTBASE+$i

  # prep the mgen config 
  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TAGA_MGEN_DIR/script.mgn.temp  # create temp from template
  sed -e s/destport/$DESTPORT/g $TAGA_MGEN_DIR/script.mgn.temp      > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/sourceport/$SOURCEPORT/g $TAGA_MGEN_DIR/script.mgn.temp2 > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
  sed -e s/count/$MSGCOUNT/g $TAGA_MGEN_DIR/script.mgn.temp         > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/rate/$MSGRATE/g $TAGA_MGEN_DIR/script.mgn.temp2          > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
  sed -e s/proto/$mgen_proto/g $TAGA_MGEN_DIR/script.mgn.temp       > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/len/$MSGLEN/g $TAGA_MGEN_DIR/script.mgn.temp2            > $TAGA_MGEN_DIR/script.mgn       # finalize

  if [ $TESTTYPE == "UCAST_TCP" ]; then
     let tcpDelay=$MSGCOUNT/$MSGRATE
     #echo 10.0 OFF 1 >> $TAGA_MGEN_DIR/script.mgn       # append TCP specific stuff
     echo $tcpDelay.0 OFF 1 >> $TAGA_MGEN_DIR/script.mgn       # append TCP specific stuff
  fi

  # some cleanup
  rm $TAGA_MGEN_DIR/script.mgn.temp $TAGA_MGEN_DIR/script.mgn.temp2

  if [ $TAGA_DISPLAY == "VERBOSE" ]; then
    echo ---------------------
    cat $TAGA_MGEN_DIR/script.mgn
    echo ---------------------
    mgen input $TAGA_MGEN_DIR/script.mgn
  elif [ $TAGA_DISPLAY == "SILENT" ]; then
    mgen input $TAGA_MGEN_DIR/script.mgn > /dev/null 2> /dev/null
  else
    mgen input $TAGA_MGEN_DIR/script.mgn # >/dev/null
  fi
  

done

###############################
# Second Half of UCAST Loop
###############################
# reinit port-related vars
let i=0
# actiivated flag is okay

for target in $targetList
do
  
  let i=$i+1

  if [ $target == $MYIP ]; then
    #echo target is MYIP , skipping self... 
    let activated=0
    continue
  fi

  # use the activated flag to stagger starts and ensure only one effective loop out of the two loops
  # if not activated, continue to top
  if [ $activated -eq 0 ]; then
    continue
  fi

  let DESTPORT=$PORTBASE+$i
  
  # prep the mgen config 
  sed -e s/destination/$target/g $TAGA_MGEN_DIR/script.mgn.template > $TAGA_MGEN_DIR/script.mgn.temp  # create temp from template
  sed -e s/destport/$DESTPORT/g $TAGA_MGEN_DIR/script.mgn.temp      > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/sourceport/$SOURCEPORT/g $TAGA_MGEN_DIR/script.mgn.temp2 > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
  sed -e s/count/$MSGCOUNT/g $TAGA_MGEN_DIR/script.mgn.temp         > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/rate/$MSGRATE/g $TAGA_MGEN_DIR/script.mgn.temp2          > $TAGA_MGEN_DIR/script.mgn.temp  # toggle temp/temp2
  sed -e s/proto/$mgen_proto/g $TAGA_MGEN_DIR/script.mgn.temp       > $TAGA_MGEN_DIR/script.mgn.temp2 # toggle temp/temp2
  sed -e s/len/$MSGLEN/g $TAGA_MGEN_DIR/script.mgn.temp2            > $TAGA_MGEN_DIR/script.mgn       # finalize

  if [ $TESTTYPE == "UCAST_TCP" ]; then
     let tcpDelay=$MSGCOUNT/$MSGRATE
     #echo 10.0 OFF 1 >> $TAGA_MGEN_DIR/script.mgn       # append TCP specific stuff
     echo $tcpDelay.0 OFF 1 >> $TAGA_MGEN_DIR/script.mgn       # append TCP specific stuff
  fi

  # some cleanup
  rm $TAGA_MGEN_DIR/script.mgn.temp $TAGA_MGEN_DIR/script.mgn.temp2

  if [ $TAGA_DISPLAY == "VERBOSE" ]; then
    echo ---------------------
    cat $TAGA_MGEN_DIR/script.mgn
    echo ---------------------
    mgen input $TAGA_MGEN_DIR/script.mgn
  elif [ $TAGA_DISPLAY == "SILENT" ]; then
    mgen input $TAGA_MGEN_DIR/script.mgn > /dev/null 2> /dev/null
  else
    mgen input $TAGA_MGEN_DIR/script.mgn # >/dev/null
  fi

done

# IPERF examples
#--------------------------------------------------
#echo Running iperf on `hostname` | tee $STATUS_FILE
#sudo iperf -s -u -B 225.0.0.57 -i 10
#echo "sudo iperf -s -u -B $MYMCAST_ADDR -i 10"
#sudo iperf -s -u -B $MYMCAST_ADDR -i 10

# IPERF examples
#--------------------------------------------------
#echo Running iperf on `hostname` | tee $STATUS_FILE
#sudo iperf -s -u -B 225.0.0.57 -i 10
#echo "sudo iperf -s -u -B $MYMCAST_ADDR -i 10"
#sudo iperf -s -u -B $MYMCAST_ADDR -i 10


