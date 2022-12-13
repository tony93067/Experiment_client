#!/bin/bash
# Program:
#	0	 BK TCP Server
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
TCP_PATH=/home/tony/實驗code/論文code/實驗一/TCP/client/memcpy/test_tcp
LB_PATH1=/home/tony/other_experiment/fairness/UDT1/client/udt4/src
UDT_PATH1=/home/tony/other_experiment/fairness/UDT1/client/udt4/app
LB_PATH2=/home/tony/other_experiment/fairness/UDT2/client/udt4/src
UDT_PATH2=/home/tony/other_experiment/fairness/UDT2/client/udt4/app
MSS=("1500" "1250" "1000" "750" "500" "250" "100")
MSS1=("1500")
BK=5
export PATH
for (( c=1; c<=3; c++ ))
do
	for str in ${MSS1[@]}
	do
		cd $TCP_PATH
		./downlink_run5.sh
		ps
		export LD_LIBRARY_PATH=$LB_PATH1
		cd $UDT_PATH1
		./udtclient 140.117.171.182 5000 $str $c $BK &
		export LD_LIBRARY_PATH=$LB_PATH2
		cd $UDT_PATH2
		./udtclient 140.117.171.182 5050 $str $c $BK
		killall -9 background_client_downlink
		sleep 40
	done
	
done

