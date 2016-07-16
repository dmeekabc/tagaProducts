#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

let i=255

while [ $i -gt 225 ]
do
   NETADDR=$NETADDRPART.$i
   echo
   echo processing $NETADDR
   
   $TAGA_UTILS_DIR/probe2x.sh $NETADDR &

#   ping -W 1 -c 1 $NETADDR
#  
#   if [ $? -eq 0 ]; then
#      echo $NETADDR >> /tmp/probe2Found.out
#   else
#      echo $NETADDR >> /tmp/probe2Notfound.out
#   fi
#
   let i=$i-1

done

# this is expected to be the last processing script so do the sort now

# things have changed so forct it now
sleep 5


echo Found List:
cat /tmp/probe2Found.out | sort 
echo Not Found List:
cat /tmp/probe2Notfound.out | sort 
echo Found List:
cat /tmp/probe2Found.out | sort 

echo
echo Note: Any additional probe2.sh \(ping-related\) output below indicates the lists above are not complete!
echo Note: In that case, please examine /tmp/probe2Found.out and /tmp/probe2Notfound.out directly.
echo

for i in 1 2 3 4 5  
do
   sleep 2
   echo Found List:
   cat /tmp/probe2Found.out | sort 
   echo Not Found List:
   cat /tmp/probe2Notfound.out | sort 
   echo Found List:
   cat /tmp/probe2Found.out | sort 
done

echo
echo Note: Any additional probe2.sh \(ping-related\) output below indicates the lists above are not complete!
echo Note: In that case, please examine /tmp/probe2Found.out and /tmp/probe2Notfound.out directly.
echo

