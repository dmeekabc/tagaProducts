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

TAGA_DIR=~/scripts/taga
TAGA_CONFIG_DIR=$TAGA_DIR/tagaConfig
source $TAGA_CONFIG_DIR/config

start=`date -Ins`; sleep 0.50 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.50 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.50 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.50 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 502 msec on average (implies ~2 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.10 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.10 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.10 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.10 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 102 msec on average (implies ~2 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.0010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 2.6 msec on average (implies ~1.6 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.00010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.00010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.00010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.00010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 1.6 or 1.7 msec on average (implies ~1.6 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.0000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 1.6 msec on average (implies ~1.6 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.0000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.0000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 1.6 msec on average (implies ~1.6 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 1.6 msec on average (implies ~1.6 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`; sleep 0.00000000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.00000000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.00000000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`; sleep 0.00000000000000010 ; end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 1.6 msec on average (implies ~1.6 msec for sleep cmd and date cmd overhead context switch)

start=`date -Ins`;                      end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`;                      end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`;                      end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`;                      end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

#exit  # 900 usec on average (implies 900 msec to invoke the date cmd and implies 700 usec for sleep cmd context switch?)

start=`date -Ins`;  echo 12345;                    end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`;  echo 12345;                    end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`;  echo 12345;                    end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end
start=`date -Ins`;  echo 12345;                    end=`date -Ins`; echo $start $end; ./timeDeltaCalc.sh $start $end

exit  # 900 usec on average (implies 900 msec to invoke the date cmd and implies negligible usec for echo -cmd context?)
