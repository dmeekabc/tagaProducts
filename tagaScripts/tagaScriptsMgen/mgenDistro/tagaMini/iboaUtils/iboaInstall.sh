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
source $TAGA_CONFIG_DIR/config
# Set the TAGA DIR BASE
if [ -d ~/scripts/tagaXXXXXXXXXX ]; then
  TAGA_DIR=~/scripts/taga # new mar 2016, relocateable
elif [ -d ~/tagaMini ]; then
  TAGA_DIR=~/tagaMini     # new sept 2016, tagaMini version
else
  TAGA_DIR=/tmp/tagaMini  # new sept 2016, tagaMini version
fi

# Set and Source the TAGA CONFIG Dir
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config


# install iboa if not already installed
if cat ~/.bashrc | grep iboa | grep bashrc >/dev/null; then
   echo iboa already installed 
else

   # define the iboa env var file names for system, group, and user
   IBOA_FILE=~/.bashrc.iboa
   IBOA_USER_FILE=~/.bashrc.iboa.user.`id -u`
   IBOA_GROUP_FILE=/usr/share/.bashrc.iboa.group.`id -g`
   IBOA_SYSTEM_FILE=/usr/share/.bashrc.iboa.system

   # print to the terminal
   echo Creating files...
   echo $IBOA_FILE
   echo $IBOA_USER_FILE
   echo $IBOA_GROUP_FILE
   echo $IBOA_SYSTEM_FILE

   # create empty files
   sudo touch $IBOA_FILE
   sudo touch $IBOA_USER_FILE
   sudo touch $IBOA_GROUP_FILE
   sudo touch $IBOA_SYSTEM_FILE

   # change the permissions on the empty files
   sudo chmod 777 $IBOA_FILE
   sudo chmod 777 $IBOA_USER_FILE
   sudo chmod 777 $IBOA_GROUP_FILE
   sudo chmod 777 $IBOA_SYSTEM_FILE

   # create the .bashrc.iboa file and create the editor variable 
   echo \#IBOA_EDITOR=emacs                                                     >> $IBOA_FILE
   echo \#IBOA_EDITOR=gedit                                                     >> $IBOA_FILE
   echo IBOA_EDITOR=vi                                                          >> $IBOA_FILE

   # create the 'add alias' (aa/aax) aliases
   echo "alias aau='\$IBOA_EDITOR $IBOA_USER_FILE; source $IBOA_USER_FILE'"     >> $IBOA_FILE
   echo "alias aag='\$IBOA_EDITOR $IBOA_GROUP_FILE; source $IBOA_GROUP_FILE'"   >> $IBOA_FILE
   echo "alias aas='\$IBOA_EDITOR $IBOA_SYSTEM_FILE; source $IBOA_SYSTEM_FILE'" >> $IBOA_FILE
   echo "alias aai='\$IBOA_EDITOR $IBOA_FILE; source $IBOA_FILE'"               >> $IBOA_FILE
   echo \#alias aa=aai                                                          >> $IBOA_FILE
   echo \#alias aa=aas                                                          >> $IBOA_FILE
   echo \#alias aa=aag                                                          >> $IBOA_FILE
   echo alias aa=aau                                                            >> $IBOA_FILE

   # create the insertAliasUser function for the 'install alias user' (iau) alias
   echo "function __insertAliasUser() {"                                         >> $IBOA_FILE
   echo "  if [ \$# -ge 1 ]; then"                                               >> $IBOA_FILE
   echo "    alias \$@ >> $IBOA_USER_FILE"                                       >> $IBOA_FILE
   echo "    if [ \$? -eq 0 ]; then"                                             >> $IBOA_FILE
   echo "      source $IBOA_USER_FILE"                                           >> $IBOA_FILE
   echo "      echo alias\(es\) successfully installed into $IBOA_USER_FILE"     >> $IBOA_FILE
   echo "    fi"                                                                 >> $IBOA_FILE
   echo "  else"                                                                 >> $IBOA_FILE
   echo "    echo this alias requires at least one parameter - no action taken!" >> $IBOA_FILE
   echo "  fi"                                                                   >> $IBOA_FILE
   echo "}"                                                                      >> $IBOA_FILE

   # create the insertAliasGroup function for the 'install alias group' (iag) alias
   echo "function __insertAliasGroup() {"                                        >> $IBOA_FILE
   echo "  if [ \$# -ge 1 ]; then"                                               >> $IBOA_FILE
   echo "    alias \$@ >> $IBOA_GROUP_FILE"                                      >> $IBOA_FILE
   echo "    if [ \$? -eq 0 ]; then"                                             >> $IBOA_FILE
   echo "      source $IBOA_GROUP_FILE"                                          >> $IBOA_FILE
   echo "      echo alias\(es\) successfully installed into $IBOA_GROUP_FILE"    >> $IBOA_FILE
   echo "    fi"                                                                 >> $IBOA_FILE
   echo "  else"                                                                 >> $IBOA_FILE
   echo "    echo this alias requires at least one parameter - no action taken!" >> $IBOA_FILE
   echo "  fi"                                                                   >> $IBOA_FILE
   echo "}"                                                                      >> $IBOA_FILE

   # create the insertAliasSystem function for the 'install alias system' (ias) alias
   echo "function __insertAliasSystem() {"                                       >> $IBOA_FILE
   echo "  if [ \$# -ge 1 ]; then"                                               >> $IBOA_FILE
   echo "    alias \$@ >> $IBOA_SYSTEM_FILE"                                     >> $IBOA_FILE
   echo "    if [ \$? -eq 0 ]; then"                                             >> $IBOA_FILE
   echo "      source $IBOA_SYSTEM_FILE"                                         >> $IBOA_FILE
   echo "      echo alias\(es\) successfully installed into $IBOA_SYSTEM_FILE"   >> $IBOA_FILE
   echo "    fi"                                                                 >> $IBOA_FILE
   echo "  else"                                                                 >> $IBOA_FILE
   echo "    echo this alias requires at least one parameter - no action taken!" >> $IBOA_FILE
   echo "  fi"                                                                   >> $IBOA_FILE
   echo "}"                                                                      >> $IBOA_FILE

   # create the insertAliasIboa function for the 'install alias iboa' (iai) alias
   echo "function __insertAliasIboa() {"                                         >> $IBOA_FILE
   echo "  if [ \$# -ge 1 ]; then"                                               >> $IBOA_FILE
   echo "    alias \$@ >> $IBOA_FILE"                                            >> $IBOA_FILE
   echo "    if [ \$? -eq 0 ]; then"                                             >> $IBOA_FILE
   echo "      source $IBOA_FILE"                                                >> $IBOA_FILE
   echo "      echo alias\(es\) successfully installed into $IBOA_FILE"          >> $IBOA_FILE
   echo "    fi"                                                                 >> $IBOA_FILE
   echo "  else"                                                                 >> $IBOA_FILE
   echo "    echo this alias requires at least one parameter - no action taken!" >> $IBOA_FILE
   echo "  fi"                                                                   >> $IBOA_FILE
   echo "}"                                                                      >> $IBOA_FILE

   # create the insertAliasPrevious function for the 'install alias previous' (previous command) (iap) alias
   echo "function __insertAliasPrevious() {"                                     >> $IBOA_FILE
   echo "  if [ \$# -eq 1 ]; then"                                               >> $IBOA_FILE
   echo "    which \$1 "                                                         >> $IBOA_FILE
   echo "    if [ \$? -eq 0 ]; then"                                             >> $IBOA_FILE
   echo "      echo the \$1 command exists - no action taken!"                   >> $IBOA_FILE
   echo "    else"                                                               >> $IBOA_FILE
   echo "      alias \$1  >/dev/null 2>/dev/null"                                >> $IBOA_FILE
   #echo "      if [ \$? -eq 0 ]; then"                                          >> $IBOA_FILE
   echo "      if [ \$? -eq 0 ] && [ \$1 != 'doit' ] && [ \$1 != 'doitw' ] ; then"   >> $IBOA_FILE
   echo "        echo the \$1 alias exists - no action taken!"                   >> $IBOA_FILE
   echo "      else"                                                             >> $IBOA_FILE
   echo "        CMD=\`history | tail -n 2 | head -n 1 | cut -c8-\`"             >> $IBOA_FILE
   echo "        echo alias \$1=\'\$CMD\' >> $IBOA_USER_FILE"                    >> $IBOA_FILE
   echo "        if [ \$? -eq 0 ]; then"                                         >> $IBOA_FILE
   echo "          source $IBOA_USER_FILE"                                       >> $IBOA_FILE
   echo "          echo alias\(es\) successfully installed into $IBOA_USER_FILE" >> $IBOA_FILE
   echo "        fi"                                                             >> $IBOA_FILE
   echo "      fi"                                                               >> $IBOA_FILE
   echo "    fi"                                                                 >> $IBOA_FILE
   echo "  else"                                                                 >> $IBOA_FILE
   echo "    echo this alias requires a single parameter - no action taken!"     >> $IBOA_FILE
   echo "  fi"                                                                   >> $IBOA_FILE
   echo "}"                                                                      >> $IBOA_FILE

   # create the wrapAliasPrevious function for the 'wrap alias previous' (previous command) (wap) alias
   echo "function __insertAliasPreviousWrapped() {"                              >> $IBOA_FILE
   echo "  if [ \$# -eq 1 ]; then"                                               >> $IBOA_FILE
   echo "    which \$1 "                                                         >> $IBOA_FILE
   echo "    if [ \$? -eq 0 ]; then"                                             >> $IBOA_FILE
   echo "      echo the \$1 command exists - no action taken!"                   >> $IBOA_FILE
   echo "    else"                                                               >> $IBOA_FILE
   echo "      alias \$1  >/dev/null 2>/dev/null"                                >> $IBOA_FILE
   #echo "      if [ \$? -eq 0 ]; then"                                           >> $IBOA_FILE
   echo "      if [ \$? -eq 0 ] && [ \$1 != 'doit' ] && [ \$1 != 'doitw' ] ; then"   >> $IBOA_FILE
   echo "        echo the \$1 alias exists - no action taken!"                   >> $IBOA_FILE
   echo "      else"                                                             >> $IBOA_FILE
   echo "        CMD=\`history | tail -n 2 | head -n 1 | cut -c8-\`"             >> $IBOA_FILE
   echo "        echo \"alias \$1='while true; do echo; date; \$CMD ; sleep 1; done'\" >> $IBOA_USER_FILE" >> $IBOA_FILE
   echo "        if [ \$? -eq 0 ]; then"                                         >> $IBOA_FILE
   echo "          source $IBOA_USER_FILE"                                       >> $IBOA_FILE
   echo "          echo alias\(es\) successfully installed into $IBOA_USER_FILE" >> $IBOA_FILE
   echo "        fi"                                                             >> $IBOA_FILE
   echo "      fi"                                                               >> $IBOA_FILE
   echo "    fi"                                                                 >> $IBOA_FILE
   echo "  else"                                                                 >> $IBOA_FILE
   echo "    echo this alias requires a single parameter - no action taken!"     >> $IBOA_FILE
   echo "  fi"                                                                   >> $IBOA_FILE
   echo "}"                                                                      >> $IBOA_FILE

   # create the 'install alias' (ia/iax) aliases
   echo "alias iau='__insertAliasUser'"                                          >> $IBOA_FILE
   echo "alias iag='__insertAliasGroup'"                                         >> $IBOA_FILE
   echo "alias ias='__insertAliasSystem'"                                        >> $IBOA_FILE
   echo "alias iai='__insertAliasIboa'"                                          >> $IBOA_FILE
   echo "alias iap='__insertAliasPrevious'"                                      >> $IBOA_FILE
   echo "alias iapw='__insertAliasPreviousWrapped'"                              >> $IBOA_FILE
   echo \#alias ia=iai                                                           >> $IBOA_FILE
   echo \#alias ia=ias                                                           >> $IBOA_FILE
   echo \#alias ia=iag                                                           >> $IBOA_FILE
   echo alias ia=iau                                                             >> $IBOA_FILE
   echo alias wap=iapw                                                          >> $IBOA_FILE


   # create the 'lr' and the 'gt' and the 'u' aliases 
   echo alias lr=\'ls -lrth\'                                                    >> $IBOA_FILE
   echo alias gt=\'cd /tmp\'                                                     >> $IBOA_FILE
   echo alias u=\'cd ..\'                                                        >> $IBOA_FILE
   echo alias uu=\'u\;u\'                                                        >> $IBOA_FILE
   echo alias uuu=\'u\;u\;u\'                                                    >> $IBOA_FILE
   echo alias uuuu=\'u\;u\;u\;u\'                                                >> $IBOA_FILE
   echo alias uuuuu=\'u\;u\;u\;u\;u\'                                            >> $IBOA_FILE
   echo alias uuuuuu=\'u\;u\;u\;u\;u\;u\'                                        >> $IBOA_FILE
   echo alias uuuuuuu=\'u\;u\;u\;u\;u\;u\;u\'                                    >> $IBOA_FILE
   echo alias uuuuuuuu=\'u\;u\;u\;u\;u\;u\;u\;u\'                                >> $IBOA_FILE
   echo alias uuuuuuuuu=\'u\;u\;u\;u\;u\;u\;u\;u\;u\'                            >> $IBOA_FILE
   echo alias uuuuuuuuuu=\'u\;u\;u\;u\;u\;u\;u\;u\;u\;u\'                        >> $IBOA_FILE

   # build .bashrc.iboa.user.$user
   echo "################################################################" >> $IBOA_USER_FILE
   echo "# Place your aliases below; See the 'testiboa' alias for example" >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "alias testiboa='echo This is a Test'"                             >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "# BEGIN TAGA Exensions are included here                        " >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "alias run='echo This is a Test'"                                  >> $IBOA_USER_FILE
   echo "alias x='exit'"                                                   >> $IBOA_USER_FILE
   echo "alias g='TAGA_DIR=~/scripts/taga; cd \$TAGA_DIR'"                 >> $IBOA_USER_FILE
   echo "alias trace='alias > ~/scripts/taga/iboaUtils/aliasList.txt; ~/scripts/taga/iboaUtils/aliasTrace.sh'" >> $IBOA_USER_FILE
   echo "alias trac='trace'"                                               >> $IBOA_USER_FILE
   echo "alias tra='trac'"                                                 >> $IBOA_USER_FILE
   echo "alias tr='tra'"                                                   >> $IBOA_USER_FILE
   echo "alias ta='tr'"                                                    >> $IBOA_USER_FILE
   echo "alias t='tr'"                                                     >> $IBOA_USER_FILE
   echo "alias s='ps -ef | grep -v grep | grep \$1'"                       >> $IBOA_USER_FILE
   echo "alias ea='aa'"                                                    >> $IBOA_USER_FILE
   echo "alias run='TAGA_DIR=~/scripts/taga; \$TAGA_DIR/runLoopWrapper.sh'" >> $IBOA_USER_FILE
   echo "alias mon='TAGA_DIR=~/scripts/taga; touch \$TAGA_DIR/counts.txt; tail -f \$TAGA_DIR/counts.txt'" >> $IBOA_USER_FILE
   echo "alias grem='TAGA_DIR=~/scripts/taga; \$TAGA_DIR/remoteLoginAll.sh'" >> $IBOA_USER_FILE
   echo "alias vc='TAGA_DIR=~/scripts/taga; vi \$TAGA_DIR/config'"         >> $IBOA_USER_FILE
   echo "alias vt='TAGA_DIR=~/scripts/taga; vi \$TAGA_DIR/targetList.sh'"  >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "# END TAGA Exensions are included here                          " >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "# Place your aliases below; See the 'testiboa' alias for example" >> $IBOA_USER_FILE
   echo "################################################################" >> $IBOA_USER_FILE
   echo "alias testiboa='echo This is a Test'"                             >> $IBOA_USER_FILE
   # build .bashrc.iboa.group.$group
   echo "################################################################" >> $IBOA_GROUP_FILE
   echo "# Place your aliases below; See the 'testiboa' alias for example" >> $IBOA_GROUP_FILE
   echo "################################################################" >> $IBOA_GROUP_FILE
   echo "alias testiboa='echo This is a Test'"                             >> $IBOA_GROUP_FILE
   # build .bashrc.iboa.system
   echo "################################################################" >> $IBOA_SYSTEM_FILE
   echo "# Place your aliases below; See the 'testiboa' alias for example" >> $IBOA_SYSTEM_FILE
   echo "################################################################" >> $IBOA_SYSTEM_FILE
   echo "alias testiboa='echo This is a Test'"                             >> $IBOA_SYSTEM_FILE

   # order below matters!  current policy, let user override group and let system have final say
   echo source $IBOA_GROUP_FILE  >> $IBOA_FILE
   echo source $IBOA_USER_FILE   >> $IBOA_FILE
   echo source $IBOA_SYSTEM_FILE >> $IBOA_FILE

   # install iboa
   echo source $IBOA_FILE >> ~/.bashrc

   # source the new ~/.bashrc file! 
    source ~/.bashrc file

   # Inform the user that they should source ~/.bashrc
   echo Please source ~/.bashrc file, e.g. [ source ~/.bashrc ]

fi


