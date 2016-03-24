#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

NAME=`basename $0`
#echo $MYIP : `basename $0` :  executing at `date`
echo "`$iboaUtilsDir/iboa_padded_echo.sh $MYIP:..$NAME 30` : executing at `date`"

MYDIR=`pwd`

echo $MYDIR

# provide the info to print into the confirmation request
InfoToPrint=" $MYDIR will be synchronized. "
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi

echo 
echo $targetList

for target in $targetList
do
   if [ $target == $MYIP ]; then
     echo
     echo skipping self \($target\) ...
     echo
     continue
   else
     echo
     echo processing, synchronizing $target

     # make the directory on remote (target) if it does not exist
     ssh -l $MYLOGIN_ID $target mkdir -p $MYDIR

     # define the source string
     SCP_SOURCE_STR="."          # use this to synch everything here and below

     # send the files to the destination
     scp -r $SCP_SOURCE_STR $MYLOGIN_ID@$target:$MYDIR # <$SCRIPTS_DIR/taga/passwd.txt

   fi
done

