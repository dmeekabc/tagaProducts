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

# NETWORK CONTEXT INDICATOR
TAGA_CONTEXT=3


#######################################################################
# Automatic Network Identification and TAGA related configuration:
#######################################################################
# If we match a specific string, then use network accordingly,
# otherwise, use the default
#######################################################################

# default ................. 10.0.0
# first alternate ......... 192.168.41
# second alternate ........ 192.168.43

NETADDR_STRING_TO_MATCH="192\\.168\\.41"
NETADDR_STRING_TO_MATCH2="192\\.168\\.43"

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

# Set the HOSTS 
NORMAL_TARGET_LIST="192.168.43.40 192.168.43.41 192.168.43.146 192.168.43.147 192.168.43.124 192.168.43.208"

if [ $TAGA_TL_CONTEXT -eq 1 ]; then
   # default
   TARGET_LIST=$NORMALTARGET_LIST
   PILIST=$TARGET_LIST
elif [ $TAGA_TL_CONTEXT -eq 2 ]; then
   # alternate
   TARGET_LIST="192.168.43.40 192.168.43.41 192.168.43.146 192.168.43.147 192.168.43.124 192.168.43.208"
   PILIST="192.168.43.27 192.168.43.40 192.168.43.41 192.168.43.97 192.168.43.98 192.168.43.146 192.168.43.147"
else
   TARGET_LIST="10.0.0.8 10.0.0.9 10.0.0.10 10.0.0.11 10.0.0.22 10.0.0.27"
fi

###################################################
# output the TARGET LIST
###################################################
echo $TARGET_LIST 

