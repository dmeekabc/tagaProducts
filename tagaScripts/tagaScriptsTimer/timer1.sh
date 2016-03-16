#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

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
