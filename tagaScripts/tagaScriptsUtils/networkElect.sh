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
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
#source $TAGA_CONFIG_DIR/config
source /home/pi/scripts/taga/tagaConfig/config

echo; echo $0 : $MYIP :  executing at `date`; echo

ANNOUNCE_FILE=/tmp/managerAnnouncement.dat.$MYIP
ANNOUNCE_FILE_ALL=/tmp/managerAnnouncement.dat.*

ANNOUNCE_ECHELONAREA_FILE=/tmp/managerAnnouncementEchelonArea.dat.$MYIP
ANNOUNCE_ECHELONAREA_FILE_ALL=/tmp/managerAnnouncementEchelonArea.dat.*

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

echo myNetId:$myNetId

let MANAGER_FLAG=0

let DEBUG=1
let DEBUG=0

# first let's build up our sub-network list...
# NOTE: This assumes 24 bit sumbask!!
# NOTE: This assumes 24 bit sumbask!!
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
elif echo $SRW_LIST_ACTIVE | grep $MYIP ; then 
  # Special Handing for SRW
  echo I am a candidate for network manager for network:$myNetId within echelon SRW-1
  # Special Handing for SRW
  for ip in `echo $SRW_LIST_ACTIVE`
  do
      echo $ip
      # Special Handing for SRW (break after first ip checked)
      #compareNetId=`echo $ip | cut -d\. -f 3`
      # Special Handing for SRW (break after first ip checked)
      #if [ $compareNetId == $myNetId ] ; then
         myEchelonManager=$ip
         myEchelon=SRW-1
         myEchelonList=$SRW_LIST_ACTIVE
         if [ $ip == $MYIP ] ; then
              echo I am the network manager for network:$myNetId within echelon SRW-1
              echo $MYIP : I am Manager of Echelon SRW-1 > /tmp/networkElectEchelonSRW-1.dat
              let MANAGER_FLAG=1
              # Special Handing for SRW
              myNetworkList=$SRW_LIST_ACTIVE
              myAreaNetworkList=$SRW_LIST_ACTIVE
              myEchelonAreaNetworkList=$SRW_LIST_ACTIVE
         else
              echo I am not the network manager for network:$myNetId within echelon SRW-1
              sudo rm /tmp/networkElectEchelonSRW-1.dat 2>/dev/null
         fi
         echo the network manager for my network is $ip
         break
      # Special Handing for SRW (break after first ip checked)
      #fi

      #### Special Handing for SRW (break after first ip checked)
      #### Special Handing for SRW (break after first ip checked)
      ####break

  done
else
  echo I am not a candidate for network manager 
fi

} # end function election

function doManager {
   echo `date` : doManager
   touch $ANNOUNCE_FILE 
   touch $ANNOUNCE_AREA_FILE 
   touch $ANNOUNCE_ECHELONAREA_FILE 
   sudo chmod 777 $ANNOUNCE_FILE 
   sudo chmod 777 $ANNOUNCE_AREA_FILE 
   sudo chmod 777 $ANNOUNCE_ECHELONAREA_FILE 
   echo $MYIP : myEchelonList:$myEchelonList
   echo $MYIP : myNetworkList:$myNetworkList
   echo $MYIP : myEchelonAreaNetworkList:$myEchelonAreaNetworkList
   echo $MYIP : myAreaNetworkList:$myAreaNetworkList

   identy=/home/pi/.ssh/id_rsa

   for target in $myNetworkList
   do
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
   done

   for target in $myEchelonAreaNetworkList
   do
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_ECHELONAREA_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_ECHELONAREA_FILE  $loginId@$target:/tmp
   done

   for target in $myAreaNetworkList
   do
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp
      sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp
   done

   return 0
}

function verifyManager {
   echo `date` : verifyManager

   let retCode=0
   let managerCount=0

   # delete old files
   rm $ANNOUNCE_FILE_ALL 2>/dev/null
   rm $ANNOUNCE_AREA_FILE_ALL 2>/dev/null

   #sleep $MANAGER_AUDIT_INTERVAL
   $tagaUtilsDir/iboaDelay.sh $MANAGER_AUDIT_INTERVAL

   for target in $targetList
   do
   if [ -f $ANNOUNCE_FILE ] ; then
      echo Info: File $ANNOUNCE_FILE Exists!
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
   ANNOUNCE_FILE=/tmp/managerAnnouncement.dat.$MYIP

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
         election
      else
         echo No Manager Verified
         echo Enter Re-election process now!
         election
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

