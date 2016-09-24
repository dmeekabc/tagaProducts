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

#######################################################################
# Automatic Network Identification and TAGA related configuration:
#######################################################################
# If we match a specific string, then use network accordingly,
# otherwise, use the default
#######################################################################

NETADDR_STRING_TO_MATCH="10\\.0\\.0"

if /sbin/ifconfig | grep $NETADDR_STRING_TO_MATCH >/dev/null; then
  # use alternate
  let TAGA_TL_CONTEXT=1 # alternate
else
  # use default
  let TAGA_TL_CONTEXT=0 # default
fi


###################################################
# set the net address part 
###################################################

# set the NETWORK ADDRESS PART 
# Note: First 3 Nibbles,this assumes 24-bit or higher netmask
if [ $TAGA_TL_CONTEXT -eq 0 ]; then
   # default
   NETADDRPART=192.168.43
else
   # alternate
   NETADDRPART=10.0.0
fi

###################################################
# set the ALTERNATE net address parts  
# Note: All nodes in the TAGA scope (networks of interest)
# must match the network address part above or an alternate below
###################################################
NETADDRPART_ALT1=192.168.11
NETADDRPART_ALT2=192.168.12
NETADDRPART_ALT3=192.168.13
NETADDRPART_ALT4=192.168.14
NETADDRPART_ALT5=192.168.15
NETADDRPART_ALT6=192.168.16
NETADDRPART_ALT7=192.168.17
NETADDRPART_ALT8=192.168.18
NETADDRPART_ALT9=192.168.19
NETADDRPART_ALT10=192.168.20
NETADDRPART_ALT11=192.168.30
NETADDRPART_ALT12=192.168.30
NETADDRPART_ALT13=192.168.50
NETADDRPART_ALT14=192.168.60
NETADDRPART_ALT15=192.168.70
NETADDRPART_ALT16=192.168.80
NETADDRPART_ALT17=192.168.90
NETADDRPART_ALT18=192.168.100
NETADDRPART_ALT19=192.168.110
NETADDRPART_ALT20=192.168.120
NETADDRPART_ALT21=192.168.130
NETADDRPART_ALT22=192.168.140
NETADDRPART_ALT23=192.168.150
NETADDRPART_ALT24=192.168.160
NETADDRPART_ALT25=192.168.170

###################################################
# define the TARGET LIST
###################################################

if [ $TAGA_TL_CONTEXT -eq 0 ]; then
   # default
   TARGET_LIST="192.168.43.124 192.168.43.146 192.168.43.147 192.168.43.157 192.168.43.208"
else
   # alternate
   TARGET_LIST="10.0.0.20 10.0.0.22 10.0.0.27"
fi


###################################################
# output the TARGET LIST
###################################################
echo $TARGET_LIST 

