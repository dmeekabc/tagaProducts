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

FILE=tagaMgenDistro.tgz

if [ -f  $FILE ] ; then
   echo $FILE Found!
   cp $FILE /tmp
   cd /tmp
   tar zxvf $FILE
   cd mgenDistro
   cp -r tagaMini /tmp

   echo
   echo IBOA/TAGA Scipts and Aliases are available in /tmp/mgenDistro as follows:
   echo -------------------------------------------------------------------------

   sleep 2
   ls
   sleep 2
 
   echo
   echo IBOA/TAGA Scipts and Aliases are at the following:
   echo -------------------------------------------------------------------------
   pwd
   echo /tmp/tagaMini
   sleep 2
   echo


   # check for mgen binary
   if [ -f /usr/bin/mgen ]; then
      # found
      echo success, mgen is found at /usr/bin/mgen >/dev/null
   else
      # not found
      echo
      echo WARNING: /usr/bin/mgen was not found.
      echo
      echo INFO: You may choose to run one of the following based on your system/login info.
      echo INFO: Consider running one of the following:
      echo
      echo "For Ubuntu:"
      echo  "$ sudo cp /tmp/tagaMini/mcastUtils/bin/ubuntu/mgen /usr/bin"
      echo
      echo "For Raspberry Pi:"
      echo  "$ sudo cp /tmp/tagaMini/mcastUtils/bin/pi/mgen /usr/bin"
      echo
      echo Sleeping for 20 seconds...
      sleep 20
   fi


   if [ $# -gt 0 ] && [ $1 == "persist" ]; then
   
      # persistent install!

      # continue to execute the command

      # first, run the local (noSynchFlags) installs to get the vitals
      ./tagaConfigMiniInstall.sh noSynchFlag
      ./tagaUtilsInstall.sh noSynchFlag

      # now run the remote install commands 
      echo Running ./tagaConfigMiniInstall.sh
      ./tagaConfigMiniInstall.sh
      echo
      echo Running ./tagaUtilsInstall.sh
      ./tagaUtilsInstall.sh
      echo
      echo Running ./iboaMiniInstall.sh
      ./iboaMiniInstall.sh
      echo
      echo Running ./mcastMiniInstall.sh
      ./mcastMiniInstall.sh
      echo

      #echo Running ./tagaUtilsMiniInstall.sh
      #./tagaUtilsMiniInstall.sh
      #echo

      echo IBOA/TAGA Scipts and Aliases are available in /tmp/mgenDistro as follows:
      echo -------------------------------------------------------------------------

      sleep 2
      ls
      sleep 2
 
      echo
      echo IBOA/TAGA Scipts and Aliases are at the following:
      echo -------------------------------------------------------------------------
      pwd
      echo /tmp/tagaMini
      sleep 2
      echo


      echo "Preparing to Execute MCAST TEST (LISTEN and SEND) Commands"
      echo -------------------------------------------------------------------------
      echo
      echo "Notice: Enter Ctrl-c now if you do not wish to exeucte MCAST TEST (LISTEN and SEND) Commands"
      echo
      dots="."
      for i in 1 2 3 4 5
      do
        echo $dots
        dots="$dots ."
        sleep 1
      done
      echo "Now Executing MCAST TEST (LISTEN and SEND) Commands"
      echo -------------------------------------------------------------------------
      cd ~/tagaMini/mcastUtils
      echo
      echo Persistent Mcast Install Directory : `pwd`
      echo
      echo "Running MCASTSend & MCASTListen : ./mcastSend.sh & ./mcastListen.sh"
      echo "   ./mcastSend.sh & ./mcastListen.sh"

      # Run it
      ./mcastSend.sh & ./mcastListen.sh

      # end ifpersistent install

   else
      # not persistent install
      echo
      echo "****************************** CMD INFO **********************************"
      echo "  To test this temporary installation, run the following commands."
      echo "****************************** CMD INFO **********************************"
      echo
      echo CMD INFO: To test this temporary installation, run the following send and
      echo listen combined commands: e.g.,
      echo
      echo "$ /tmp/tagaMini/mcastUtils/mcastSend.sh & /tmp/tagaMini/mcastUtils/mcastListen.sh"
      echo
      echo CMD INFO: Alternately, source the aliasesMcast.txt file and run the multicast 
      echo test \('mct'\) alias as follows: e.g.,
      echo
      echo "$ source /tmp/mgenDistro/aliasesMcast.txt"
      echo "$ mct"
      echo
      echo "****************************** NOTICE **********************************"
      echo "  This installation is *not* persistent."
      echo "****************************** NOTICE **********************************"
      echo
      echo CMD INFO: Run $0 with the \'persist\' parameter for a persistent install. e.g.,
      echo
      echo "$ $0 persist"
      echo
      echo "****************************** NOTICE **********************************"
      echo "  This installation is *not* persistent."
      echo "****************************** NOTICE **********************************"

   # check AGAIN for mgen binary
   if [ -f /usr/bin/mgen ]; then
      # found
      echo success, mgen is found at /usr/bin/mgen >/dev/null
   else
      # not found
      echo
      echo WARNING: /usr/bin/mgen was not found.
      echo
      echo INFO: You may choose to run one of the following based on your system/login info.
      echo INFO: Consider running one of the following:
      echo
      echo "For Ubuntu:"
      echo  "$ sudo cp /tmp/tagaMini/mcastUtils/bin/ubuntu/mgen /usr/bin"
      echo
      echo "For Raspberry Pi:"
      echo  "$ sudo cp /tmp/tagaMini/mcastUtils/bin/pi/mgen /usr/bin"
      echo
   fi
      echo
      exit
   fi # end if persistent install
else
   echo $FILE Not Found!
fi

