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
netCheckSum=`sum $tagaConfigDir/targetList.sh | cut -c1-5`

echo; echo $0 : $MYIP :  executing at `date`; echo

# dlm temp, consider if we should call relinquish more often to be more responsive
# dlm temp, consider if we should call relinquish more often to be more responsive
# dlm temp, consider if we should call relinquish more often to be more responsive
# dlm temp, consider if we should call relinquish more often to be more responsive

# dlm temp, note that the 20 and 60 seconds blocks both kick in before election so undesirable non-responsive impact
# dlm temp, note that the 20 and 60 seconds blocks both kick in before election so undesirable non-responsive impact
# dlm temp, note that the 20 and 60 seconds blocks both kick in before election so undesirable non-responsive impact
# dlm temp, note that the 20 and 60 seconds blocks both kick in before election so undesirable non-responsive impact

#####################################################################
# Election Process Description - Begin
#####################################################################
#
# Bully Algorithm, the preferred node bullies itself to manager
#   - if the preferred node is unavailable, other nodes elect based on lowest ip
#   - if the preferred node comes avaialable, it takes over as manager
#        - note: this can clearly have undesirable 'bouncing/thrashing' effect
#                effect if the  preferred node is unstable or in/out of range.
#        - note: clever selection of preferred node and/or dummy node usage
#                can reduce or mitigate such instability.
#
#####################################################################
# Election Process Description - End
#####################################################################

#####################################################################
# Version Info
#####################################################################
#
#  Version 1: IBOA Dec 2016 
#       INITIAL IBOA TAGA TAGAXXX VERSION: 
#       GitHub December 2016 updates
#       commit aebfe22775d546d83a1c01208ac7bb10924d23a9
#       Author: Darrin Meek <darrinmeek@aol.com>
#       Date:   Sun Dec 25 20:59:07 2016 +0000
#       NETWORK, ECHELON, AREA, ECHELONAREA ELECTION TYPES
#       Network type complete, other types placeholders only
#
#  Version 1a: DMeek and Tri Pham Jan 2017
#       Echelon Type Implemented and Functional
#       Code Improvements per Tri Pham recommendations and implementation
#       EchelonArea Type Removed, Area Type Placeholder only
#
#  Version 1b: IBOA Jan 2017
#       Area Type Implemented and Functional
#
#
#####################################################################
# End Version Info
#####################################################################


######################################################################
# ENABLE or DISABLE the various managers (bottom of each one wins)
######################################################################

NETWORK_MANAGER_ENABLED=0
NETWORK_MANAGER_ENABLED=1

ECHELON_MANAGER_ENABLED=0
ECHELON_MANAGER_ENABLED=1

AREA_MANAGER_ENABLED=1
AREA_MANAGER_ENABLED=0

##ANNOUNCE_CANDIDATE_COMPLETE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidateComplete
##ANNOUNCE_CANDIDATE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidate
##ANNOUNCE_FILE_NET_CHECKSUM=/tmp/managerAnnouncement.dat.$MYIP.$netCheckSum
##ANNOUNCE_FILE=/tmp/managerAnnouncement.dat.$MYIP
##ANNOUNCE_FILE_ALL=/tmp/managerAnnouncement.dat.*
##ANNOUNCE_FILE_BASE="/tmp/managerAnnouncement.dat."

ANNOUNCE_NETWORK_CANDIDATE_COMPLETE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidateComplete
ANNOUNCE_NETWORK_CANDIDATE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidate
ANNOUNCE_NETWORK_FILE_NET_CHECKSUM=/tmp/managerAnnouncement.dat.$MYIP.$netCheckSum
ANNOUNCE_NETWORK_FILE=/tmp/managerAnnouncement.dat.$MYIP
ANNOUNCE_NETWORK_FILE_ALL=/tmp/managerAnnouncement.dat.*
ANNOUNCE_NETWORK_FILE_BASE="/tmp/managerAnnouncement.dat."

ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP.candidateComplete
ANNOUNCE_ECHELON_CANDIDATE_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP.candidate
ANNOUNCE_ECHELON_FILE_NET_CHECKSUM=/tmp/managerAnnouncementEchelon.dat.$MYIP.$netCheckSum
ANNOUNCE_ECHELON_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP
ANNOUNCE_ECHELON_FILE_ALL=/tmp/managerAnnouncementEchelon.dat.*
ANNOUNCE_ECHELON_FILE_BASE="/tmp/managerAnnouncementEchelon.dat."

ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE=/tmp/managerAnnouncementArea.dat.$MYIP.candidateComplete
ANNOUNCE_AREA_CANDIDATE_FILE=/tmp/managerAnnouncementArea.dat.$MYIP.candidate
ANNOUNCE_AREA_FILE_NET_CHECKSUM=/tmp/managerAnnouncementArea.dat.$MYIP.$netCheckSum
ANNOUNCE_AREA_FILE=/tmp/managerAnnouncementArea.dat.$MYIP
ANNOUNCE_AREA_FILE_ALL=/tmp/managerAnnouncementArea.dat.*
ANNOUNCE_AREA_FILE_BASE="/tmp/managerAnnouncementArea.dat."


let MANAGER_FLAG=0
let ECHELON_MANAGER_FLAG=0
let AREA_MANAGER_FLAG=0

let DEBUG=0
let DEBUG=1

myEchelon="tbd"
myArea="tbd"

myNetworkList=""
myEchelonList="" 
myAreaList=""

preferredNetworkManager="tbd"
preferredEchelonManager="tbd"
preferredAreaManager="tbd"

##############################################
# Election Context Configurations
##############################################

function networkContext {
   # Network Context
   ANNOUNCE_CANDIDATE_COMPLETE_FILE=$ANNOUNCE_NETWORK_CANDIDATE_COMPLETE_FILE
   ANNOUNCE_CANDIDATE_FILE=$ANNOUNCE_NETWORK_CANDIDATE_FILE
   ANNOUNCE_FILE_NET_CHECKSUM=$ANNOUNCE_NETWORK_FILE_NET_CHECKSUM
   ANNOUNCE_FILE=$ANNOUNCE_NETWORK_FILE
   ANNOUNCE_FILE_ALL=$ANNOUNCE_NETWORK_FILE_ALL
   ANNOUNCE_FILE_BASE=$ANNOUNCE_NETWORK_FILE_BASE
   context=network
   contextList=$myNetworkList
   preferredManager=$preferredNetworkManager
}

function echelonContext {
   # Echelon Context
   ANNOUNCE_CANDIDATE_COMPLETE_FILE=$ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE
   ANNOUNCE_CANDIDATE_FILE=$ANNOUNCE_ECHELON_CANDIDATE_FILE
   ANNOUNCE_FILE_NET_CHECKSUM=$ANNOUNCE_ECHELON_FILE_NET_CHECKSUM
   ANNOUNCE_FILE=$ANNOUNCE_ECHELON_FILE
   ANNOUNCE_FILE_ALL=$ANNOUNCE_ECHELON_FILE_ALL
   ANNOUNCE_FILE_BASE=$ANNOUNCE_ECHELON_FILE_BASE
   context=echelon
   contextList=$myEchelonList
   preferredManager=$preferredEchelonManager
}

function areaContext {
   # Area Context
   ANNOUNCE_CANDIDATE_COMPLETE_FILE=$ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE
   ANNOUNCE_CANDIDATE_FILE=$ANNOUNCE_AREA_CANDIDATE_FILE
   ANNOUNCE_FILE_NET_CHECKSUM=$ANNOUNCE_AREA_FILE_NET_CHECKSUM
   ANNOUNCE_FILE=$ANNOUNCE_AREA_FILE
   ANNOUNCE_FILE_ALL=$ANNOUNCE_AREA_FILE_ALL
   ANNOUNCE_FILE_BASE=$ANNOUNCE_AREA_FILE_BASE
   context=area
   contextList=$myAreaList
   preferredManager=$preferredAreaManager
}


##############################################
# Function Election
##############################################

function election {

# reinit these each time election function is called so they don't grow forever
myNetworkList=""
myEchelonList="" 
myAreaList=""

source /home/pi/scripts/taga/tagaConfig/config

# dlm temp changed 3 jan 2017
if echo $targetList | grep $MYIP ; then
   echo okay, I am in the target list >/dev/null
   myNetId=`echo $MYIP | cut -d\. -f 1-3`
else
   echo Notice: I am not in the target list so I should have no Net Id for network elect 
   echo purposes and should not participate in any election processes.
   myNetId=""
   exit
fi


if echo $ECHELON4_LIST | grep $MYIP ; then
   echo okay, I am in the echelon4 list >/dev/null
   myEchelon=4
   myEchelonList=$ECHELON4_LIST 
   #preferredEchelonManager=`echo $ECHELON4_LIST | cut -d\. -f 1-4 | cut -d" " -f 1`
   preferredEchelonManager=`echo $ECHELON4_LIST | cut -d" " -f 1`
elif echo $ECHELON3_LIST | grep $MYIP ; then
   echo okay, I am in the echelon3 list >/dev/null
   myEchelon=3
   myEchelonList=$ECHELON3_LIST 
   #preferredEchelonManager=`echo $ECHELON3_LIST | cut -d\. -f 1-4 | cut -d" " -f 1`
   preferredEchelonManager=`echo $ECHELON3_LIST | cut -d" " -f 1`
elif echo $ECHELON2_LIST | grep $MYIP ; then
   echo okay, I am in the echelon2 list >/dev/null
   myEchelon=2
   myEchelonList=$ECHELON2_LIST 
   #preferredEchelonManager=`echo $ECHELON3_LIST | cut -d\. -f 1-4 | cut -d" " -f 1`
   preferredEchelonManager=`echo $ECHELON2_LIST | cut -d" " -f 1`
elif echo $ECHELON1_LIST | grep $MYIP ; then
   echo okay, I am in the echelon1 list >/dev/null
   myEchelon=1
   myEchelonList=$ECHELON1_LIST 
   #preferredEchelonManager=`echo $ECHELON1_LIST | cut -d\. -f 1-4 | cut -d" " -f 1`
   preferredEchelonManager=`echo $ECHELON1_LIST | cut -d" " -f 1`
else
   echo Notice: I am not in any echelon list so I should have no echelon Id for echelon manager elect purposes and should not participate in any echelon election processes.
   myEchelon=""
   myEchelonList="" 
   # We might be an TAGAXXX node.  
   #exit
fi


echo TTTTTT my prrferredEchelonManagelonManager $preferredEchelonManager
# we are in this echelon, are we the preferred echelon manager?
if [ $preferredEchelonManager == $MYIP ]; then 
     echo I am the preferred echelon manager for echelon echelon $myEchelon
     echo $MYIP : I am preferred Manager of Echelon $myEchelon > /tmp/networkElectEchelon.dat
     let ECHELON_MANAGER_FLAG=1
fi

echo myNetId:$myNetId
echo myEchelon:$myEchelon

# network management block
# first let's build up our sub-network list...
# NOTE: This assumes 24 bit netmask!!
# NOTE: This assumes 24 bit netmask!!
for target in $targetList
do
   compareNetId=`echo $target | cut -d\. -f 1-3`
   if [ $DEBUG -eq 1 ] ;then
     echo $target
     echo comparing $compareNetId $myNetId
   fi
   if [ $compareNetId == $myNetId ] ; then
      myNetworkList="$myNetworkList $target"
      myAreaList="$myAreaList $target"
   fi
done


echo $MYIP : myNetworkList:$myNetworkList
echo $MYIP : myEchelonList:$myEchelonList
echo $MYIP : myAreaList:$myAreaList

echo $MYIP : myNetworkList:$myNetworkList                        > /tmp/myNetworkList.dat
echo $MYIP : myEchelonList:$myEchelonList                        > /tmp/myEchelonList.dat
echo $MYIP : myAreaList:$myAreaList                              > /tmp/myAreaList.dat


if echo $myEchelonList | grep $MYIP ; then 
  echo I am a candidate for network manager for network:$myNetId within echelon $myEchelon
  for ip in `echo $myEchelonList`
  do
      echo $ip
      compareNetId=`echo $ip | cut -d\. -f 1-3`

      if [ $DEBUG -eq 1 ] ;then
        echo 00000 $ip
        echo 1111111 $target
        echo 22222222 comparing $compareNetId $myNetId
      fi

      if [ $compareNetId == $myNetId ] ; then
         if [ $ip == $MYIP ] ; then
              echo I am the preferred network manager for network:$myNetId within echelon $myEchelon
              echo $MYIP : I am preferred Manager of Echelon $myEchelon > /tmp/networkElectEchelon.dat
              let MANAGER_FLAG=1
         else
              echo I am not the preferred network manager for network:$myNetId within echelon $myEchelon
              sudo rm /tmp/networkElectEchelon.dat 2>/dev/null
         fi
         echo the preferred network manager for my network is $ip
         preferredNetworkManager=$ip
         break
      fi
  done
elif echo $TAGAXXX_LIST_ACTIVE | grep $MYIP ; then 


  # dlm temp, still need to do this!!
  # dlm temp, still need to do this!!
  # dlm temp, still need to do this!!
  # dlm temp, still need to do this!!
  # dlm temp, still need to do this!!

  myEchelonList=$TAGAXXX_LIST_ACTIVE
  myEchelon=TAGAXXX-1

  # we are in this echelon, are we the preferred echelon manager?
  #if echo $ECHELON4_LIST | cut -d\. -f 1-4 | grep $MYIP ; then 
  #   echo I am the preferred echelon manager for echelon echelon 4
  #   echo $MYIP : I am preferred Manager of Echelon 4 > /tmp/echelonElectEchelon4.dat
  #   preferredEchelonManager=$MYIP
  #   let ECHELON_MANAGER_FLAG=1
  #fi

  # Special Handing for TAGAXXX
  echo I am a candidate for network manager for network:$myNetId within echelon TAGAXXX-1
  # Special Handing for TAGAXXX
  for ip in `echo $TAGAXXX_LIST_ACTIVE`
  do
      echo $ip
      # Special Handing for TAGAXXX (break after first ip checked)
      #compareNetId=`echo $ip | cut -d\. -f 1-3`
      # Special Handing for TAGAXXX (break after first ip checked)
      #if [ $compareNetId == $myNetId ] ; then
         #myEchelon=TAGAXXX-1
         #myEchelonList=$TAGAXXX_LIST_ACTIVE
         #myEchelonAreaList=$TAGAXXX_LIST_ACTIVE
         if [ $ip == $MYIP ] ; then
              echo I am the preferred network manager for network:$myNetId within echelon TAGAXXX-1
              echo $MYIP : I am preferred Manager of Echelon TAGAXXX-1 > /tmp/networkElectEchelonTAGAXXX-1.dat
              let MANAGER_FLAG=1
              #let ECHELON_MANAGER_FLAG=1
              # Special Handing for TAGAXXX
              myNetworkList=$TAGAXXX_LIST_ACTIVE
              myAreaList=$TAGAXXX_LIST_ACTIVE
              #myEchelonList=$TAGAXXX_LIST_ACTIVE
              #myEchelonAreaList=$TAGAXXX_LIST_ACTIVE
         else
              echo I am not the preferred network manager for network:$myNetId within echelon TAGAXXX-1
              sudo rm /tmp/networkElectEchelonTAGAXXX-1.dat 2>/dev/null
         fi
         echo the preferred network manager for my network is $ip
         preferredNetworkManager=$ip
         #preferredEchelonManager=$ip
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




function electionLoopFunction {

      let j=$1

      ##############################
      # Election Loop
      ##############################

      #for target in $myNetworkList
      for target in $contextList
      do
         echo $j: TieBreaker Section : checking $context manager from target:$target
         ls -l $ANNOUNCE_FILE_ALL 
         if ls $ANNOUNCE_FILE_ALL | grep $target ; then
            # compare $target to $MYIP
            echo compare target:$target to myip:$MYIP
            let compareValue=`echo $target | cut -d\. -f 4`
            let myValue=`echo $MYIP | cut -d\. -f 4`

            echo comparing compareValue:$compareValue to myValue:$myValue

            # if other candidate is preferred manager or wins tie breaker, I relinquish
            # if other candidate is preferred manager or wins tie breaker, I relinquish

            if [ $target == $preferredManager ] ||  [ $compareValue -lt $myValue ] ; then
               # I relinquish
               echo I relinquish $context manager
               let MANAGER_FLAG=0 # should already be 0 but just in case...
               # dlm temp new 25 dec
               # delete my announcement files
               rm $ANNOUNCE_FILE $ANNOUNCE_AREA_FILE 
               rm $ANNOUNCE_CANDIDATE_FILE $ANNOUNCE_AREA_CANDIDATE_FILE 
               return 2
            else
               # I do not relinquish $context mgt, yet at least...
               echo I do not relinquish $context mgt, yet at least...
            fi 

         fi

         # Network Manager Block
         # we have not yet re-linquished, send out an advertisement that we are candidate to manage
         echo 111 sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp
         # do this in the background so we don't get hung up!
         identy=/home/pi/.ssh/id_rsa
         sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
         #scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
         sleep 1

         # dlm temp force this here
         # dlm temp force this here
         # dlm temp force this here
         # dlm temp force this here

         identy=/home/pi/.ssh/id_rsa

         if [ $NETWORK_MANAGER_ENABLED -eq 1 ] ; then

         #Network Management Block
         sudo touch $ANNOUNCE_FILE
         sudo touch $ANNOUNCE_FILE_NET_CHECKSUM
         sudo touch $ANNOUNCE_CANDIDATE_FILE
         sudo chmod 777 $ANNOUNCE_FILE
         sudo chmod 777 $ANNOUNCE_FILE_NET_CHECKSUM
         sudo chmod 777 $ANNOUNCE_CANDIDATE_FILE

         # dlm temp, inner loop is overkill
         #for target in $myNetworkList
         #do

            if [ $DEBUG -eq 1 ] ;then
              #Network Management Block
              echo Distributing $ANNOUNCE_FILE 
              echo Distributing $ANNOUNCE_FILE_NET_CHECKSUM 
            fi

            loginId=`$tagaUtilsDir/myLoginId.sh $target`

            # dlm temp, we probably need to wrap this and all such instances with FLAG CHECK
            # dlm temp, we probably need to wrap this and all such instances with FLAG CHECK
            # dlm temp, we probably need to wrap this and all such instances with FLAG CHECK
            #Network Management Block
            # do this in the background so we don't get hung up
            echo 2222 sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
            echo 3333 sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp
            echo 4444 sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp
            # do this in the background so we don't get hung up
            identy=/home/pi/.ssh/id_rsa
            sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp &
            sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
            sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
            sleep 1

         # dlm temp, inner loop is overkill
         #done

         fi

      done # end of electionLoopfunction loop

      # dlm temp, this may or may not be needed here
      sleep 1


}



# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above


function networkLoopFunction {

      let j=$1

      ##############################
      # Network Loop
      ##############################

      for target in $myNetworkList
      do
         echo $j: TieBreaker Section : checking manager from target:$target
         ls -l $ANNOUNCE_FILE_ALL 
         if ls $ANNOUNCE_FILE_ALL | grep $target ; then
            # compare $target to $MYIP
            echo compare target:$target to myip:$MYIP
            let compareValue=`echo $target | cut -d\. -f 4`
            let myValue=`echo $MYIP | cut -d\. -f 4`

            echo comparing compareValue:$compareValue to myValue:$myValue

            # if other candidate is preferred manager or wins tie breaker, I relinquish
            # if other candidate is preferred manager or wins tie breaker, I relinquish

            if [ $target == $preferredManager ] ||  [ $compareValue -lt $myValue ] ; then
               # I relinquish
               echo I relinquish network manager
               let MANAGER_FLAG=0 # should already be 0 but just in case...
               # dlm temp new 25 dec
               # delete my announcement files
               rm $ANNOUNCE_FILE $ANNOUNCE_AREA_FILE 
               rm $ANNOUNCE_CANDIDATE_FILE $ANNOUNCE_AREA_CANDIDATE_FILE 
               return 2
            else
               # I do not relinquish network mgt, yet at least...
               echo I do not relinquish network mgt, yet at least...
            fi 

         fi

         # Network Manager Block
         # we have not yet re-linquished, send out an advertisement that we are candidate to manage
         echo 111 sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp
         # do this in the background so we don't get hung up!
         identy=/home/pi/.ssh/id_rsa
         sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
         #scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
         sleep 1

         # dlm temp force this here
         # dlm temp force this here
         # dlm temp force this here
         # dlm temp force this here

         identy=/home/pi/.ssh/id_rsa

         if [ $NETWORK_MANAGER_ENABLED -eq 1 ] ; then

         #Network Management Block
         sudo touch $ANNOUNCE_FILE
         sudo touch $ANNOUNCE_FILE_NET_CHECKSUM
         sudo touch $ANNOUNCE_CANDIDATE_FILE
         sudo chmod 777 $ANNOUNCE_FILE
         sudo chmod 777 $ANNOUNCE_FILE_NET_CHECKSUM
         sudo chmod 777 $ANNOUNCE_CANDIDATE_FILE

         # dlm temp, inner loop is overkill
         #for target in $myNetworkList
         #do

            if [ $DEBUG -eq 1 ] ;then
              #Network Management Block
              echo Distributing $ANNOUNCE_FILE 
              echo Distributing $ANNOUNCE_FILE_NET_CHECKSUM 
            fi

            loginId=`$tagaUtilsDir/myLoginId.sh $target`

            # dlm temp, we probably need to wrap this and all such instances with FLAG CHECK
            # dlm temp, we probably need to wrap this and all such instances with FLAG CHECK
            # dlm temp, we probably need to wrap this and all such instances with FLAG CHECK
            #Network Management Block
            # do this in the background so we don't get hung up
            echo 2222 sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
            echo 3333 sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp
            echo 4444 sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp
            # do this in the background so we don't get hung up
            identy=/home/pi/.ssh/id_rsa
            sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp &
            sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
            sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
            sleep 1

         # dlm temp, inner loop is overkill
         #done

         fi

      done # end of network list loop

      # dlm temp, this may or may not be needed here
      sleep 1

}






function echelonLoopFunction {

      ##############################
      # Echelon Loop
      ##############################
      for target in $myEchelonList
      do
         echo $j: TieBreaker Section : checking manager from target:$target
         ls -l $ANNOUNCE_ECHELON_FILE_ALL 
         if ls $ANNOUNCE_ECHELON_FILE_ALL | grep $target ; then
            # compare $target to $MYIP
            echo compare target:$target to myip:$MYIP
            let compareValue=`echo $target | cut -d\. -f 4`
            let myValue=`echo $MYIP | cut -d\. -f 4`

            echo comparing compareValue:$compareValue to myValue:$myValue

            # if other candidate is preferred manager or wins tie breaker, I relinquish
            # if other candidate is preferred manager or wins tie breaker, I relinquish

            if [ $target == $preferredEchelonManager ] ||  [ $compareValue -lt $myValue ] ; then
               # I relinquish
               echo I relinquish echelon manager
               let ECHELON_MANAGER_FLAG=0 # should already be 0 but just in case...
               # dlm temp new 25 dec
               # delete my announcement files
               rm $ANNOUNCE_ECHELON_FILE 
               rm $ANNOUNCE_ECHELON_CANDIDATE_FILE 
               return 2
            else
               # I do not relinquish echelon management, yet at least...
               echo I do not relinquish echelon management, yet at least...
            fi 
         fi


         #if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
         if [ $ECHELON_MANAGER_ENABLED -eq 1 ] ; then
         # Echelon Manager Block
         # we have not yet re-linquished, send out an advertisement that we are candidate to manage
         echo 666 sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp
         # do this in the background so we don't get hung up!
         identy=/home/pi/.ssh/id_rsa
         sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp &
         #scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp &
         sleep 1
         fi

         # dlm temp force this here
         # dlm temp force this here
         # dlm temp force this here

         identy=/home/pi/.ssh/id_rsa

         if [ $ECHELON_MANAGER_ENABLED -eq 1 ] ; then

         #Echelon Management Block
         sudo touch $ANNOUNCE_ECHELON_FILE
         sudo touch $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM
         sudo touch $ANNOUNCE_ECHELON_CANDIDATE_FILE
         sudo chmod 777 $ANNOUNCE_ECHELON_FILE
         sudo chmod 777 $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM
         sudo chmod 777 $ANNOUNCE_ECHELON_CANDIDATE_FILE

         # dlm temp, inner loop is overkill
         #for target in $myNetworkList
         #do

            if [ $DEBUG -eq 1 ] ;then
              #Echelon Management Block
              echo Distributing $ANNOUNCE_ECHELON_FILE 
              echo Distributing $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM 
            fi

            loginId=`$tagaUtilsDir/myLoginId.sh $target`

            #if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
            #if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
            if [ $ECHELON_MANAGER_ENABLED -eq 1 ] ; then
            #Echelon Management Block
            # do this in the background so we don't get hung up
            echo 777 sudo scp -i $identy $ANNOUNCE_ECHELON__FILE  $loginId@$target:/tmp
            echo 888 sudo scp -i $identy $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM  $loginId@$target:/tmp
            echo 999 sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp
            # do this in the background so we don't get hung up
            identy=/home/pi/.ssh/id_rsa
            sudo scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp &
            sudo scp -i $identy $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
            sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp &
            sleep 1
            fi

         # dlm temp, inner loop is overkill
         #done

         fi

      done # end of echelon list loop

      # dlm temp, this may or may not be needed here
      sleep 1

}



##############################################
# Function Re-Election
##############################################

function re-election {

   echo `date` : $MYIP : Re-election in process!

   networkManagerFound="false"
   echelonManagerFound="false"
   areaManagerFound="false"

   # dlm temp, temporary only to account for TAGAXXX-related bug
   # dlm temp, temporary only to account for TAGAXXX-related bug
   # dlm temp, temporary only to account for TAGAXXX-related bug
   # dlm temp, temporary only to account for TAGAXXX-related bug
   if [ $MYIP == 192.168.1.2 ]  || [ $MYIP == 192.168.3.2  ] || \
      [ $MYIP == 22.209.44.86 ] || [ $MYIP == 22.209.44.74 ] ; then
      echo TAGAXXX-related workaround, $MYIP returning from election process
      return
   fi

   source /home/pi/scripts/taga/tagaConfig/config

   # dlm temp change 27 dec
   myNetId=`echo $MYIP | cut -d\. -f 1-3`

   # Use higher loop count for echelon election since it may take longer to converge
   # LoopCount impacts responsiveness, 
   # lower loop count increases responsiveness however an result in premature announcements!

   for i in {1..20}
   do
      echo `date` : $i of 20: network manager re-election in process
      sleep 1

      rm $ANNOUNCE_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         # Somebody else has claimed manager or candidacy so let's abort!
         echo Pre-existing Manager or Candidate Detected, exiting re-election...
         networkManagerFound="true"
         break
         #return
      fi
   done
 
   # Use higher loop count for echelon election since it may take longer to converge
   # LoopCount impacts responsiveness, 
   # lower loop count increases responsiveness however an result in premature announcements!

   for i in {1..60}
   do
     
      echo `date` : $i of 60: echelon manager re-election in process
      sleep 1

      rm $ANNOUNCE_ECHELON_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         # Somebody else has claimed manager or candidacy so let's abort!
         echo Pre-existing Echelon Manager or Candidate Detected, exiting re-election...
         echelonManagerFound="true"
         break
         #return
      fi
   done

   if [ $networkManagerFound == "true" ]  && [ $echelonManagerFound == "true" ] ; then
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo Pre-existing network manager and Pre-existing echelon manager found
      echo Nothing Left to do here - returning
      return
   fi


   # dlm temp stub this out for now
   #for i in {1..10}
   #do
   #   rm $ANNOUNCE_AREA_FILE_ALL 2>/dev/null
   #   let retCode=$?
   #   if [ $retCode -eq 0 ]; then
   #      # Somebody else has claimed manager or candidacy so let's abort!
   #      echo Pre-existing Area Manager or Candidate Detected, exiting re-election...
   #      areaManagerFound="true"
   #      break
   #      #return
   #   fi
   # 
   #  done


   # OKAY, now do a RANDOM DELAY, first one out wins!!!
   # OKAY, now do a RANDOM DELAY, first one out wins!!!

   # dlm temp, note, this leaves a small window of ties, which we must add post-processing to identify and resolve that case
   # dlm temp, note, this leaves a small window of ties, which we must add post-processing to identify and resolve that case

   randomDelay=`$tagaUtilsDir/iboaRandom.sh`

   #randomDelay=$randomDelay*5

   echo Random Delay: $randomDelay
   $tagaUtilsDir/iboaDelay.sh $randomDelay

   # we get here quite normally, tie breaker rules apply

   for j in {1..5}
   do
      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag
      echo $j: TieBreaker Section

      ##############################
      # Network Loop
      ##############################

      if [ $NETWORK_MANAGER_ENABLED -eq 1 ] && [ $networkManagerFound == "false" ] ; then  

         # Set Network Context and call Election Loop function 
         # Set Network Context and call Election Loop function 

         networkContext
         electionLoopFunction $j
         #networkLoopFunction $j

         let retCode=$?
         if [ $retCode -eq 2 ] ; then
            networkManagerFound="true"
         fi
      fi

      sleep 1
   done  # end of j loop

   for j in {1..5}
   do

      ##############################
      # Echelon Loop
      ##############################

      if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $echelonManagerFound == "false" ] ; then
         echelonLoopFunction $j
         let retCode=$?
         if [ $retCode -eq 2 ] ; then
            echelonManagerFound="true"
         fi
      fi

      sleep 1
   done  # end of j loop


   if [ $networkManagerFound == "true" ]  && [ $echelonManagerFound == "true" ] ; then
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo Pre-existing network manager and Pre-existing echelon manager found
      echo Nothing Left to do here - returning
      return
   fi


   # we are candidate for network mgr or echeclon mgr or both....
   # we are candidate for network mgr or echeclon mgr or both....
   # dlm temp, if we get here, for now, just claim to be a candidate and even manager!
   # dlm temp, if we get here, for now, just claim to be a candidate and even manager!
   # we are candidate for network mgr or echeclon mgr or both....
   # we are candidate for network mgr or echeclon mgr or both....

   identy=/home/pi/.ssh/id_rsa

   #######################################
   # Net Mgr Block
   #######################################
   # network block
   #if [ $NETWORK_MANAGER_ENABLED -eq 1 ] ; then  # will need FLAG CHECK Also
   if [ $NETWORK_MANAGER_ENABLED -eq 1 ] && [ $networkManagerFound == "false" ] ; then  
   # create the candidate file
   touch $ANNOUNCE_CANDIDATE_FILE 
   chmod 777 $ANNOUNCE_CANDIDATE_FILE 
   echo $MYIP : myNetworkList:$myNetworkList
   echo $MYIP : myNetworkList:$myNetworkList          > /tmp/myNetworkList.dat

   # distribute the candidate file
   for target in $myNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_CANDIDATE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo 000 sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp

      # do this in the background so we don't get hung up
      sudo scp -i $identy $ANNOUNCE_CANDIDATE_FILE  $loginId@$target:/tmp &
      sleep 1
   done

   # dlm temp , this is key!!
   let MANAGER_FLAG=1

   # dlm temp new 25 dec
   # Network Manager Block
   touch $ANNOUNCE_CANDIDATE_COMPLETE_FILE
   sudo chmod 777 $ANNOUNCE_CANDIDATE_COMPLETE_FILE
   identy=/home/pi/.ssh/id_rsa
   for target in $myNetworkList
   do
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      # send a candidate complete indicator
      echo AAA sudo scp -i $identy $ANNOUNCE_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp
      # do this in the background so we don't get hung up!
      sudo scp -i $identy $ANNOUNCE_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp &
      #scp -i $identy $ANNOUNCE_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp &
      sleep 1
   done


   fi # end of network manager enabled block

   #######################################
   # Echelon Mgr Block
   #######################################
   # echelon block
   #if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
   #if [ $ECHELON_MANAGER_ENABLED -eq 1 ] ; then
   if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $echelonManagerFound == "false" ] ; then
   # create the candidate file
   touch $ANNOUNCE_ECHELON_CANDIDATE_FILE 
   chmod 777 $ANNOUNCE_ECHELON_CANDIDATE_FILE 
   echo $MYIP : myEchelonList:$myEchelonList
   echo $MYIP : myEchelonList:$myEchelonList          > /tmp/myEchelonList.dat

   # distribute the candidate file
   for target in $myEchelonList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_ECHELON_CANDIDATE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo BBB sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp

      # do this in the background so we don't get hung up
      sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_FILE  $loginId@$target:/tmp &
      sleep 1
   done

   # dlm temp , this is key!!
   echo 8888888888888888
   echo 8888888888888888
   echo 8888888888888888
   echo 8888888888888888
   let ECHELON_MANAGER_FLAG=1

   # dlm temp new 17 jan
   # Echelon Manager Block
   touch $ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE
   sudo chmod 777 $ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE
   identy=/home/pi/.ssh/id_rsa
   for target in $myEchelonList
   do
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      # send a candidate complete indicator
      echo CCC sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp
      # do this in the background so we don't get hung up!
      sudo scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp &
      #scp -i $identy $ANNOUNCE_ECHELON_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp &
      sleep 1
   done

   fi # end of ECHELON_MANAGER_ENABLED filter


} # end function re-election



function relinquish {

   # re-set our election context in case the configuration has changed
   # i.e. make sure we are still the preferred manager or otherwise

  # dlm temp new 25 dec
  ###############3
   # dlm temp, this is getting ugly, consider these two lines hard
   # dlm temp, this is getting ugly, consider these two lines hard
   let MANAGER_FLAG_SAVED=$MANAGER_FLAG
   let ECHELON_MANAGER_FLAG_SAVED=$ECHELON_MANAGER_FLAG
   election
   let MANAGER_FLAG=$MANAGER_FLAG_SAVED                 # set this flag again since it may have been cleared
   let ECHELON_MANAGER_FLAG=$ECHELON_MANAGER_FLAG_SAVED # set this flag again since it may have been cleared
  ###############3


   ###################################
   # network manager block
   ###################################
   for j in 1   # use the for loop block to allow goto like behavior , alternative is to create a function
   do
   if [ $MYIP != $preferredManager ] && [ $MANAGER_FLAG -eq 1 ] ; then

      # I am not the preferred network manager, I need to make sure I should remain as network manager

      PREFERRED_MANAGER_FILE=$ANNOUNCE_FILE_BASE.$preferredManager
      if [ -f $PREFERRED_MANAGER_FILE ]; then 
         echo $MYIP : Preferred Manager is advertising, I am relinquishing management duties!
         echo $MYIP : Preferred Manager is advertising \($preferredManager\), I am relinquishing as manager!
         let MANAGER_FLAG=0
         break
         #return 0
      fi 

      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag

      echo $j: Relinquish Section
       
      for target in $myNetworkList
      do
         echo $j: Relinquish Section : checking manager from target:$target
         ls -l $ANNOUNCE_FILE_ALL 
         if ls $ANNOUNCE_FILE_ALL | grep $target ; then
            # compare $target to $MYIP
            echo compare target:$target to myip:$MYIP
            compareValue=`echo $target | cut -d\. -f 4`
            myValue=`echo $MYIP | cut -d\. -f 4`
            echo comparing compareValue:$compareValue to myValue:$myValue

            #if [ $compareValue -lt $myValue ] ; then
            if [ $target == $preferredManager ] ||  [ $compareValue -lt $myValue ] ; then
               # I relinquish
               echo I relinquish
               let MANAGER_FLAG=0
               # dlm temp new 25 dec
               # delete my announcement files
               rm $ANNOUNCE_FILE 
               rm $ANNOUNCE_CANDIDATE_FILE 
               break
               #return 0
            else
               # I do not relinquish net mgt , yet at least...
               echo I do not relinquish net mgt, yet at least...
            fi 
         fi

      done

   else
      if [ $MYIP == $preferredManager ] ; then
         echo I am preferred network manager, no need to relinquish to anybody
      elif [ $MANAGER_FLAG -eq 0 ] ; then
         echo I am not network manager, nothing to relinquish here
      else
         echo Anomaly, we should not get here!
      fi
   fi  # end if not preferred network manager
   done

   ###############################################
   # End Network Manager Block
   ###############################################


   ###################################
   # echelon manager block
   ###################################
   for j in 1   # use the for loop block to allow goto like behavior , alternative is to create a function
   do
   if [ $MYIP != $preferredEchelonManager ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then

      # I am not the preferred echelon manager, I need to make sure I should remain as echelon manager

      PREFERRED_ECHELON_MANAGER_FILE=$ANNOUNCE_ECHELON_FILE_BASE.$preferredEchelonManager
      if [ -f $PREFERRED_ECHELON_MANAGER_FILE ]; then 
         echo $MYIP : Preferred Echelon Manager is advertising, I am relinquishing management duties!
         echo $MYIP : Preferred Echelon Manager \($preferredEchelonManager\) is advertising, I am relinquishing as manager!
         let ECHELON_MANAGER_FLAG=0
         break
         #return 0
      fi 

      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag

      echo $j: Relinquish Section
       
      for target in $myEchelonList
      do
         echo $j: Relinquish Section : checking echelon manager from target:$target
         ls -l $ANNOUNCE_ECHELON_FILE_ALL 
         if ls $ANNOUNCE_ECHELON_FILE_ALL | grep $target ; then
            # compare $target to $MYIP
            echo compare target:$target to myip:$MYIP
            compareValue=`echo $target | cut -d\. -f 4`
            myValue=`echo $MYIP | cut -d\. -f 4`
            echo comparing compareValue:$compareValue to myValue:$myValue

            if [ $target == $preferredEchelonManager ] ||  [ $compareValue -lt $myValue ] ; then
               # I relinquish
               echo I relinquish
               let ECHELON_MANAGER_FLAG=0
               # dlm temp new 25 dec
               # delete my announcement files
               rm $ANNOUNCE_ECHELON_FILE 
               rm $ANNOUNCE_ECHELON_CANDIDATE_FILE 
               break
               #return 0
            else
               # I do not relinquish echelon mgt, yet at least...
               echo I do not relinquish echelon mgt, yet at least...
            fi 
         fi
      done
   else
      if [ $MYIP == $preferredEchelonManager ] ; then
         echo I am preferred echelon manager, no need to relinquish to anybody
      elif [ $ECHELON_MANAGER_FLAG -eq 0 ] ; then
         echo I am not an echelon manager, nothing to relinquish here
      else
         echo Anomaly, we should not get here!
      fi
   fi  # end if not preferred echelon manager
   done
   ###############################################
   # End Network Manager Block
   ###############################################
   

} # end function relinquish




function doManager {

   echo `date` : doManager

   # network manager block
   if [ $MANAGER_FLAG -eq 1 ] ; then
      touch          $ANNOUNCE_FILE 
      sudo chmod 777 $ANNOUNCE_FILE 
      touch          $ANNOUNCE_FILE_NET_CHECKSUM 
      sudo chmod 777 $ANNOUNCE_FILE_NET_CHECKSUM 
   fi

   # echelon manager block
   if [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
      touch          $ANNOUNCE_ECHELON_FILE 
      sudo chmod 777 $ANNOUNCE_ECHELON_FILE 
      touch          $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM 
      sudo chmod 777 $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM 
   fi

   # future...
   #touch $ANNOUNCE_AREA_FILE 
   #sudo chmod 777 $ANNOUNCE_AREA_FILE 

   echo $MYIP : myNetworkList:$myNetworkList
   echo $MYIP : myEchelonList:$myEchelonList
   echo $MYIP : myAreaList:$myAreaList

   echo $MYIP : myNetworkList:$myNetworkList          > /tmp/myNetworkList.dat
   echo $MYIP : myEchelonList:$myEchelonList          > /tmp/myEchelonList.dat
   echo $MYIP : myAreaList:$myAreaList                > /tmp/myAreaList.dat

   identy=/home/pi/.ssh/id_rsa

   if [ $NETWORK_MANAGER_ENABLED -eq 1 ] && [ $MANAGER_FLAG -eq 1 ] ; then
   for target in $myNetworkList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_FILE 
        echo Distributing $ANNOUNCE_FILE_NET_CHECKSUM 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      # do this in the background so we don't get hung up
      echo DDD sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp
      echo EEE sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp
      # do this in the background so we don't get hung up
         identy=/home/pi/.ssh/id_rsa
      sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp &
      sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
      #scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp &
         sleep 1
   done
   fi

   echo ECHELON_MANAGER_FLAG:$ECHELON_MANAGER_FLAG

   if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
   for target in $myEchelonList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_ECHELON_FILE 
        echo Distributing $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      # do this in the background so we don't get hung up
      echo FFF sudo scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp
      echo GGG sudo scp -i $identy $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM  $loginId@$target:/tmp
      # do this in the background so we don't get hung up
         identy=/home/pi/.ssh/id_rsa
      sudo scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp &
      sudo scp -i $identy $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
      #scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp &
         sleep 1
   done
   fi

   if [ $AREA_MANAGER_ENABLED -eq 1 ] ; then
   for target in $myAreaList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_AREA_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo HHH sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp
      # do this in the background so we don't get hung up
         identy=/home/pi/.ssh/id_rsa
      sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp &
      #scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp &
         sleep 1
   done
   fi

   # dlm temp, note this is bully algorithm 
   # dlm temp, exit if I am not the preferred manager and the preferred manager is advertising

   PREFERRED_MANAGER_FILE=$ANNOUNCE_FILE_BASE.$preferredManager

   if [ $MYIP != $preferredManager ]; then
   if [ -f $PREFERRED_MANAGER_FILE ]; then 
      echo $MYIP : Preferred Manager is advertising, I am relinquishing management duties!
      echo $MYIP : Preferred Manager is advertising \($preferredManager\), I am relinquishing as manager!
      let MANAGER_FLAG=0
   fi 
   fi

   echo TTTTTT preferredEchelonManager:$preferredEchelonManager
   echo TTTTTT preferredEchelonManager:$preferredEchelonManager

   PREFERRED_ECHELON_MANAGER_FILE=$ANNOUNCE_ECHELON_FILE_BASE.$preferredEchelonManager

   if [ $MYIP != $preferredEchelonManager ]; then
   if [ -f $PREFERRED_ECHELON_MANAGER_FILE ]; then 
      echo $MYIP : Preferred Echelon Manager is advertising, I am relinquishing management duties!
      echo $MYIP : Preferred Echelon Manager \($preferredEchelonManager\) is advertising, I am relinquishing as manager!
      let ECHELON_MANAGER_FLAG=0

      # dlm temp, consider if we should return here since we have relinquished, why call relinquish?
      # dlm temp, consider if we should return here since we have relinquished, why call relinquish?
      # dlm temp, consider if we should return here since we have relinquished, why call relinquish?

   fi 
   fi

   relinquish

   return 0
} # end function doManager



function verifyManager {
   echo `date` : verifyManager

   let retCode=0
   #Tri..we might need to add echelon manager count variable.
   let managerCount=0
   let echelonManagerCount=0

   # delete old files
   rm $ANNOUNCE_FILE_ALL               2>/dev/null
   rm $ANNOUNCE_NETWORK_FILE_ALL       2>/dev/null
   rm $ANNOUNCE_ECHELON_FILE_ALL       2>/dev/null
   rm $ANNOUNCE_AREA_FILE_ALL          2>/dev/null

   echo Contents:
   echo Contents:
   echo Contents:
   echo Contents:
   echo Contents:
   echo
   ls /tmp/*Ann*
   echo
   echo End Contents
   echo End Contents
   echo End Contents
   echo End Contents
   echo End Contents

   #sleep $MANAGER_AUDIT_INTERVAL
   $tagaUtilsDir/iboaDelay.sh $MANAGER_AUDIT_INTERVAL

   for target in $targetList
   do
   if [ -f $ANNOUNCE_FILE ] ; then
      echo Info: File $ANNOUNCE_FILE.$target Exists!
      let managerCount=$managerCount+1
      echo managerCount:$managerCount
   fi 
   if [ -f $ANNOUNCE_ECHELON_FILE ] ; then
      echo Info: File $ANNOUNCE_ECHELON_FILE.$target Exists!
      #Tri..we might need to add echelon manager count variable.
      let echelonManagerCount=$echelonManagerCount+1
      echo echelonManagerCount:$echelonManagerCount
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

   # dlm temp, since we =cant have two return codes, let's cheat and create a return code global var
   let retCodeEchelon=0

   if [ $echelonManagerCount -eq 0 ] ; then
      echo ALARM:MAJOR: $MYIP : No Echelon Manager Identified for this echelon! 
      #let retCode=2
      let retCodeEchelon=2
   elif [ $echelonManagerCount -gt 1 ] ; then
      echo ALARM:MINOR: $MYIP : Multiple Echelon Managers Identified for this echelon! 
      #let retCode=1
      let retCodeEchelon=1
   else
      echo INFO: $MYIP : Single Echelon Manager Verified for this network! 
      let retCodeEchelon=0
   fi

   return $retCode

}  # end function verifyManager


function maintain {

# Maintain the election
while true
do

   let retCode=0

   # resource the config
   source /home/pi/scripts/taga/tagaConfig/config
   netCheckSum=`sum $tagaConfigDir/targetList.sh | cut -c1-5`

# dlm temp, change 21 jan 2017, this should not be needed here, except the checksum files which change

   ANNOUNCE_NETWORK_FILE_NET_CHECKSUM=/tmp/managerAnnouncement.dat.$MYIP.$netCheckSum
   ANNOUNCE_ECHELON_FILE_NET_CHECKSUM=/tmp/managerAnnouncementEchelon.dat.$MYIP.$netCheckSum
   ANNOUNCE_AREA_FILE_NET_CHECKSUM=/tmp/managerAnnouncementArea.dat.$MYIP.$netCheckSum

   # Config Updated, Re-configure to Network Context
   networkContext


#   ANNOUNCE_CANDIDATE_FILE=/tmp/managerAnnouncement.dat.$MYIP.candidate
#   ANNOUNCE_FILE=/tmp/managerAnnouncement.dat.$MYIP
#   ANNOUNCE_FILE_NET_CHECKSUM=/tmp/managerAnnouncement.dat.$MYIP.$netCheckSum
#   ANNOUNCE_FILE_ALL=/tmp/managerAnnouncement.dat.*
#
#   ANNOUNCE_ECHELON_CANDIDATE_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP.candidate
#   ANNOUNCE_ECHELON_FILE=/tmp/managerAnnouncementEchelon.dat.$MYIP
#   ANNOUNCE_ECHELON_FILE_NET_CHECKSUM=/tmp/managerAnnouncementEchelon.dat.$MYIP.$netCheckSum
#   ANNOUNCE_ECHELON_FILE_ALL=/tmp/managerAnnouncementEchelon.dat.*
#
#   ANNOUNCE_AREA_CANDIDATE_FILE=/tmp/managerAnnouncementArea.dat.$MYIP.candidate
#   ANNOUNCE_AREA_FILE=/tmp/managerAnnouncementArea.dat.$MYIP
#   ANNOUNCE_AREA_FILE_NET_CHECKSUM=/tmp/managerAnnouncementArea.dat.$MYIP.$netCheckSum
#   ANNOUNCE_AREA_FILE_ALL=/tmp/managerAnnouncementArea.dat.*
#


   if  [ $MANAGER_FLAG -eq 1 ] || [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
      doManager
      let retCode=$?
   else
      # Verify manager still exists or promote myself
      echo; date
      echo;echo
      echo My Network:$myNetId : My Preferred Network Manager:$preferredManager
      echo My Echelon:$myEchelon : My Preferred Echelon Manager:$preferredEchelonManager 
      echo
      echo "Verifying Manager (Preferred Network Manager $preferredManager) (or Other Elected Manager) is Healthy"
      echo "Verifying Manager (Preferred Echelon Manager $preferredEchelonManager) (or Other Elected Manager) is Healthy"
      echo

      verifyManager 

      # network manager block
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
         re-election

      else
         echo No Manager Verified
         echo Enter Re-election process now!

         # call initial election to allow bully algorithm to function
         # in the event the IP addresses (provides our identity process) appear after init
         election
         # if we stil have no manager, do the re-election , note this is temporary until bully comes back
         re-election

      fi

      # echelon manager block
      if [ $retCodeEchelon -eq 0 ]; then
         echo Single Echelon Manager Verified

      elif [ $retCodeEchelon -eq 1 ]; then
         echo Multiple Echelon Managers Verified
         echo Enter Re-election process now!

         # call initial election to allow bully algorithm to function
         # in the event the IP addresses (provides our identity process) appear after init
         election
         # if we stil have no manager, do the re-election , note this is temporary until bully comes back
         re-election

      else
         echo No Echelon Manager Verified
         echo Enter Re-election process now!

         # call initial election to allow bully algorithm to function
         # in the event the IP addresses (provides our identity process) appear after init
         election
         # if we stil have no manager, do the re-election , note this is temporary until bully comes back
         re-election

      fi
   fi

   sleep 5

done

} # end function maintain


##################################
# MAIN
##################################

#let ELECT_TYPE=$1

# dlm temp new 21 jan 2017 
# set network context ... dlm temp, this may or may not be needed here...
networkContext

# Do the initial election, note this also reads configuration and populates globals
election

# set network context based on the updated configuration 
networkContext

# Maintain the election
maintain


