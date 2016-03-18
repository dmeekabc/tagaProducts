#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

TAGA_LINK=~/scripts/taga

MYDIR=`pwd`

echo; echo NOTICE: The follwing SHOULD NOT be a soft link:
echo "       $MYDIR "
echo; echo NOTICE: The follwing SHOULD NOT be the same:
echo "       MYDIR: $MYDIR  TAGA_LINK: $TAGA_LINK"
echo; echo NOTICE: The follwing link will be set or reset on target machines:
echo "       $TAGA_LINK "

# provide the info to print into the confirmation request
InfoToPrint=" $0 : $MYDIR will be synchronized and links adjusted."
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
     ssh -l darrin $target mkdir -p $MYDIR

     # define the source string
     SCP_SOURCE_STR="."          # use this to synch everything here and below

     # send the files to the destination
     scp -r $SCP_SOURCE_STR darrin@$target:$MYDIR # <$SCRIPTS_DIR/taga/passwd.txt

     # remove old link
     ssh -l darrin $target "rm $TAGA_LINK 2>/dev/null"

     # create new link
     ssh -l darrin $target "ln -s $MYDIR $TAGA_LINK"

   fi
done

