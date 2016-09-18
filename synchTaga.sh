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

TAGA_LINK=/home/$MYLOGIN_ID/scripts/taga
MYDIR=/home/$MYLOGIN_ID/scripts/tagaProductized

echo; echo NOTICE: The follwing MUST NOT be a soft link:
echo "       $MYDIR "
echo; echo NOTICE: The follwing MUST NOT be the same:
echo "       MYDIR: $MYDIR  TAGA_LINK: $TAGA_LINK"
echo; echo NOTICE: If confirmed, the follwing link will be set or reset on all target user accounts and machines:
echo "       $TAGA_LINK "

# provide the info to print into the confirmation request
InfoToPrint=" $0 : $MYDIR will be synchronized and links adjusted."
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

# don't trust the user, double check that the $MYDIR is not a soft link!
checkVal=`ls -lrt $MYDIR | cut -c1`
if [ $checkVal == "l" ] ; then
  # then the user tried to sneak one by us... but this is a soft link!
  echo Error: $MYDIR is a soft link, exiting with no action!; echo
  exit
fi

# okay to proceed

echo;echo $targetList;echo

for target in $targetList
do

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   TAGA_LINK=/home/$MYLOGIN_ID/scripts/taga
   MYDIR=/home/$MYLOGIN_ID/scripts/tagaProductized

   if [ $target == $MYIP ]; then
     echo
     echo skipping self \($target\) ...
     echo
     continue
   else
     echo
     echo processing, synchronizing $target

     # remove old link
     ssh -l $MYLOGIN_ID $target "rm $TAGA_LINK 2>/dev/null"

     # make the new directory on remote (target) if it does not exist
     ssh -l $MYLOGIN_ID $target mkdir -p $MYDIR

     # define the source string
     SCP_SOURCE_STR="."          # use this to synch everything here and below

     # send the files to the destination
     scp -r $SCP_SOURCE_STR $MYLOGIN_ID@$target:$MYDIR # <$SCRIPTS_DIR/taga/passwd.txt

     # create new link
     ssh -l $MYLOGIN_ID $target "ln -s $MYDIR $TAGA_LINK"

   fi
done

