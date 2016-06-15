#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

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

   # determine LOGIN ID for each target
   MYLOGIN_ID=`$TAGA_UTILS_DIR/loginIdLookup.sh $target | tail -n 1`
   # dlm temp , I have no clue why this is needed but it is...
   MYLOGIN_ID=`echo $MYLOGIN_ID` 

   if [ $target == $MYIP ]; then
     echo
     echo skipping self \($target\) ...
     echo
     continue
   else
     echo
     echo processing, synchronizing $target

     # make the directory on remote (target) if it does not exist
     ssh -l $MYLOGIN_ID $target "sudo mkdir -p $MYDIR"

     # define the source string
     SCP_SOURCE_STR="."          
     SCP_SOURCE_STR="synchTaga.sh"          

     echo $SCP_SOURCE_STR
    
     # stage the files in /tmp
     scp -r $SCP_SOURCE_STR $MYLOGIN_ID@$target:/tmp # <$SCRIPTS_DIR/taga/passwd.txt

     for file in $SCP_SOURCE_STR
     do
        
        echo final processing of $file at $target  ....

        # move from tmp to the desired location
        ssh -l $MYLOGIN_ID $target "sudo mv /tmp/`basename $file` $MYDIR"

     done

   fi
done


