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
source $TAGA_CONFIG_DIR/config

# dlm temp, this is really the daemon worker thread; 
# this (bash shell) script is periodically called by 
# the actual (python) deaemon process 

DAEMON=taga-controller

MGR_TAG=/tmp/managerAnnouncement.dat
MGR_TAG_NETWORK=/tmp/managerAnnouncement.dat
MGR_TAG_ECHELON=/tmp/managerAnnouncementEchelon.dat
MGR_TAG_AREA=/tmp/managerAnnouncementArea.dat

TAGA_TAG=/tmp/reaController.dat

TAGA_TAG=/tmp/tagaController.dat
TAGA_TAG_NETWORK=/tmp/tagaController.dat
TAGA_TAG_ECHELON=/tmp/tagaControllerEchelon.dat
TAGA_TAG_AREA=/tmp/tagaControllerArea.dat

TAGA_MGR_TAG=/tmp/managerAnnouncement.dat
TAGA_MGR_TAG_NETWORK=/tmp/managerAnnouncement.dat
TAGA_MGR_TAG_ECHELON=/tmp/managerAnnouncementEcheon.dat
TAGA_MGR_TAG_AREA=/tmp/managerAnnouncementArea.dat

SED_TAG="\/tmp\/managerAnnouncement\.dat\."
SED_TAG_NETWORK="\/tmp\/managerAnnouncement\.dat\."
SED_TAG_ECHELON="\/tmp\/managerAnnouncementEchelon\.dat\."
SED_TAG_AREA="\/tmp\/managerAnnouncementArea\.dat\."

FINAL_SELECTION=""
FINAL_SELECTION_NETWORK=""
FINAL_SELECTION_ECHELON=""
FINAL_SELECTION_AREA=""

TAGA_CONTROLLER_MANAGER=""

TAGA_CONTROLLER_MANAGER=""
TAGA_CONTROLLER_MANAGER_NETWORK=""
TAGA_CONTROLLER_MANAGER_ECHELON=""
TAGA_CONTROLLER_MANAGER_AREA=""


function networkContext {
   MGR_TAG=$MGR_TAG_NETWORK
   SED_TAG=$SED_TAG_NETWORK
   TAGA_TAG=$TAGA_TAG_NETWORK

} # end function networkContext

function echelonContext  {
   MGR_TAG=$MGR_TAG_ECHELON
   SED_TAG=$SED_TAG_ECHELON
   TAGA_TAG=$TAGA_TAG_ECHELON

} # end function  echelonContext

function areaContext {
   MGR_TAG=$MGR_TAG_AREA
   SED_TAG=$SED_TAG_AREA
   TAGA_TAG=$TAGA_TAG_AREA

} # end function areaContext

function selectManager {

   echo
   echo Notice: selectManager function called for: $1
   echo
   sleep 5

   echo TAGA Controller Manager Selection In process...
   echo Candidates Follow:
   echo ----------------------
   ls ${MGR_TAG}*
   echo ----------------------
      # Name Based
      echo If Selection Method is NAME Narrowed Selection Follows:
      echo ----------------------
      ls ${MGR_TAG}* | head -n 1
      echo ----------------------

      # Time Based
      echo If Selection Method is TIME Narrowed Selection Follows:
      echo ----------------------
      ls -t ${MGR_TAG}* | head -n 1
      echo ----------------------

   if [ $SELECTON_METHOD == "NAME" ]; then
      # Name Based
      echo Our Selection Method is NAME, Final Narrowed Selection Follows:
      echo ----------------------
      ls ${MGR_TAG}* | head -n 1
      FINAL_SELECTION=`ls ${MGR_TAG}* | head -n 1`
      echo ----------------------
   elif [ $SELECTON_METHOD == "SELF" ]; then
      echo Our Selection Method is SELF, Final Narrowed Selection Follows:
     # Not fully implemented!
     # Not fully implemented!
     # Not fully implemented!
      # Self Based
      # if we are candidate use self, otherwise use name based
      let self=0
      if [ $self -eq 1 ]; then 
         echo Our Selection Method is SELF and self is candidate, Final Narrowed Selection Follows:
         echo ----------------------
         ls ${MGR_TAG}* | head -n 1
         FINAL_SELECTION=`ls ${MGR_TAG}* | head -n 1`
         echo ----------------------
      else
         echo Our Selection Method is SELF but self not candidate, Final Narrowed Selection Follows:
         echo ----------------------
         ls ${MGR_TAG}* | head -n 1
         FINAL_SELECTION=`ls ${MGR_TAG}* | head -n 1`
         echo ----------------------
      fi
   else
      # Time Based
      echo Our Selection Method is TIME, Final Narrowed Selection Follows:
      echo ----------------------
      ls -t ${MGR_TAG}* | head -n 1
      FINAL_SELECTION=`ls -t ${MGR_TAG}* | head -n 1`
      echo ----------------------
   fi 
   echo Audit IS DONE Being In Progress >> /tmp/${DAEMON}_audit.log


ADDR_PART=`echo $FINAL_SELECTION | sed -e s/${SED_TAG}//g` # strip tag part 
#TAGA_CONTROLLER_MANAGER="{TAGA_}${ADDR_PART}_TAGA"
#TAGA_CONTROLLER_MANAGER="${ADDR_PART}_TAGA"
TAGA_CONTROLLER_MANAGER="${TAGA_TAG}${ADDR_PART}"

echo FINAL_SELECTION:$FINAL_SELECTION
echo TAGA_CONTROLLER_MANAGER:$TAGA_CONTROLLER_MANAGER_$ADDR_PART_$ADDR_PART
echo TAGA_CONTROLLER_MANAGER:$TAGA_CONTROLLER_MANAGER
echo

if [ $ADDR_PART ] ; then
  echo Creating $TAGA_CONTROLLER_MANAGER File: $TAGA_TAG with content: $ADDR_PART
   echo $ADDR_PART > $TAGA_TAG
else
  echo No ADDR_PART , NOT Creating $TAGA_CONTROLLER_MANAGER File: $TAGA_TAG with content: 
fi


} # end function selectManager


#######################################################
# MAIN
#######################################################

cd /tmp


#######################################################
# Selection Method - Bottom One wins (Name or Time)
#######################################################
SELECTON_METHOD="NAME"  # Selection based on Name (First / Lowest)
SELECTON_METHOD="SELF"  # Selection based on Self (If I am Candidate)
SELECTON_METHOD="TIME"  # Selection based on Time (Newest)

# dlm temp , move to taga config
let TAGA_CONTROLLER_AUDIT_ENABLED=0
let TAGA_CONTROLLER_AUDIT_ENABLED=1

# continue to execute the command
echo `basename $0` Proceeding.... at `date`; echo

iteration=0

if [ $# -ge 1 ] ; then
   iteration=$1
fi

if [ $iteration -le 1 ]; then
   echo `basename $0` iteration: $iteration
fi

/usr/bin/sudo /bin/touch                              /tmp/${DAEMON}_daemon.out
/usr/bin/sudo /bin/touch                              /tmp/${DAEMON}_audit.log
/usr/bin/sudo /bin/chmod 777                          /tmp/${DAEMON}_daemon.out
/usr/bin/sudo /bin/chmod 777                          /tmp/${DAEMON}_audit.log
/usr/bin/sudo /bin/echo `date` : iter:$iteration  >>  /tmp/${DAEMON}_daemon.out
/usr/bin/sudo /bin/echo `date` : iter:$iteration  >>  /tmp/${DAEMON}_daemon_fix.log

myState=`cat /var/opt/taga/run/tagaState.dat`

echo myState: $myState
echo AUDITOR: $AUDITOR
echo MYIP: $MYIP

if [ $TAGA_CONTROLLER_AUDIT_ENABLED -eq 1 ] ; then
   date
   echo JTE-TAGA-CONTROLER AUDIT is ENABLED - Proceeding with Audit NOW! > /dev/null
   echo `basename $0` `date`                                          >> /tmp/${DAEMON}_audit.log
   echo JTE-TAGA-CONTROLLER AUDIT is ENABLED - Proceeding with Audit NOW! >> /tmp/${DAEMON}_audit.log
else
   date
   echo JTE-TAGA-CONTROLLER AUDIT is DISABLED - EXITING NOW!
   echo `basename $0` `date`                             >> /tmp/${DAEMON}_audit.log
   echo JTE-TAGA-CONTROLLER AUDIT is DISABLED - EXITING NOW! >> /tmp/${DAEMON}_audit.log
   exit
fi

# Do the Audit Periodically (based on AUDIT_MODVAL)
if echo $AUDITOR | grep $MYIP ; then
  AUDIT_MODVAL=1
  AUDIT_MODVAL=10
  let CHECKVAL=$iteration%$AUDIT_MODVAL
  if [ $CHECKVAL -eq 0 ]; then
     let auditEnabled=1
  else
     let auditEnabled=0
  fi
else
  echo I am not An Auditor,  Audit Not Enabled on this node.!
  let auditEnabled=0
fi

if [ $auditEnabled -eq 1 ]; then
   echo Audit In Progress >> /tmp/${DAEMON}_audit.log
   #   $HOME/scripts/taga/tagaScripts/tagaScriptsUtils/tagaLogManagement.sh >> /tmp/${DAEMON}_audit.log
else
   echo Audit IS In Progress >> /tmp/${DAEMON}_audit.log
   #   /home/pi/scripts/taga/tagaScripts/tagaScriptsUtils/tagaLogManagement.sh >> /tmp/${DAEMON}_audit.log

   ########################################################################
   # Main Audit Function - selectManager for Network, Echeclon, and Area 
   ########################################################################
   for managerType in network echelon area
   do
      if [ $managerType == "network" ]; then
         networkContext
      elif [ $managerType == "echelon" ]; then
         echelonContext
      elif [ $managerType == "area" ]; then
         areaContext
      else
         echo Anomaly should not get here!  Invalid manager Type!
      fi

      # Do it - Select the Manager
      selectManager $managerType

   done
fi
