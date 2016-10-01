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
# Note: This assumes 24-bit or larger netmask
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
# Note: First 3 Nibbles,this assumes 24-bit or larger netmask
if [ $TAGA_TL_CONTEXT -eq 0 ]; then
   # default
   NETADDRPART=192.168.1 # primary subnet (default)
   NETADDRPART=192.168.43 # primary subnet (default)

# Note: New for tagaMini, do not use for normal taga 
# Note: First 2 Nibbles,this assumes 16-bit or larger netmask
# Note: New for tagaMini, do not use for normal taga which requires 3 nibbles
   NETADDRPART=192.168 # primary subnet (default)

else
   # alternate
   NETADDRPART=10.0.0 # primary subnet (alternate)
fi

###################################################
# set the ALTERNATE net address parts  
# Note: All nodes in the TAGA scope (net/subnets of interest)
# must match the network address part above or an alternate below
# Note: This assumes 24-bit or larger netmask
###################################################
NETADDRPART_ALT1=192.168.41 # secondary subnet
NETADDRPART_ALT2=192.168.42 # secondary subnet

###################################################
# define the TARGET LIST
###################################################

if [ $TAGA_TL_CONTEXT -eq 0 ]; then
   # default 192.168.1.x addresses
   TARGET_LIST="192.168.1.1 192.168.1.2"
   TARGET_LIST="192.168.43.124 192.168.43.146 192.168.43.157 192.168.43.208"
else
   # alternate 10.0.0.x addresses
   TARGET_LIST="10.0.0.1 10.0.0.2"
fi


###################################################
# output the TARGET LIST
###################################################
echo $TARGET_LIST 

