#!/bin/bash
# Program:
#	0	 BK TCP Server
BKTCP_PATH=/home/tony/實驗code/論文code/實驗一/TCP/client/memcpy/test_tcp
TCP_PATH=/home/tony/other_experiment/compatibility/TCP1/client/memcpy/test_tcp
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
LB_PATH1=/home/tony/other_experiment/compatibility/UDT1/client/udt4/src
UDT_PATH1=/home/tony/other_experiment/compatibility/UDT1/client/udt4/app
MSS=("1500" "1250" "1000" "750" "500" "250" "100")
Method=("UDT" "CTCP" "BiCTCP")
MSS1=("1500")
BK=10
export PATH
for (( c=1; c<=3; c++ ))
do
	for str in ${MSS1[@]}
	do
		cd $BKTCP_PATH
		./downlink_run10.sh
		ps
		cd $TCP_PATH
		./client 140.117.171.182 $BK "cubic" ${Method[$c - 1]} &
		export LD_LIBRARY_PATH=$LB_PATH1
		cd $UDT_PATH1
		./udtclient 140.117.171.182 5000 $str $c $BK
		killall -9 background_client_downlink
		ps
		sleep 40
		killall -9 client
		killall -9 udtclient
	done
	
done

