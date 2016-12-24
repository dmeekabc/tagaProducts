#!/bin/bash
#######################################################################
#
# Copyright (c) IBOA Corp 2016
#
# All Rights Reserved
#                                                                     
# Redistribution and use in source and binary forms, with or without  
# modification, are permitted provided that the following conditions 
# are met:                                                             
# 1. Redistributions of source code must retain the above copyright    
#    notice, this list of conditions and the following disclaimer.     
# 2. Redistributions in binary form must reproduce the above           
#    copyright notice, this list of conditions and the following       
#    disclaimer in the documentation and/or other materials provided   
#    with the distribution.                                            
#                                                                      
# THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS   
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED    
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE     
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR  
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT    
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR   
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF           
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT            
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE    
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH     
# DAMAGE.                                                              
#
#######################################################################

TAGA_DIR=~/scripts/taga
TAGA_DIR=/home/pi/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
#source $TAGA_CONFIG_DIR/config
source /home/pi/scripts/taga/tagaConfig/config

echo; echo $0 : $MYIP :  executing at `date`; echo


#####################################################################
# Election Process Description
#####################################################################
#
# Bully Algorithm, the preferred node bullies itself to manager
#   - if the preferred node is unavailable, other nodes elect based on lowest ip
#   - if the preferred node comes avaialable, it takes over as manager
#        - note: this can clearly have undesirable 'bouncing/thrashing' effect
#                effect if the  preferred node is unstable or in/out of range.
#
#####################################################################
# Election Process Description
#####################################################################



######################################################################
# ENABLE or DISABLE the various managers (bottom of each one wins)
######################################################################

NETWORK_MANAGER_ENABLED=0
NETWORK_MANAGER_ENABLED=1

ECHELON_MANAGER_ENABLED=1
ECHELON_MANAGER_ENABLED=0

AREA_MANAGER_ENABLED=1
AREA_MANAGER_ENABLED=0

ANNOUNCE_CANDIDATE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidate
ANNOUNCE_FILE=/tmp/managerAnnouncement.dat.$MYIP
ANNOUNCE_FILE_ALL=/tmp/managerAnnouncement.dat.*
ANNOUNCE_FILE_BASE="/tmp/managerAnnouncement.dat."

ANNOUNCE_ECHELON_CANDIDATE_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP.candidate
ANNOUNCE_ECHELON_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP
ANNOUNCE_ECHELON_FILE_ALL=/tmp/managerAnnouncementEchelon.dat.*

ANNOUNCE_ECHELONAREA_CANDIDATE_FILE=/tmp/managerAnnouncementEchelonArea.dat.$MYIP.candidate
ANNOUNCE_ECHELONAREA_FILE=/tmp/managerAnnouncementEchelonArea.dat.$MYIP
ANNOUNCE_ECHELONAREA_FILE_ALL=/tmp/managerAnnouncementEchelonArea.dat.*

ANNOUNCE_AREA_CANDIDATE_FILE=/tmp/managerAnnouncementArea.dat.$MYIP.candidate
ANNOUNCE_AREA_FILE=/tmp/managerAnnouncementArea.dat.$MYIP
ANNOUNCE_AREA_FILE_ALL=/tmp/managerAnnouncementArea.dat.*

function election {
source /home/pi/scripts/taga/tagaConfig/config
myNetId=`echo $MYIP | cut -d\. -f 3`

myEchelonManager="tbd"
myEchelon="tbd"
myEchelonList="tbd"
myNetworkList=""
myEchelonAreaNetworkList=""
myAreaNetworkList=""

preferredManager=""

echo myNetId:$myNetId

let MANAGER_FLAG=0

let DEBUG=1
let DEBUG=0

# first let's build up our sub-network list...
# NOTE: This assumes 24 bit netmask!!
# NOTE: This assumes 24 bit netmask!!
for target in $targetList
do
   compareNetId=`echo $target | cut -d\. -f 3`
   if [ $DEBUG -eq 1 ] ;then
     echo $target
     echo comparing $compareNetId $myNetId
   fi
   if [ $compareNetId == $myNetId ] ; then
      myNetworkList="$myNetworkList $target"
      myEchelonNetworkList="$myEchelonNetworkList $target"
      myEchelonAreaNetworkList="$myEchelonAreaNetworkList $target"
      myAreaNetworkList="$myAreaNetworkList $target"
   fi
done

echo $MYIP : myNetworkList:$myNetworkList
echo $MYIP : myEchelonNetworkList:$myEchelonAreaNetworkList
echo $MYIP : myEchelonAreaNetworkList:$myEchelonAreaNetworkList
echo $MYIP : myAreaNetworkList:$myAreaNetworkList

if echo $ECHELON4_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 4
  for ip in `echo $ECHELON4_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=4
         myEchelonList=$ECHELON4_LIST
         myEchelonAreaList=$ECHELON4_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 4
              echo $MYIP : I am Manager of Echelon 4 > /tmp/networkElectEchelon4.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 4
              sudo rm /tmp/networkElectEchelon4.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         preferredManager=$ip
         break
      fi
  done
elif echo $ECHELON3_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 3
  for ip in `echo $ECHELON3_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=3
         myEchelonList=$ECHELON3_LIST
         myEchelonAreaList=$ECHELON3_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 3
              echo $MYIP : I am Manager of Echelon 3 > /tmp/networkElectEchelon3.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 3
              sudo rm /tmp/networkElectEchelon3.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         preferredManager=$ip
         break
      fi
  done
elif echo $ECHELON2_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 2
  for ip in `echo $ECHELON2_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=2
         myEchelonList=$ECHELON2_LIST
         myEchelonAreaList=$ECHELON2_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 2
              echo $MYIP : I am Manager of Echelon 2 > /tmp/networkElectEchelon2.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 2
              sudo rm /tmp/networkElectEchelon2.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         preferredManager=$ip
         break
      fi
  done
elif echo $ECHELON1_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 1
  for ip in `echo $ECHELON1_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=1
         myEchelonList=$ECHELON1_LIST
         myEchelonAreaList=$ECHELON1_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 1
              echo $MYIP : I am Manager of Echelon 1 > /tmp/networkElectEchelon1.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 1
              sudo rm /tmp/networkElectEchelon1.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         preferredManager=$ip
         break
      fi
  done
elif echo $TAGAXXX_LIST_ACTIVE | grep $MYIP ; then 
  # Special Handing for TAGAXXX
  echo I am a candidate for network manager for network:$myNetId within echelon TAGAXXX-1
  # Special Handing for TAGAXXX
  for ip in `echo $TAGAXXX_LIST_ACTIVE`
  do
      echo $ip
      # Special Handing for TAGAXXX (break after first ip checked)
      #compareNetId=`echo $ip | cut -d\. -f 3`
      # Special Handing for TAGAXXX (break after first ip checked)
      #if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=TAGAXXX-1
         myEchelonList=$TAGAXXX_LIST_ACTIVE
         myEchelonAreaList=$TAGAXXX_LIST_ACTIVE
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon TAGAXXX-1
              echo $MYIP : I am Manager of Echelon TAGAXXX-1 > /tmp/networkElectEchelonTAGAXXX-1.dat
              let MANAGER_FLAG=1
              # Special Handing for TAGAXXX
              myNetworkList=$TAGAXXX_LIST_ACTIVE
              myAreaNetworkList=$TAGAXXX_LIST_ACTIVE
              myEchelonAreaNetworkList=$TAGAXXX_LIST_ACTIVE
         else
              echo I am not the network manager for network:$myNetId within echelon TAGAXXX-1
              sudo rm /tmp/networkElectEchelonTAGAXXX-1.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         preferredManager=$ip
         break
      # Special Handing for TAGAXXX (break after first ip checked)
      #fi

      #### Special Handing for TAGAXXX (break after first ip checked)
      #### Special Handing for TAGAXXX (break after first ip checked)
      ####break

  done
else
  echo I am not a candidate for network manager 
fi

} # end function election


# dlm temp, currently election and re-election are identical but that is expected to change
# dlm temp, currently election and re-election are identical but that is expected to change

function re-election-new {

   echo `date` : $MYIP : Re-election in process!
   source /home/pi/scripts/taga/tagaConfig/config
   myNetId=`echo $MYIP | cut -d\. -f 3`

   for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20            #\
            #21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40   #\
            #41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60  # 

   do
      echo `date` : $i of 60: re-election in process
      sleep 1

      rm $ANNOUNCE_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         # Somebody else has claimed manager or candidacy so let's abort!
         return
      fi

      rm $ANNOUNCE_ECHELON_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         # Somebody else has claimed manager or candidacy so let's abort!
         return
      fi

      rm $ANNOUNCE_ECHELONAREA_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         # Somebody else has claimed manager or candidacy so let's abort!
         return
      fi

      rm $ANNOUNCE_AREA_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         # Somebody else has claimed manager or candidacy so let's abort!
         return
      fi

   done


   # OKAY, now do a RANDOM DELAY, first one out wins!!!
   # OKAY, now do a RANDOM DELAY, first one out wins!!!
   # OKAY, now do a RANDOM DELAY, first one out wins!!!

   # dlm temp, note, this leaves a small window of ties, which we must add post-processing to identify and resolve that case
   # dlm temp, note, this leaves a small window of ties, which we must add post-processing to identify and resolve that case
   # dlm temp, note, this leaves a small window of ties, which we must add post-processing to identify and resolve that case
   # dlm temp, note, this leaves a small window of ties, which we must add post-processing to identify and resolve that case

   randomDelay=`$tagaUtilsDir/iboaRandom.sh`
   echo Random Delay: $randomDelay

   $tagaUtilsDir/iboaDelay.sh $randomDelay


   # if we get here, we are either going to be the new manager or we are in an extreme tie condition
    # dlm temp, well testing tells us this is normal so let's add a filter

   for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20            #\
            #21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40   #\
            #41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60  # 
   do
      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag

      echo $j: TieBreaker Section
       
      for target in $myNetworkList
      do
         echo $j: TieBreaker Section : checking manager from target:$target
         ls $ANNOUNCE_FILE_ALL 
         if ls $ANNOUNCE_FILE_ALL | grep $target ; then
            # compare $target to $MYIP
            echo compare target:$target to myip:$MYIP
            compareValue=`echo $target | cut -d\. -f 4`
            myValue=`echo $MYIP | cut -d\. -f 4`
            echo comparing compareVale;$compareValue to myValue:$myValue

            if [ $compareValue -lt $myValue ] ; then
               # I relinquish
               echo I relinquish
               return 0
            else
               # I do not relinquish, yet at least...
               echo I do not relinquish, yet at least...
            fi 
         fi
      done
   done

   # dlm temp, for now, just claim to be a candidate and even manager!
   # dlm temp, for now, just claim to be a candidate and even manager!

   # create the candidate file
   touch $ANNOUNCE_CANDIDATE_FILE 
   touch $ANNOUNCE_AREA_CANDIDATE_FILE 
   touch $ANNOUNCE_ECHELON_CANDIDATE_FILE 
   touch $ANNOUNCE_ECHELONAREA_CANDIDATE_FILE 

   chmod 777 $ANNOUNCE_CANDIDATE_FILE 
   chmod 777 $ANNOUNCE_AREA_CANDIDATE_FILE 
   chmod 777 $ANNOUNCE_ECHELON_CANDIDATE_FILE 
   chmod 777 $ANNOUNCE_ECHELONAREA_CANDIDATE_FILE 

   # distribute the candidate file

   echo $MYIP : myNetworkList:$myNetworkList
   echo $MYIP : myEchelonList:$myEchelonList
   echo $MYIP : myEchelonAreaList:$myEchelonList
   echo $MYIP : myEchelonAreaNetworkList:$myEchelonAreaNetworkList
   echo $MYIP : myAreaNetworkList:$myAreaNetworkList

   identy=/home/pi/.ssh/id_rsa

   if [ $NETWORK_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_CANDIDATE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp
   done
   fi

   if [ $ECHELON_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myEchelonAreaNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_ECHELON_CANDIDATE_FILE 
        echo Distributing $ANNOUNCE_ECHELONAREA_CANDIDATE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp
      echo sudo scp -i $identy $ANNOUNCE_ECHELONAREA_CANDIDATE_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_ECHELONAREA_CANDIDATE_FILE  $loginId@$target:/tmp
   done
   fi

   if [ $AREA_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myAreaNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_AREA_CANDIDATE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_AREA_CANDIDATE_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_AREA_CANDIDATE_FILE  $loginId@$target:/tmp
   done
   fi


   # dlm temp , this is key!!
   # dlm temp , this is key!!
   let MANAGER_FLAG=1


} # end function re-election-new


function re-election {
source /home/pi/scripts/taga/tagaConfig/config
myNetId=`echo $MYIP | cut -d\. -f 3`

myNetworkList=""
myEchelonManager="tbd"
myEchelon="tbd"
myEchelonList="tbd"
myEchelonAreaList="tbd"
myEchelonAreaNetworkList=""
myAreaNetworkList=""

echo myNetId:$myNetId

let MANAGER_FLAG=0

let DEBUG=1
let DEBUG=0

# first let's build up our sub-network list...
# NOTE: This assumes 24 bit netmask!!
# NOTE: This assumes 24 bit netmask!!
for target in $targetList
do
   compareNetId=`echo $target | cut -d\. -f 3`
   if [ $DEBUG -eq 1 ] ;then
     echo $target
     echo comparing $compareNetId $myNetId
   fi
   if [ $compareNetId == $myNetId ] ; then
      myNetworkList="$myNetworkList $target"
      myEchelonAreaNetworkList="$myEchelonAreaNetworkList $target"
      myAreaNetworkList="$myAreaNetworkList $target"
   fi
done

echo $MYIP : myNetworkList:$myNetworkList
echo $MYIP : myAreaNetworkList:$myAreaNetworkList
echo $MYIP : myEchelonAreaNetworkList:$myEchelonAreaNetworkList

if echo $ECHELON4_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 4
  for ip in `echo $ECHELON4_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=4
         myEchelonList=$ECHELON4_LIST
         myEchelonAreaList=$ECHELON4_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 4
              echo $MYIP : I am Manager of Echelon 4 > /tmp/networkElectEchelon4.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 4
              sudo rm /tmp/networkElectEchelon4.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         break
      fi
  done
elif echo $ECHELON3_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 3
  for ip in `echo $ECHELON3_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=3
         myEchelonList=$ECHELON3_LIST
         myEchelonAreaList=$ECHELON3_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 3
              echo $MYIP : I am Manager of Echelon 3 > /tmp/networkElectEchelon3.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 3
              sudo rm /tmp/networkElectEchelon3.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         break
      fi
  done
elif echo $ECHELON2_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 2
  for ip in `echo $ECHELON2_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=2
         myEchelonList=$ECHELON2_LIST
         myEchelonAreaList=$ECHELON2_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 2
              echo $MYIP : I am Manager of Echelon 2 > /tmp/networkElectEchelon2.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 2
              sudo rm /tmp/networkElectEchelon2.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         break
      fi
  done
elif echo $ECHELON1_LIST | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon 1
  for ip in `echo $ECHELON1_LIST`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 3`
      if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=1
         myEchelonList=$ECHELON1_LIST
         myEchelonAreaList=$ECHELON1_LIST
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon 1
              echo $MYIP : I am Manager of Echelon 1 > /tmp/networkElectEchelon1.dat
              let MANAGER_FLAG=1
         else
              echo I am not the network manager for network:$myNetId within echelon 1
              sudo rm /tmp/networkElectEchelon1.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         break
      fi
  done
elif echo $TAGAXXX_LIST_ACTIVE | grep $MYIP ; then 
  # Special Handing for TAGAXXX
  echo I am a candidate for network manager for network:$myNetId within echelon TAGAXXX-1
  # Special Handing for TAGAXXX
  for ip in `echo $TAGAXXX_LIST_ACTIVE`
  do
      echo $ip
      # Special Handing for TAGAXXX (break after first ip checked)
      #compareNetId=`echo $ip | cut -d\. -f 3`
      # Special Handing for TAGAXXX (break after first ip checked)
      #if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=TAGAXXX-1
         myEchelonList=$TAGAXXX_LIST_ACTIVE
         myEchelonAreaList=$TAGAXXX_LIST_ACTIVE
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon TAGAXXX-1
              echo $MYIP : I am Manager of Echelon TAGAXXX-1 > /tmp/networkElectEchelonTAGAXXX-1.dat
              let MANAGER_FLAG=1
              # Special Handing for TAGAXXX
              myNetworkList=$TAGAXXX_LIST_ACTIVE
              myAreaNetworkList=$TAGAXXX_LIST_ACTIVE
              myEchelonAreaNetworkList=$TAGAXXX_LIST_ACTIVE
         else
              echo I am not the network manager for network:$myNetId within echelon TAGAXXX-1
              sudo rm /tmp/networkElectEchelonTAGAXXX-1.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         break
      # Special Handing for TAGAXXX (break after first ip checked)
      #fi

      #### Special Handing for TAGAXXX (break after first ip checked)
      #### Special Handing for TAGAXXX (break after first ip checked)
      ####break

  done
else
  echo I am not a candidate for network manager 
fi

} # end function re-election




function doManager {
   echo `date` : doManager
   touch $ANNOUNCE_FILE 
   touch $ANNOUNCE_AREA_FILE 
   touch $ANNOUNCE_ECHELON_FILE 
   touch $ANNOUNCE_ECHELONAREA_FILE 

   sudo chmod 777 $ANNOUNCE_FILE 
   sudo chmod 777 $ANNOUNCE_ECHELON_FILE 
   sudo chmod 777 $ANNOUNCE_ECHELONAREA_FILE 
   sudo chmod 777 $ANNOUNCE_AREA_FILE 

   echo $MYIP : myNetworkList:$myNetworkList
   echo $MYIP : myEchelonList:$myEchelonList
   echo $MYIP : myEchelonAreaList:$myEchelonList
   echo $MYIP : myEchelonAreaNetworkList:$myEchelonAreaNetworkList
   echo $MYIP : myAreaNetworkList:$myAreaNetworkList

   identy=/home/pi/.ssh/id_rsa

   if [ $NETWORK_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
   done
   fi

   if [ $ECHELON_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myEchelonAreaNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_ECHELON_FILE 
        echo Distributing $ANNOUNCE_ECHELONAREA_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp
      echo sudo scp -i $identy $ANNOUNCE_ECHELONAREA_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_ECHELONAREA_FILE  $loginId@$target:/tmp
   done
   fi

   if [ $AREA_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myAreaNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_AREA_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp
   done
   fi

   # dlm temp, note this is bully algorithm 
   # dlm temp, exit if I am not the preferred manager and the preferred manager is advertising

   PREFERRED_MANAGER_FILE=$ANNOUNCE_FILE_BASE.$preferredManager
   if [ $MYIP != $preferredManager ]; then
   if [ -f $PREFERRED_MANAGER_FILE ]; then 
      echo $MYIP : Preferred Manager is advertising, I am relinquishing management duties!
      let MANAGER_FLAG=0
   fi 
   fi

   return 0
}

function verifyManager {
   echo `date` : verifyManager

   let retCode=0
   let managerCount=0

   # delete old files
   rm $ANNOUNCE_FILE_ALL               2>/dev/null
   rm $ANNOUNCE_ECHELON_FILE_ALL       2>/dev/null
   rm $ANNOUNCE_ECHELONAREA_FILE_ALL   2>/dev/null
   rm $ANNOUNCE_AREA_FILE_ALL          2>/dev/null

   #sleep $MANAGER_AUDIT_INTERVAL
   $tagaUtilsDir/iboaDelay.sh $MANAGER_AUDIT_INTERVAL

   for target in $targetList
   do
   if [ -f $ANNOUNCE_FILE ] ; then
      echo Info: File $ANNOUNCE_FILE.$target Exists!
      let managerCount=$managerCount+1
      echo managerCount:$managerCount
   fi 
   done

   if [ $managerCount -eq 0 ] ; then
      echo ALARM:MAJOR: $MYIP : No Manager Identified for this network! 
      let retCode=2
   elif [ $managerCount -gt 1 ] ; then
      echo ALARM:MINOR: $MYIP : Multiple Managers Identified for this network! 
      let retCode=1
   else
      echo INFO: $MYIP : Single Manager Verified for this network! 
      let retCode=0
   fi

   #managerToVerify=$1
   #sudo ping -c 1 $managerToVerify >/tmp/managerVerify.out
   #retCode=$?

   return $retCode

}


function maintain {

# Maintain the election
while true
do

   let retCode=0

   # resource the config
   source /home/pi/scripts/taga/tagaConfig/config

   ANNOUNCE_CANDIDATE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidate
   ANNOUNCE_FILE=/tmp/managerAnnouncement.dat.$MYIP
   ANNOUNCE_FILE_ALL=/tmp/managerAnnouncement.dat.*

   ANNOUNCE_ECHELON_CANDIDATE_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP.candidate
   ANNOUNCE_ECHELON_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP
   ANNOUNCE_ECHELON_FILE_ALL=/tmp/managerAnnouncementEchelon.dat.*

   ANNOUNCE_ECHELONAREA_CANDIDATE_FILE=/tmp/managerAnnouncementEchelonArea.dat.$MYIP.candidate
   ANNOUNCE_ECHELONAREA_FILE=/tmp/managerAnnouncementEchelonArea.dat.$MYIP
   ANNOUNCE_ECHELONAREA_FILE_ALL=/tmp/managerAnnouncementEchelonArea.dat.*

   ANNOUNCE_AREA_CANDIDATE_FILE=/tmp/managerAnnouncementArea.dat.$MYIP.candidate
   ANNOUNCE_AREA_FILE=/tmp/managerAnnouncementArea.dat.$MYIP
   ANNOUNCE_AREA_FILE_ALL=/tmp/managerAnnouncementArea.dat.*


   # dlm temp find me
   #rm $ANNOUNCE_FILE_ALL
   #rm $ANNOUNCE_ECHELON_FILE_ALL
   #rm $ANNOUNCE_ECHELONAREA_FILE_ALL
   #rm $ANNOUNCE_AREA_FILE_ALL

   if  [ $MANAGER_FLAG -eq 1 ] ; then
      doManager
      let retCode=$?
   else
      # Verify manager still exists or promote myself
      echo; date
      echo;echo
      echo My Echelon:$myEchelon : My Echelon Manager:$myEchelonManager 
      echo Verifying My Echelon Manager is Healthy: $myEchelonManager
      #verifyManager $myEchelonManager
      verifyManager 
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         echo Single Manager Verified
      elif [ $retCode -eq 1 ]; then
         echo Multiple Managers Verified
         echo Enter Re-election process now!

         # call initial election to allow bully algorithm to function
         # in the event the IP addresses (provides our identity process) appear after init
         election
         # if we stil have no manager, do the re-election , note this is temporary until bully comes back
         #re-election
         re-election-new

      else
         echo No Manager Verified
         echo Enter Re-election process now!

         # call initial election to allow bully algorithm to function
         # in the event the IP addresses (provides our identity process) appear after init
         election
         # if we stil have no manager, do the re-election , note this is temporary until bully comes back
         #re-election
         re-election-new

      fi
   fi

   sleep 5

done

} # end of maintain function


##################################
# MAIN
##################################

# Do the initial election
election

# Maintain the election
maintain

