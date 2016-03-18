
TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

MYDIR=`pwd`

echo $MYDIR

############# 7 lines begin here #############
# provide the info to print into the confirmation request
InfoToPrint=" $0 : $MYDIR will be synchronized and links adjusted. Warn: This should not be a soft link!! "
# issue confirmation prompt and check reponse
$tagaUtilsDir/confirm.sh $0 "$InfoToPrint"
response=$?; if [ $response -ne 1 ]; then exit; fi
############# 7 lines end here #############

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
     SCP_SOURCE_STR="gitpull.sh" # use this to synch this file only
     SCP_SOURCE_STR="synchme.sh" # use this to synch this file only

     # send the files to the destination
     scp -r $SCP_SOURCE_STR darrin@$target:$MYDIR # <$SCRIPTS_DIR/taga/passwd.txt

     # remove old link
     ssh -l darrin $target "rm ~/scripts/taga 2>/dev/null"

     # create new link
     ssh -l darrin $target "ln -s $MYDIR ~/scripts/taga"

     # dlm temp, this is work in progress, 
     # dlm temp, note, currently pulls to root (not what we want)
     #ssh -l darrin $target $MYDIR/gitpull.sh

   fi
done

