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

# TAGA_CONTEXT1 is TAGAXXX HOSTS  (192.168.44.232, 192.168.44.237, 192.168.44.236)
# TAGA_CONTEXT2 is TAGAXXX ACTIVE (192.168.5.2,    192.168.3.2,    192.168.1.2)
# TAGA_CONTEXT3 is TAGAXXX ACTIVE (22.209.44.90   22.209.44.74    22.209.44.86)
# TAGA_CONTEXT4 is TAGAXXX HOSTS  (192.168.54.232 192.168.44.237, 192.168.44.236)

TAGA_CONTEXT=2


#######################################################################
# Automatic Network Identification and TAGA related configuration:
#######################################################################
# If we match a specific string, then use network accordingly,
# otherwise, use the default
#######################################################################

# default ................. 10.0.0
# first alternate ......... 192.168.41
# second alternate ........ 192.168.43
# third alternate ......... 172.16.41

NETADDR_STRING_TO_MATCH="192\\.168\\.41"
NETADDR_STRING_TO_MATCH2="192\\.168\\.43"
NETADDR_STRING_TO_MATCH3="172\\.16\\.41"


# auto config (note, this may be overriden on some systems)
if /sbin/ifconfig | grep $NETADDR_STRING_TO_MATCH >/dev/null; then
  # use first alternate
  let TAGA_TL_CONTEXT=1 # alternate
elif /sbin/ifconfig | grep $NETADDR_STRING_TO_MATCH2 >/dev/null; then
  # use second alternate
  let TAGA_TL_CONTEXT=2 # alternate
else
  # use default
  let TAGA_TL_CONTEXT=0 # default
fi

# jtmnm temp
# On this system, set Context Explicitly (override auto config above)
#let TAGA_TL_CONTEXT=1 # alternate


###################################################
# set the net address part 
###################################################

# set the NETWORK ADDRESS PART 
# Note: First 3 Nibbles,this assumes 24-bit or higher netmask
if [ $TAGA_TL_CONTEXT -eq 1 ]; then
   # first alternate
   NETADDRPART=192.168.41
elif [ $TAGA_TL_CONTEXT -eq 2 ]; then
   # second alternate
   NETADDRPART=192.168.43
else
   # default
   NETADDRPART=10.0.0
fi

###################################################
# set the ALTERNATE net address parts  
# Note: All nodes in the TAGA scope (networks of interest)
# must match the network address part above or an alternate below
###################################################
NETADDRPART_ALT1=1.1.1
NETADDRPART_ALT2=2.2.2
NETADDRPART_ALT3=192.168.21
NETADDRPART_ALT4=192.168.41
NETADDRPART_ALT5=192.168.44
NETADDRPART_ALT6=192.168.45
NETADDRPART_ALT7=192.168.46
NETADDRPART_ALT8=192.168.54
NETADDRPART_ALT9=192.168.55
NETADDRPART_ALT10=192.168.56
NETADDRPART_ALT11=192.168.101
NETADDRPART_ALT12=192.168.10
NETADDRPART_ALT13=192.168.20
NETADDRPART_ALT14=192.168.30
NETADDRPART_ALT15=192.168.40
NETADDRPART_ALT16=192.168.50
NETADDRPART_ALT17=192.168.60
NETADDRPART_ALT18=192.168.110
NETADDRPART_ALT19=192.168.120
NETADDRPART_ALT20=192.168.130
NETADDRPART_ALT21=192.168.140
NETADDRPART_ALT22=192.168.150
NETADDRPART_ALT23=192.168.160
NETADDRPART_ALT24=192.168.160
NETADDRPART_ALT25=192.168.160

###################################################
# define the TARGET LIST
###################################################

# Default to enabled

NET1="192.168.41.221 192.168.41.233 192.168.41.234 192.168.41.214 192.168.41.222" 
NET1="192.168.41.221 192.168.41.233 192.168.41.234 192.168.41.236 192.168.41.222" 
NET2="192.168.44.223 192.168.44.224 192.168.44.242"
NET3="192.168.54.224 192.168.54.238 192.168.54.223"
NET4="192.168.45.20 192.168.45.30"
NET5="192.168.46.50 192.168.46.70"
NET6="192.168.55.20"
NET7="192.168.56.60"

ECHELON4_LIST=$NET1
ECHELON3_LIST="$NET2 $NET3"
#ECHELON3_LIST="$NET2 "
ECHELON2_LIST="$NET4 $NET5 $NET6 $NET7"
#ECHELON2_LIST="$NET4 $NET5 "
ECHELON1_LIST=""

# Set the HOSTS  (remote to local ordering)
if [ $TAGA_CONTEXT -eq 4 ] ; then
   TAGAXXX_LIST_HOSTS="192.168.44.236 192.168.44.237 192.168.54.232"
   TAGAXXX_LIST_HOSTS="192.168.44.237 192.168.54.232"
elif [ $TAGA_CONTEXT -eq 3 ] ; then
   TAGAXXX_LIST_HOSTS="192.168.44.236 192.168.44.237 192.168.54.232"
   TAGAXXX_LIST_HOSTS="192.168.44.237 192.168.54.232"
   TAGAXXX_LIST_HOSTS=""
elif [ $TAGA_CONTEXT -eq 2 ] ; then
   TAGAXXX_LIST_HOSTS="192.168.44.236 192.168.44.237 192.168.54.232"
   TAGAXXX_LIST_HOSTS="192.168.44.237 192.168.54.232"
   TAGAXXX_LIST_HOSTS=""
else
   TAGAXXX_LIST_HOSTS="192.168.44.236 192.168.44.237 192.168.44.232"
   TAGAXXX_LIST_HOSTS="192.168.44.237 192.168.44.232"
fi

# Set the tagaxxx active list  (remote to local ordering)
if [ $TAGA_CONTEXT -eq 4 ] ; then
   TAGAXXX_LIST_ACTIVE="22.209.44.90"
   TAGAXXX_LIST_ACTIVE=""
   TAGAXXX_LIST_ACTIVE="22.209.44.90"
elif [ $TAGA_CONTEXT -eq 3 ] ; then
   TAGAXXX_LIST_ACTIVE="22.209.44.90 22.209.44.74 22.209.44.86"
elif [ $TAGA_CONTEXT -eq 2 ] ; then
   TAGAXXX_LIST_ACTIVE="192.168.5.2 192.168.1.2"
   TAGAXXX_LIST_ACTIVE="192.168.5.2 192.168.3.2 192.168.1.2"
elif [ $TAGA_CONTEXT -eq 1 ] ; then
   TAGAXXX_LIST_ACTIVE="192.168.5.2"
   TAGAXXX_LIST_ACTIVE=""
   TAGAXXX_LIST_ACTIVE="192.168.5.2"
else 
   TAGAXXX_LIST_ACTIVE=""
fi


####################################
# Bottom Up List
####################################
TARGET_LIST_BOTTOM_UP="$TAGAXXX_LIST_ACTIVE $ECHELON1_LIST $ECHELON2_LIST $ECHELON3_LIST $TAGAXXX_LIST_HOSTS $ECHELON4_LIST"

####################################
# Top Down List (Default)
####################################

if [ $TAGA_TL_CONTEXT -eq 1 ]; then
   # default
   TARGET_LIST=$BDE_TARGET_LIST
elif [ $TAGA_TL_CONTEXT -eq 2 ]; then
   # alternate
   TARGET_LIST="192.168.43.96 192.168.43.147 192.168.43.248 192.168.43.124 192.168.43.208"
   TARGET_LIST="192.168.43.96 192.168.43.97 192.168.43.146 192.168.43.28 192.168.43.124 "
   TARGET_LIST="192.168.43.96 192.168.43.97 192.168.43.146  192.168.43.124 "
   TARGET_LIST="192.168.43.97 192.168.43.96 192.168.43.146  192.168.43.124 "
   TARGET_LIST="192.168.43.97 192.168.43.143 192.168.43.147  192.168.43.124 "
   TARGET_LIST="192.168.43.40 192.168.43.146 192.168.43.147  192.168.43.124 "
   TARGET_LIST="192.168.43.40 192.168.43.146 192.168.43.147"
   TARGET_LIST="192.168.43.40 192.168.43.97 192.168.43.146 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.97 192.168.43.143 192.168.43.146 "
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.81 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.81 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.81 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.81 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.248 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.27 192.168.43.81 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.248 192.168.43.124"
   TARGET_LIST="192.168.43.40 192.168.43.81 192.168.43.97 192.168.43.143 192.168.43.146 192.168.43.147 192.168.43.248 "
   TARGET_LIST="172.16.41.220 172.16.41.221 172.16.41.225 172.16.41.226 172.16.41.233 172.16.41.234"
   TARGET_LIST="172.16.41.220 172.16.41.221 172.16.41.226 172.16.41.233 172.16.41.234"
   TARGET_LIST="192.168.43.27 192.168.43.81 192.168.43.96 192.168.43.97 192.168.43.146 192.168.43.147 192.168.43.148 192.168.43.248 "
   ECHELON4_LIST=$TARGET_LIST
   TARGET_LIST_BOTTOM_UP=$TARGET_LIST
else
   TARGET_LIST="10.0.0.8 10.0.0.9 10.0.0.10 10.0.0.11 10.0.0.22 10.0.0.27"
fi

####################################
# Other Lists and Derivative Lists
####################################

AREA1_LIST=$TARGET_LIST # xxx and Below
AREA2_LIST=$TARGET_LIST # xxx and Below
AREA3_LIST=$TARGET_LIST # xxx and Below

if [ $TAGA_CONTEXT -eq 3 ] || [ $TAGA_CONTEXT -eq 4 ]  ; then
   GWYLIST="192.168.41.233 192.168.41.234 192.168.44.223 192.168.44.224 192.168.54.223 192.168.54.224 192.168.54.232" 
else
   GWYLIST="192.168.41.233 192.168.41.234 192.168.44.223 192.168.44.224 192.168.54.223 192.168.54.224 192.168.44.232" 
fi

TAGALIST="192.168.41.221 192.168.44.233"
TAGALIST=$TARGET_LIST
TAGASOURCE="192.168.44.221"

##########################
# TAGAXXX HOST TARGET MAP
##########################
# TAGAXXXMAP: 192.168.1.2 192.168.44.232 192.168.54.232
# TAGAXXXMAP: 192.168.3.2 192.168.44.237 
# TAGAXXXMAP: 192.168.5.2 
# TAGAXXXMAP: 22.209.44.86 192.168.44.232 192.168.54.232
# TAGAXXXMAP: 22.209.44.74 192.168.44.237 
# TAGAXXXMAP: 22.209.44.90 

#TARGET_LIST="192.168.41.221 192.168.41.233 192.168.1.2 192.168.5.2 $NET2 $NET4 $NET5"
#TARGET_LIST="192.168.41.221 192.168.41.233 192.168.1.2 192.168.5.2 "

###################################################
# output the TARGET LIST
###################################################
echo $TARGET_LIST 

