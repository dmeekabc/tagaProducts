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

# TAGA_CONTEXT1 is TAGAXXX HOSTS  (10.10.44.232, 10.10.44.237, 10.10.44.236)
# TAGA_CONTEXT2 is TAGAXXX ACTIVE (10.10.5.2,    10.10.3.2,    10.10.1.2)
# TAGA_CONTEXT3 is TAGAXXX ACTIVE (22.209.44.90   22.209.44.74    22.209.44.86)
# TAGA_CONTEXT4 is TAGAXXX HOSTS  (10.10.54.232 10.10.44.237, 10.10.44.236)

TAGA_CONTEXT=2


#######################################################################
# Automatic Network Identification and TAGA related configuration:
#######################################################################
# If we match a specific string, then use network accordingly,
# otherwise, use the default
#######################################################################

# default ................. 10.0.0
# first alternate ......... 10.10.41
# second alternate ........ 10.10.43

NETADDR_STRING_TO_MATCH="10\\.10\\.41"
NETADDR_STRING_TO_MATCH2="10\\.10\\.43"


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

# On this system, set Context Explicitly (override auto config above)
#let TAGA_TL_CONTEXT=1 # alternate


###################################################
# set the net address part 
###################################################

# set the NETWORK ADDRESS PART 
# Note: First 3 Nibbles,this assumes 24-bit or higher netmask
if [ $TAGA_TL_CONTEXT -eq 1 ]; then
   # first alternate
   NETADDRPART=10.10.41
elif [ $TAGA_TL_CONTEXT -eq 2 ]; then
   # second alternate
   NETADDRPART=10.10.43
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
NETADDRPART_ALT3=10.10.21
NETADDRPART_ALT4=10.10.41
NETADDRPART_ALT5=10.10.44
NETADDRPART_ALT6=10.10.45
NETADDRPART_ALT7=10.10.46
NETADDRPART_ALT8=10.10.54
NETADDRPART_ALT9=10.10.55
NETADDRPART_ALT10=10.10.56
NETADDRPART_ALT11=10.10.101
NETADDRPART_ALT12=10.10.10
NETADDRPART_ALT13=10.10.20
NETADDRPART_ALT14=10.10.30
NETADDRPART_ALT15=10.10.40
NETADDRPART_ALT16=10.10.50
NETADDRPART_ALT17=10.10.60
NETADDRPART_ALT18=10.10.110
NETADDRPART_ALT19=10.10.120
NETADDRPART_ALT20=10.10.130
NETADDRPART_ALT21=10.10.140
NETADDRPART_ALT22=10.10.150
NETADDRPART_ALT23=10.10.160
NETADDRPART_ALT24=10.10.160
NETADDRPART_ALT25=10.10.160

###################################################
# define the TARGET LIST
###################################################

TIER4_LIST="10.10.41.221 10.10.41.233 10.10.41.234 10.10.41.218 10.10.41.222"
TIER4_LIST="10.10.41.221 10.10.41.233 10.10.41.234 10.10.41.222 10.10.41.218"
TIER3_LIST="10.10.44.223 10.10.44.224 10.10.54.224 10.10.54.238 10.10.54.223 10.10.44.242"
TIER2_LIST="10.10.45.20 10.10.45.30 10.10.45.90 10.10.46.50 10.10.46.70 10.10.55.20 10.10.55.30 10.10.56.60"
TIER2_LIST="10.10.45.20 10.10.45.30 10.10.46.50 10.10.46.70 10.10.55.20 10.10.56.60"
TIER2_LIST="10.10.45.20 10.10.45.30 10.10.45.90 10.10.46.50 10.10.46.70 10.10.55.20 10.10.56.60"
TIER1_LIST=""



# Set the HOSTS  (remote to local ordering)
if [ $TAGA_CONTEXT -eq 4 ] ; then
   TAGAXXX_LIST_HOSTS="10.10.44.236 10.10.44.237 10.10.54.232"
   TAGAXXX_LIST_HOSTS="10.10.44.237 10.10.54.232"
elif [ $TAGA_CONTEXT -eq 3 ] ; then
   TAGAXXX_LIST_HOSTS="10.10.44.236 10.10.44.237 10.10.54.232"
   TAGAXXX_LIST_HOSTS="10.10.44.237 10.10.54.232"
   TAGAXXX_LIST_HOSTS=""
elif [ $TAGA_CONTEXT -eq 2 ] ; then
   TAGAXXX_LIST_HOSTS="10.10.44.236 10.10.44.237 10.10.54.232"
   TAGAXXX_LIST_HOSTS="10.10.44.237 10.10.54.232"
   TAGAXXX_LIST_HOSTS=""
else
   TAGAXXX_LIST_HOSTS="10.10.44.236 10.10.44.237 10.10.44.232"
   TAGAXXX_LIST_HOSTS="10.10.44.237 10.10.44.232"
fi

# Set the tagaxxx active list  (remote to local ordering)
if [ $TAGA_CONTEXT -eq 4 ] ; then
   TAGAXXX_LIST_ACTIVE="22.209.44.90"
   TAGAXXX_LIST_ACTIVE=""
   TAGAXXX_LIST_ACTIVE="22.209.44.90"
elif [ $TAGA_CONTEXT -eq 3 ] ; then
   TAGAXXX_LIST_ACTIVE="22.209.44.90 22.209.44.74 22.209.44.86"
elif [ $TAGA_CONTEXT -eq 2 ] ; then
   TAGAXXX_LIST_ACTIVE="10.10.5.2 10.10.3.2 10.10.1.2"
elif [ $TAGA_CONTEXT -eq 1 ] ; then
   TAGAXXX_LIST_ACTIVE="10.10.5.2"
   TAGAXXX_LIST_ACTIVE=""
   TAGAXXX_LIST_ACTIVE="10.10.5.2"
else 
   TAGAXXX_LIST_ACTIVE=""
fi


BDE_TARGET_LIST="$TIER4_LIST $TIER3_LIST $TIER2_LIST $TIER1_LIST $TAGAXXX_LIST_HOSTS $TAGAXXX_LIST_ACTIVE"


####################################
# Top Down List (Default)
####################################

if [ $TAGA_TL_CONTEXT -eq 1 ]; then
   # default
   TARGET_LIST=$BDE_TARGET_LIST
elif [ $TAGA_TL_CONTEXT -eq 2 ]; then
   # alternate
   TARGET_LIST="10.10.43.97 10.10.43.147 10.10.43.124 "
   TARGET_LIST="10.10.43.96 10.10.43.97 10.10.43.248 10.10.43.124 "
   TARGET_LIST="10.10.43.27 10.10.43.28 10.10.43.81 10.10.43.96 10.10.43.97 10.10.43.248 10.10.43.157 10.10.43.208 10.10.43.124 "
   TIER4_LIST=$TARGET_LIST
else
   TARGET_LIST="10.0.0.8 10.0.0.9 10.0.0.10 10.0.0.11 10.0.0.22 10.0.0.27"
fi

#TARGET_LIST="10.10.44.236 10.10.44.237" 
#TARGET_LIST=$GWYLIST

####################################
# Bottom Up List
####################################

TARGET_LIST_BOTTOM_UP="$TAGAXXX_LIST_ACTIVE $TIER1_LIST $TIER2_LIST $TIER3_LIST $TAGAXXX_LIST_HOSTS $TIER4_LIST"

####################################
# Other Lists and Derivative Lists
####################################

GWYLIST="10.10.41.233 10.10.41.234 10.10.44.223 10.10.44.224 10.10.54.223 10.10.54.224 10.10.44.232 10.10.54.232 10.10.1.2 22.209.44.86" 

TAGALIST="10.10.41.221 10.10.44.233"
TAGALIST=$TARGET_LIST
TAGASOURCE="10.10.44.221"

##########################
# TAGAXXX HOST TARGET MAP
##########################
# TAGAXXXMAP: 10.10.1.2 10.10.44.232 10.10.54.232
# TAGAXXXMAP: 10.10.3.2 10.10.44.237 
# TAGAXXXMAP: 10.10.5.2 
# TAGAXXXMAP: 22.209.44.86 10.10.44.232 10.10.54.232
# TAGAXXXMAP: 22.209.44.74 10.10.44.237 
# TAGAXXXMAP: 22.209.44.90 


###################################################
# output the TARGET LIST
###################################################
echo $TARGET_LIST 

