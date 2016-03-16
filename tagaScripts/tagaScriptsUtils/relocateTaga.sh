#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

NEW_LOCATION=/tmp/iboa
NEW_LOCATION_REPLACE_STRING="\\/tmp\\/iboa"
NEW_LOCATION=/opt/iboa
NEW_LOCATION_REPLACE_STRING="\\/opt\\/iboa"

echo
echo Notice: If confirmed, the TAGA dir will be relocated to: $NEW_LOCATION

# issue confirmation prompt
./confirm.sh
# check the response
let response=$?
if [ $response -eq 1 ]; then
  echo; echo Confirmed, $0 continuing....; echo
else
  echo; echo Not Confirmed, $0 exiting with no action...; echo
  exit
fi

sudo mkdir -p $NEW_LOCATION
sudo chmod 777 $NEW_LOCATION

for file in config
do
  echo $file
  sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $NEW_LOCATION/$file
done

for file in *.sh #config
do
  echo $file
  sudo cat $file | sed s/~\\/scripts\\/taga/$NEW_LOCATION_REPLACE_STRING/g > $NEW_LOCATION/$file
done

for file in $NEW_LOCATION/*.sh
do
   echo $file
   sudo chmod 755 $file
   diff $file `basename $file`
done

# copy the additional files
others="*.template passwd.txt code"
sudo cp -r $others $NEW_LOCATION

echo; echo New TAGA Location: $NEW_LOCATION; echo

