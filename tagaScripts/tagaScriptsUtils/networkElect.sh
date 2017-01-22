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

AREA_MANAGER_ENABLED=0
AREA_MANAGER_ENABLED=1

######################################################################
# Static Configuration Section
######################################################################

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

###############################################################
# Other Global Variables
###############################################################

let MANAGER_FLAG=0
let NETWORK_MANAGER_FLAG=0
let ECHELON_MANAGER_FLAG=0
let AREA_MANAGER_FLAG=0

let DEBUG=0
let DEBUG=1

myNetId=""
myEchelon="tbd"
myArea="tbd"

myNetworkList=""
myEchelonList="" 
myAreaList=""

preferredNetworkManager="tbd"
preferredEchelonManager="tbd"
preferredAreaManager="tbd"

# dlm temp, since we cant have multiple return codes from a single function, 
# let's cheat and create several return code global vars
let retCodeNetwork=0
let retCodeEchelon=0
let retCodeArea=0

##############################################
# Function Definitions
##############################################

##############################################
# Election Context Config Functions
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
   electionContext="network"
   contextList=$myNetworkList
   preferredManager=$preferredNetworkManager
   MANAGER_FLAG=$NETWORK_MANAGER_FLAG
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
   electionContext="echelon"
   contextList=$myEchelonList
   preferredManager=$preferredEchelonManager
   MANAGER_FLAG=$ECHELON_MANAGER_FLAG
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
   electionContext="area"
   contextList=$myAreaList
   preferredManager=$preferredAreaManager
   MANAGER_FLAG=$AREA_MANAGER_FLAG
}


##############################################
# Function Election
##############################################

function election {

# reinit these each time election function is called so they don't grow forever
myNetworkList=""
myEchelonList="" 
myAreaList=""
myNetId=""

########################################################
# WAIT - Wait until we are in Target List and get Net Id
########################################################
# Do not proceed unless/until we are in the target list, loop here til the config includes us
while true
do
   # get the config
   source /home/pi/scripts/taga/tagaConfig/config

   # check if we are in the target list and if yes then find our net id
   if echo $targetList | grep $MYIP ; then
      echo okay, I am in the target list >/dev/null
      myNetId=`echo $MYIP | cut -d\. -f 1-3`
      break
   else
      echo Notice: I am not in the target list so I am waiting to be added to the target list
      myNetId=""
      # wait for config to change
      sleep 60
      #exit
   fi
done


##############################################
# Get Area Info
##############################################
if echo $AREA1_LIST | grep $MYIP ; then
   echo okay, I am in the area1 list >/dev/null
   myArea=1
   myAreaList=$AREA1_LIST 
   preferredAreaManager=`echo $AREA1_LIST | cut -d" " -f 1`
else
   echo Notice: I am not in any area list so I should have no area Id for area manager elect purposes and should not participate in any area election processes.
   myArea=""
   myAreaList="" 
   # We might be some other special type of node so keep going
   #exit
fi


##############################################
# Get Echeclon Info
##############################################


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
   # We might be some other special type of node so keep going
   # We might be an TAGAXXX node.  
   #exit
fi


##############################################
# Get Network Info
# NOTE: This assumes 24 bit netmask!!
# NOTE: This assumes 24 bit netmask!!
##############################################
# first let's build up our sub-network list...
for target in $targetList
do
   compareNetId=`echo $target | cut -d\. -f 1-3`
   if [ $DEBUG -eq 1 ] ;then
     echo $target
     echo comparing $compareNetId $myNetId
   fi
   if [ $compareNetId == $myNetId ] ; then
      myNetworkList="$myNetworkList $target"
   fi
done

##########################################################################
# Print Static Configured Network, Echeclon, and Area Election Information
##########################################################################
echo $MYIP : myNetId:$myNetId
echo $MYIP : myEchelon:$myEchelon
echo $MYIP : myArea:$myArea
echo
echo $MYIP : myNetId:$myNetId                > /tmp/myElectionInfo.dat
echo $MYIP : myEchelon:$myEchelon           >> /tmp/myElectionInfo.dat
echo $MYIP : myArea:$myArea                 >> /tmp/myElectionInfo.dat
echo
echo $MYIP : myNetworkList:$myNetworkList
echo $MYIP : myEchelonList:$myEchelonList
echo $MYIP : myAreaList:$myAreaList
echo
echo $MYIP : myNetworkList:$myNetworkList    > /tmp/myNetworkList.dat #  >> /tmp/myElectionInfo.dat
echo $MYIP : myEchelonList:$myEchelonList    > /tmp/myEchelonList.dat #  >> /tmp/myElectionInfo.dat
echo $MYIP : myAreaList:$myAreaList          > /tmp/myAreaList.dat    #  >> /tmp/myElectionInfo.dat


##################################################################
# Preferred Managers Section
##################################################################

# Okay, we have the config, now find the Preferred Managers

############
# Area
############
# are we the preferred area manager?
if [ $preferredAreaManager == $MYIP ]; then 
     echo I am the preferred area manager for area $myArea
     echo $MYIP : I am preferred Manager of Area $myArea > /tmp/areaElect.dat
     let AREA_MANAGER_FLAG=1
fi

############
# Echelon
############
# are we the preferred echelon manager?
if [ $preferredEchelonManager == $MYIP ]; then 
     echo I am the preferred echelon manager for echelon echelon $myEchelon
     echo $MYIP : I am preferred Manager of Echelon $myEchelon > /tmp/echelonElect.dat
     let ECHELON_MANAGER_FLAG=1
fi


################################################
# Network and TAGAXXX (or otherr special handling)
################################################
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
              #echo $MYIP : I am preferred Manager of Echelon $myEchelon > /tmp/networkElectEchelon.dat
              let MANAGER_FLAG=1
              let NETWORK_MANAGER_FLAG=1
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

############
# TAGAXXX Special Handling 
############

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
              let NETWORK_MANAGER_FLAG=1
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
  echo Anomaly, Should no get here , bad config!
  echo I am not a candidate for network manager 
fi

} # end function election


# Notice: Please ensure proper election manager context is set prior to calling this function!
# Notice: Please ensure proper election manager context is set prior to calling this function!

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
               let NETWORK_MANAGER_FLAG=0 # should already be 0 but just in case...

               let MANAGER_FLAG=0
               #let NETWORK_MANAGER_FLAG=0
               if [ $electionContext == "network" ]; then
                  let NETWORK_MANAGER_FLAG=0
               elif [ $electionContext == "echelon" ]; then
                  let ECHELON_MANAGER_FLAG=0
               elif [ $electionContext == "area" ]; then
                  let AREA_MANAGER_FLAG=0
               else
                  echo Anomaly, unknown electionContext,should not get here!
               fi

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
               let NETWORK_MANAGER_FLAG=0 # should already be 0 but just in case...
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



# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above
# dlm tmep, this is being phased out, in preference to electionLoopFunction above

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

   # dlm temp find me
   # Get the updated config
   source /home/pi/scripts/taga/tagaConfig/config

   # dlm temp change 27 dec
   myNetId=`echo $MYIP | cut -d\. -f 1-3`

   # update the checksum files with the new config
   netCheckSum=`sum $tagaConfigDir/targetList.sh | cut -c1-5`
   ANNOUNCE_NETWORK_FILE_NET_CHECKSUM=/tmp/managerAnnouncement.dat.$MYIP.$netCheckSum
   ANNOUNCE_ECHELON_FILE_NET_CHECKSUM=/tmp/managerAnnouncementEchelon.dat.$MYIP.$netCheckSum
   ANNOUNCE_AREA_FILE_NET_CHECKSUM=/tmp/managerAnnouncementArea.dat.$MYIP.$netCheckSum

   # set network context based on the updated configuration 
   networkContext

   # Use higher loop count for echelon election since it may take longer to converge
   # LoopCount impacts responsiveness, 
   # lower loop count increases responsiveness however an result in premature announcements!

   ######################################################
   # Network Election - Look for Pre-existing Announcer
   ######################################################
   for i in {1..20}
   do
      echo `date` : $i of 20: network manager re-election in process
      sleep 1

      rm $ANNOUNCE_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         echo 7777777777777777777
         echo 7777777777777777777
         echo 7777777777777777777
         echo 7777777777777777777
         echo 7777777777777777777
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

   ######################################################
   # Echelon Election - Look for Pre-existing Announcer
   ######################################################
   for i in {1..40}
   do
     
      echo `date` : $i of 40: echelon manager re-election in process
      sleep 1

      rm $ANNOUNCE_ECHELON_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         echo 88888888888888888888
         echo 88888888888888888888
         echo 88888888888888888888
         echo 88888888888888888888
         echo 88888888888888888888
         # Somebody else has claimed manager or candidacy so let's abort!
         echo Pre-existing Echelon Manager or Candidate Detected, exiting re-election...
         echelonManagerFound="true"
         break
         #return
      fi
   done

   # Use higher loop count for echelon election since it may take longer to converge
   # LoopCount impacts responsiveness, 
   # lower loop count increases responsiveness however an result in premature announcements!

   ######################################################
   # Area Election - Look for Pre-existing Announcer
   ######################################################
   for i in {1..60}
   do
     
      echo `date` : $i of 60: area manager re-election in process
      sleep 1

      rm $ANNOUNCE_AREA_FILE_ALL 2>/dev/null
      let retCode=$?
      if [ $retCode -eq 0 ]; then
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         echo 999999999999999999
         # Somebody else has claimed manager or candidacy so let's abort!
         echo Pre-existing Area Manager or Candidate Detected, exiting re-election...
         areaManagerFound="true"
         break
         #return
      fi
   done

   #################################################################
   # Return if we have found pre-existing managers for all elections
   #################################################################
   if [ $networkManagerFound == "true" ] && \
      [ $echelonManagerFound == "true" ] && \
      [ $areaManagerFound == "true" ]  ; then
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo 00000000000000000000000000
      echo Notice: Pre-existing network , echelon, and area managers found!
      echo Notice: Nothing Left to do here - returning!
      return
   fi

   #################################################################
   # If we get here, we have at least one election process to proceed with
   #################################################################

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

   #################################################################
   # If we get here, we have at least one election process to proceed with
   #################################################################
   # OKAY, now do a RANDOM DELAY, first one out wins!!!
   # dlm temp, note, this leaves a small window of ties, which we must 
   # add post-processing to identify and resolve that case

   #########################3
   # Random Delay    
   #########################3
   randomDelay=`$tagaUtilsDir/iboaRandom.sh`
   echo Random Delay: $randomDelay
   $tagaUtilsDir/iboaDelay.sh $randomDelay

   #########################3
   # Tie Breaker Section
   #########################3
   # we get here quite normally, tie breaker rules apply

   ##############################
   # Network Loop
   ##############################
   for j in {1..5}
   do
      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag
      echo $j: TieBreaker Section
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

   ##############################
   # Echelon Loop
   ##############################
   for j in {1..5}
   do
      if [ $ECHELON_MANAGER_ENABLED -eq 1 ] && [ $echelonManagerFound == "false" ] ; then
         echelonLoopFunction $j
         let retCode=$?
         if [ $retCode -eq 2 ] ; then
            echelonManagerFound="true"
         fi
      fi
      sleep 1
   done  # end of j loop

   ##############################
   # Area Loop
   ##############################
   for j in {1..5}
   do
      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag
      echo $j: TieBreaker Section
      if [ $NETWORK_MANAGER_ENABLED -eq 1 ] && [ $networkManagerFound == "false" ] ; then  
         # Set Area Context and call Election Loop function 
         # Set Area Context and call Election Loop function 
         areaContext
         electionLoopFunction $j
         let retCode=$?
         if [ $retCode -eq 2 ] ; then
            areaManagerFound="true"
         fi
      fi
      sleep 1
   done  # end of j loop

   # Okay, let's reset to network context (the default)
   networkContext

   # dlm temp find me
   # dlm temp find me
   # dlm temp find me

   if [ $networkManagerFound == "true" ] && \
      [ $echelonManagerFound == "true" ] && \
      [ $areaManagerFound == "true" ]  ; then
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo 00000000000000000000000000AAAAAAAAAAAAAAAAA
      echo Notice: Pre-existing network , echelon, and area managers found!
      echo Notice: Nothing Left to do here - returning!
      return
   fi

   # we are candidate for network mgr or echeclon mgr or area mgr or some combination thereof...
   # we are candidate for network mgr or echeclon mgr or area mgr or some combination thereof...
   # dlm temp, if we get here, for now, just claim to be a candidate and even manager!
   # dlm temp, if we get here, for now, just claim to be a candidate and even manager!
   # we are candidate for network mgr or echeclon mgr or area mgr or some combination thereof...
   # we are candidate for network mgr or echeclon mgr or area mgr or some combination thereof...

   identy=/home/pi/.ssh/id_rsa

   # dlm temp, notice, replace three blocks below with Context Block Loop 
   # dlm temp, notice, replace three blocks below with Context Block Loop 
   # dlm temp, notice, replace three blocks below with Context Block Loop 
   # dlm temp, notice, replace three blocks below with Context Block Loop 

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
   echo 8888888888888888111111111111111
   echo 8888888888888888111111111111111
   echo 8888888888888888111111111111111
   echo 8888888888888888111111111111111
   let MANAGER_FLAG=1
   let NETWORK_MANAGER_FLAG=1

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
   echo 8888888888888888AAAAAAAAa
   echo 8888888888888888AAAAAAAAa
   echo 8888888888888888AAAAAAAAa
   echo 8888888888888888AAAAAAAAa
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


   #######################################
   # Area Mgr Block
   #######################################
   # area block
   if [ $AREA_MANAGER_ENABLED -eq 1 ] && [ $areaManagerFound == "false" ] ; then
   # create the candidate file
   touch $ANNOUNCE_AREA_CANDIDATE_FILE 
   chmod 777 $ANNOUNCE_AREA_CANDIDATE_FILE 
   echo $MYIP : myAreaList:$myAreaList
   echo $MYIP : myAreaList:$myAreaList          > /tmp/myAreaList.dat

   # distribute the candidate file
   for target in $myAreaList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_AREA_CANDIDATE_FILE 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      echo BBB sudo scp -i $identy $ANNOUNCE_AREA_CANDIDATE_FILE  $loginId@$target:/tmp

      # do this in the background so we don't get hung up
      sudo scp -i $identy $ANNOUNCE_AREA_CANDIDATE_FILE  $loginId@$target:/tmp &
      sleep 1
   done

   # dlm temp , this is key!!
   echo 8888888888888888EEEEEEEEEEEE
   echo 8888888888888888EEEEEEEEEEEE
   echo 8888888888888888EEEEEEEEEEEE
   echo 8888888888888888EEEEEEEEEEEE
   let AREA_MANAGER_FLAG=1

   # dlm temp new 17 jan
   # Area Manager Block
   touch $ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE
   sudo chmod 777 $ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE
   identy=/home/pi/.ssh/id_rsa
   for target in $myAreaList
   do
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      # send a candidate complete indicator
      echo CCC sudo scp -i $identy $ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp
      # do this in the background so we don't get hung up!
      sudo scp -i $identy $ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp &
      #scp -i $identy $ANNOUNCE_AREA_CANDIDATE_COMPLETE_FILE  $loginId@$target:/tmp &
      sleep 1
   done
   fi # end of AREA_MANAGER_ENABLED filter


} # end function re-election



function relinquish {

   # re-set our election context in case the configuration has changed
   # i.e. make sure we are still the preferred manager or otherwise

  # dlm temp new 25 dec
  ###############
   # dlm temp, this is getting ugly, consider these two lines hard
   # dlm temp, this is getting ugly, consider these two lines hard
   let MANAGER_FLAG_SAVED=$MANAGER_FLAG
   let NETWORK_MANAGER_FLAG_SAVED=$NETWORK_MANAGER_FLAG
   let ECHELON_MANAGER_FLAG_SAVED=$ECHELON_MANAGER_FLAG
   let AREA_MANAGER_FLAG_SAVED=$AREA_MANAGER_FLAG
   election
   let MANAGER_FLAG=$MANAGER_FLAG_SAVED                 # set this flag again since it may have been cleared
   let NETWORK_MANAGER_FLAG=$NETWORK_MANAGER_FLAG_SAVED # set this flag again since it may have been cleared
   let ECHELON_MANAGER_FLAG=$ECHELON_MANAGER_FLAG_SAVED # set this flag again since it may have been cleared
   let AREA_MANAGER_FLAG=$AREA_MANAGER_FLAG_SAVED       # set this flag again since it may have been cleared
  ###############


   ###############################################
   # Context Election Manager Block and Loop
   ###############################################

   #for j in 1   # use the for loop block to allow goto like behavior , alternative is to create a function
   #for electionContext in network echelon #area
   for myElectionContext in network echelon area
   do

   if [ $myElectionContext == "network" ]; then
      networkContext
   elif [ $myElectionContext == "echelon" ]; then
      echelonContext
   elif [ $myElectionContext == "area" ]; then
      areaContext
   else
      echo Anomaly, unknown electionContext,should not get here!
   fi

   #if [ $MYIP != $preferredManager ] && [ $MANAGER_FLAG -eq 1 ] ; then
   #if [ $MYIP != $preferredManager ] && [ $NETWORK_MANAGER_FLAG -eq 1 ] ; then
   if [ $MYIP != $preferredManager ] && [ $MANAGER_FLAG -eq 1 ] ; then

      # I am not the preferred manager, I need to make sure I should remain as manager

      PREFERRED_MANAGER_FILE=$ANNOUNCE_FILE_BASE.$preferredManager
      if [ -f $PREFERRED_MANAGER_FILE ]; then 
         echo $MYIP : Preferred Manager is advertising, I am relinquishing management duties!
         echo $MYIP : Preferred Manager is advertising \($preferredManager\), I am relinquishing as manager!

         let MANAGER_FLAG=0
         #let NETWORK_MANAGER_FLAG=0
         if [ $myElectionContext == "network" ]; then
            let NETWORK_MANAGER_FLAG=0
         elif [ $myElectionContext == "echelon" ]; then
            let ECHELON_MANAGER_FLAG=0
         elif [ $myElectionContext == "area" ]; then
            let AREA_MANAGER_FLAG=0
         else
            echo Anomaly, unknown electionContext,should not get here!
         fi

         break
         #return 0
      fi 

      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag

      echo $j: Relinquish Section
       
      # dlm temp find me now
      #for target in $myNetworkList
      for target in $contextList
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
               #let NETWORK_MANAGER_FLAG=0
               if [ $myElectionContext == "network" ]; then
                  let NETWORK_MANAGER_FLAG=0
               elif [ $myElectionContext == "echelon" ]; then
                  let ECHELON_MANAGER_FLAG=0
               elif [ $myElectionContext == "area" ]; then
                  let AREA_MANAGER_FLAG=0
               else
                  echo Anomaly, unknown electionContext,should not get here!
               fi

               # dlm temp new 25 dec
               # delete my announcement files
               rm $ANNOUNCE_FILE 
               rm $ANNOUNCE_CANDIDATE_FILE 
               break
               #return 0
            else
               # I do not relinquish context election mgt , yet at least...
               echo I do not relinquish $electionContext election mgt, yet at least...
            fi 
         fi
      done

   else
      if [ $MYIP == $preferredManager ] ; then
         echo I am preferred $electionContext manager, no need to relinquish to anybody
      elif [ $MANAGER_FLAG -eq 0 ] ; then
      #elif [ $NETWORK_MANAGER_FLAG -eq 0 ] ; then
         echo I am not $electionContext manager, nothing to relinquish here
      else
         echo Anomaly, we should not get here!
      fi
   fi  # end if not preferred election context manager
   done

   ###############################################
   # End Context Election Manager Block and Loop
   ###############################################



#   ###################################
#   # network manager block
#   ###################################
#   for j in 1   # use the for loop block to allow goto like behavior , alternative is to create a function
#   do
##   if [ $MYIP != $preferredManager ] && [ $MANAGER_FLAG -eq 1 ] ; then
#   if [ $MYIP != $preferredManager ] && [ $NETWORK_MANAGER_FLAG -eq 1 ] ; then
#
#      # I am not the preferred network manager, I need to make sure I should remain as network manager
#
#      PREFERRED_MANAGER_FILE=$ANNOUNCE_FILE_BASE.$preferredManager
#      if [ -f $PREFERRED_MANAGER_FILE ]; then 
#         echo $MYIP : Preferred Manager is advertising, I am relinquishing management duties!
#         echo $MYIP : Preferred Manager is advertising \($preferredManager\), I am relinquishing as manager!
#         let MANAGER_FLAG=0
#         let NETWORK_MANAGER_FLAG=0
#         break
#         #return 0
#      fi 
#
#      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag
#
#      echo $j: Relinquish Section
#       
#      for target in $myNetworkList
#      do
#         echo $j: Relinquish Section : checking manager from target:$target
#         ls -l $ANNOUNCE_FILE_ALL 
#         if ls $ANNOUNCE_FILE_ALL | grep $target ; then
#            # compare $target to $MYIP
#            echo compare target:$target to myip:$MYIP
#            compareValue=`echo $target | cut -d\. -f 4`
#            myValue=`echo $MYIP | cut -d\. -f 4`
#            echo comparing compareValue:$compareValue to myValue:$myValue
#
#            #if [ $compareValue -lt $myValue ] ; then
#            if [ $target == $preferredManager ] ||  [ $compareValue -lt $myValue ] ; then
#               # I relinquish
#               echo I relinquish
#               let MANAGER_FLAG=0
#               let NETWORK_MANAGER_FLAG=0
#               # dlm temp new 25 dec
#               # delete my announcement files
#               rm $ANNOUNCE_FILE 
#               rm $ANNOUNCE_CANDIDATE_FILE 
#               break
#               #return 0
#            else
#               # I do not relinquish net mgt , yet at least...
#               echo I do not relinquish net mgt, yet at least...
#            fi 
#         fi
#
#      done
#
#   else
#      if [ $MYIP == $preferredManager ] ; then
#         echo I am preferred network manager, no need to relinquish to anybody
##      elif [ $MANAGER_FLAG -eq 0 ] ; then
#      elif [ $NETWORK_MANAGER_FLAG -eq 0 ] ; then
#         echo I am not network manager, nothing to relinquish here
#      else
#         echo Anomaly, we should not get here!
#      fi
#   fi  # end if not preferred network manager
#   done
#
#   ###############################################
#   # End Network Manager Block
#   ###############################################
#


   # dlm temp, use context loop above instead of this
   # dlm temp, use context loop above instead of this
   # dlm temp, use context loop above instead of this
   # dlm temp, use context loop above instead of this


#   ###################################
#   # echelon manager block
#   ###################################
#   for j in 1   # use the for loop block to allow goto like behavior , alternative is to create a function
#   do
#   if [ $MYIP != $preferredEchelonManager ] && [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
#
#      # I am not the preferred echelon manager, I need to make sure I should remain as echelon manager
#
#      PREFERRED_ECHELON_MANAGER_FILE=$ANNOUNCE_ECHELON_FILE_BASE.$preferredEchelonManager
#      if [ -f $PREFERRED_ECHELON_MANAGER_FILE ]; then 
#         echo $MYIP : Preferred Echelon Manager is advertising, I am relinquishing management duties!
#         echo $MYIP : Preferred Echelon Manager \($preferredEchelonManager\) is advertising, I am relinquishing as manager!
#         let ECHELON_MANAGER_FLAG=0
#         break
#         #return 0
#      fi 
#
#      # look for ties and do tie breaker, if we lose, we return without declaring via the manager flag
#
#      echo $j: Relinquish Section
#       
#      for target in $myEchelonList
#      do
#         echo $j: Relinquish Section : checking echelon manager from target:$target
#         ls -l $ANNOUNCE_ECHELON_FILE_ALL 
#         if ls $ANNOUNCE_ECHELON_FILE_ALL | grep $target ; then
#            # compare $target to $MYIP
#            echo compare target:$target to myip:$MYIP
#            compareValue=`echo $target | cut -d\. -f 4`
#            myValue=`echo $MYIP | cut -d\. -f 4`
#            echo comparing compareValue:$compareValue to myValue:$myValue
#
#            if [ $target == $preferredEchelonManager ] ||  [ $compareValue -lt $myValue ] ; then
#               # I relinquish
#               echo I relinquish
#               let ECHELON_MANAGER_FLAG=0
#               # dlm temp new 25 dec
#               # delete my announcement files
#               rm $ANNOUNCE_ECHELON_FILE 
#               rm $ANNOUNCE_ECHELON_CANDIDATE_FILE 
#               break
#               #return 0
#            else
#               # I do not relinquish echelon mgt, yet at least...
#               echo I do not relinquish echelon mgt, yet at least...
#            fi 
#         fi
#      done
#   else
#      if [ $MYIP == $preferredEchelonManager ] ; then
#         echo I am preferred echelon manager, no need to relinquish to anybody
#      elif [ $ECHELON_MANAGER_FLAG -eq 0 ] ; then
#         echo I am not an echelon manager, nothing to relinquish here
#      else
#         echo Anomaly, we should not get here!
#      fi
#   fi  # end if not preferred echelon manager
#   done
#   ###############################################
#   # End Echelon Manager Block
#   ###############################################
#   

   # dlm temp, use context loop above instead of this
   # dlm temp, use context loop above instead of this
   # dlm temp, use context loop above instead of this
   # dlm temp, use context loop above instead of this

   ###################################
   # area manager block
   ###################################
   ###############################################
   # End Echelon Manager Block
   ###############################################
   

} # end function relinquish




function doManager {

   echo `date` : doManager

   # network manager block
   #if [ $MANAGER_FLAG -eq 1 ] ; then
   if [ $NETWORK_MANAGER_FLAG -eq 1 ] ; then
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

   # area manager block
   if [ $AREA_MANAGER_FLAG -eq 1 ] ; then
      touch          $ANNOUNCE_AREA_FILE 
      sudo chmod 777 $ANNOUNCE_AREA_FILE 
      touch          $ANNOUNCE_AREA_FILE_NET_CHECKSUM 
      sudo chmod 777 $ANNOUNCE_AREA_FILE_NET_CHECKSUM 
   fi


   echo $MYIP : myNetworkList:$myNetworkList
   echo $MYIP : myEchelonList:$myEchelonList
   echo $MYIP : myAreaList:$myAreaList

   echo $MYIP : myNetworkList:$myNetworkList          > /tmp/myNetworkList.dat
   echo $MYIP : myEchelonList:$myEchelonList          > /tmp/myEchelonList.dat
   echo $MYIP : myAreaList:$myAreaList                > /tmp/myAreaList.dat

   identy=/home/pi/.ssh/id_rsa

   echo MANAGER_FLAG:$MANAGER_FLAG
   echo NETWORK_MANAGER_FLAG:$NETWORK_MANAGER_FLAG
   echo ECHELON_MANAGER_FLAG:$ECHELON_MANAGER_FLAG
   echo AREA_MANAGER_FLAG:$AREA_MANAGER_FLAG

   #if [ $NETWORK_MANAGER_ENABLED -eq 1 ] && [ $MANAGER_FLAG -eq 1 ] ; then
   if [ $NETWORK_MANAGER_ENABLED -eq 1 ] && [ $NETWORK_MANAGER_FLAG -eq 1 ] ; then
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
      #identy=/home/pi/.ssh/id_rsa
      sudo scp -i $identy $ANNOUNCE_FILE  $loginId@$target:/tmp &
      sudo scp -i $identy $ANNOUNCE_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
      sleep 1
   done
   fi

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
      #identy=/home/pi/.ssh/id_rsa
      sudo scp -i $identy $ANNOUNCE_ECHELON_FILE  $loginId@$target:/tmp &
      sudo scp -i $identy $ANNOUNCE_ECHELON_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
      sleep 1
   done
   fi

   if [ $AREA_MANAGER_ENABLED -eq 1 ] && [ $AREA_MANAGER_FLAG -eq 1 ] ; then
   for target in $myAreaList
   do
      if [ $DEBUG -eq 1 ] ;then
        echo Distributing $ANNOUNCE_AREA_FILE 
        echo Distributing $ANNOUNCE_AREA_FILE_NET_CHECKSUM 
      fi
      loginId=`$tagaUtilsDir/myLoginId.sh $target`
      # do this in the background so we don't get hung up
      echo JJJ sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp
      echo KKK sudo scp -i $identy $ANNOUNCE_AREA_FILE_NET_CHECKSUM  $loginId@$target:/tmp
      # do this in the background so we don't get hung up
      identy=/home/pi/.ssh/id_rsa
      sudo scp -i $identy $ANNOUNCE_AREA_FILE  $loginId@$target:/tmp &
      sudo scp -i $identy $ANNOUNCE_AREA_FILE_NET_CHECKSUM  $loginId@$target:/tmp &
      sleep 1
   done
   fi


   # dlm temp, note this is bully algorithm 
   # dlm temp, exit if I am not the preferred manager and the preferred manager is advertising

   echo TTTTTT preferredManager:$preferredManager
   echo TTTTTT preferredNetworkManager:$preferredNetworkManager
   echo TTTTTT preferredEchelonManager:$preferredEchelonManager
   echo TTTTTT preferredAreaManager:$preferredAreaManager

   PREFERRED_MANAGER_FILE=$ANNOUNCE_FILE_BASE.$preferredManager
   if [ $MYIP != $preferredManager ]; then
   if [ -f $PREFERRED_MANAGER_FILE ]; then 
      echo $MYIP : Preferred Manager is advertising, I am relinquishing management duties!
      echo $MYIP : Preferred Manager is advertising \($preferredManager\), I am relinquishing as manager!
      let MANAGER_FLAG=0
      let NETWORK_MANAGER_FLAG=0
   fi 
   fi

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


   PREFERRED_AREA_MANAGER_FILE=$ANNOUNCE_AREA_FILE_BASE.$preferredAreaManager
   if [ $MYIP != $preferredAreaManager ]; then
   if [ -f $PREFERRED_AREA_MANAGER_FILE ]; then 
      echo $MYIP : Preferred Area Manager is advertising, I am relinquishing management duties!
      echo $MYIP : Preferred Area Manager \($preferredAreaManager\) is advertising, I am relinquishing as manager!
      let AREA_MANAGER_FLAG=0

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
   #let networkManagerCount=0
   let echelonManagerCount=0
   let areaManagerCount=0

   # delete old files
   rm $ANNOUNCE_FILE_ALL               2>/dev/null
   rm $ANNOUNCE_NETWORK_FILE_ALL       2>/dev/null
   rm $ANNOUNCE_ECHELON_FILE_ALL       2>/dev/null
   rm $ANNOUNCE_AREA_FILE_ALL          2>/dev/null

   echo Contents:
   echo Contents:
   echo Contents:
   echo
   ls /tmp/*Ann*
   echo
   echo End Contents
   echo End Contents
   echo End Contents

   #sleep $MANAGER_AUDIT_INTERVAL
   $tagaUtilsDir/iboaDelay.sh $MANAGER_AUDIT_INTERVAL

   for target in $targetList
   do
   #if [ -f $ANNOUNCE_FILE ] ; then
   if [ -f $ANNOUNCE_FILE.$target ] ; then
      echo Info: File $ANNOUNCE_FILE.$target Exists!
      let managerCount=$managerCount+1
      echo managerCount:$managerCount
   fi 
   #if [ -f $ANNOUNCE_ECHELON_FILE ] ; then
   if [ -f $ANNOUNCE_ECHELON_FILE.$target ] ; then
      echo Info: File $ANNOUNCE_ECHELON_FILE.$target Exists!
      let echelonManagerCount=$echelonManagerCount+1
      echo echelonManagerCount:$echelonManagerCount
   fi 
   #if [ -f $ANNOUNCE_AREA_FILE ] ; then
   if [ -f $ANNOUNCE_AREA_FILE.$target ] ; then
      echo Info: File $ANNOUNCE_AREA_FILE.$target Exists!
      let areaManagerCount=$areaManagerCount+1
      echo areaManagerCount:$areaManagerCount
   fi 
   done

   # dlm temp, since we =cant have two return codes, 
   # let's cheat and use these return code global vars
   let retCodeNetwork=0
   let retCodeEchelon=0
   let retCodeArea=0

   if [ $managerCount -eq 0 ] ; then
      echo ALARM:MAJOR: $MYIP : No Manager Identified for this network! 
      let retCodeNetwork=2
   elif [ $managerCount -gt 1 ] ; then
      echo ALARM:MINOR: $MYIP : Multiple Managers Identified for this network! 
      let retCodeNetwork=1
   else
      echo INFO: $MYIP : Single Manager Verified for this network! 
      let retCodeNetwork=0
   fi

   if [ $echelonManagerCount -eq 0 ] ; then
      echo ALARM:MAJOR: $MYIP : No Echelon Manager Identified for this echelon! 
      #let retCode=2
      let retCodeEchelon=2
   elif [ $echelonManagerCount -gt 1 ] ; then
      echo ALARM:MINOR: $MYIP : Multiple Echelon Managers Identified for this echelon! 
      #let retCode=1
      let retCodeEchelon=1
   else
      echo INFO: $MYIP : Single Echelon Manager Verified for this echelon! 
      let retCodeEchelon=0
   fi

   if [ $areaManagerCount -eq 0 ] ; then
      echo ALARM:MAJOR: $MYIP : No Area Manager Identified for this area! 
      #let retCode=2
      let retCodeArea=2
   elif [ $areaManagerCount -gt 1 ] ; then
      echo ALARM:MINOR: $MYIP : Multiple Area Managers Identified for this area! 
      #let retCode=1
      let retCodeArea=1
   else
      echo INFO: $MYIP : Single Area Manager Verified for this area! 
      let retCodeArea=0
   fi

   # we still use network context as default , this is still used externally
   return $retCodeNetwork

}  # end function verifyManager


function maintain {

# Maintain the election
while true
do

   let retCode=0

   # resource the config
   source /home/pi/scripts/taga/tagaConfig/config

   # dlm temp change 27 dec
   myNetId=`echo $MYIP | cut -d\. -f 1-3`

   # update the checksum files with the new config
   netCheckSum=`sum $tagaConfigDir/targetList.sh | cut -c1-5`
   ANNOUNCE_NETWORK_FILE_NET_CHECKSUM=/tmp/managerAnnouncement.dat.$MYIP.$netCheckSum
   ANNOUNCE_ECHELON_FILE_NET_CHECKSUM=/tmp/managerAnnouncementEchelon.dat.$MYIP.$netCheckSum
   ANNOUNCE_AREA_FILE_NET_CHECKSUM=/tmp/managerAnnouncementArea.dat.$MYIP.$netCheckSum

   # set network context based on the updated configuration 
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

   #if  [ $MANAGER_FLAG -eq 1 ] || [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
   if  [ $NETWORK_MANAGER_FLAG -eq 1 ] || [ $ECHELON_MANAGER_FLAG -eq 1 ] ; then
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

      # dlm temp, this doesn't really work that well... we have lots of re-election going on 
      # for each iteration of verifyManager... perhaps call verifyManager between each block below?

      # dlm temp, this doesn't really work that well... we have lots of re-election going on 
      # for each iteration of verifyManager... perhaps call verifyManager between each block below?

      #########################
      # network manager block
      #########################
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

      # dlm temp, change 22 jan, call verify manager between blocks here
      verifyManager 

      #########################
      # echelon manager block
      #########################
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

      # dlm temp, change 22 jan, call verify manager between blocks here
      verifyManager 

      #########################
      # area manager block
      #########################
      if [ $retCodeArea -eq 0 ]; then
         echo Single Area Manager Verified

      elif [ $retCodeArea -eq 1 ]; then
         echo Multiple Area Managers Verified
         echo Enter Re-election process now!

         # call initial election to allow bully algorithm to function
         # in the event the IP addresses (provides our identity process) appear after init
         election
         # if we stil have no manager, do the re-election , note this is temporary until bully comes back
         re-election

      else
         echo No Area Manager Verified
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


