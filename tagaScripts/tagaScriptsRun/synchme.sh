
TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYDIR=`pwd`

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
     SCP_SOURCE_STR="synchme.sh" # use this to synch this file only
     SCP_SOURCE_STR="."          # use this to synch everything here and below

     # send the files to the destination
     scp -r $SCP_SOURCE_STR darrin@$target:$MYDIR # <$SCRIPTS_DIR/taga/passwd.txt

   fi

done

