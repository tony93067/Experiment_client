#!/bin/bash
# Program:
#	0	 BK TCP Server
TCP_PATH=/home/tony/other_experiment/compatibility/TCP1/client/memcpy/test_tcp
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
LB_PATH1=/home/tony/other_experiment/compatibility/UDT1/client/udt4/src
UDT_PATH1=/home/tony/other_experiment/compatibility/UDT1/client/udt4/app
MSS=("1500" "1250" "1000" "750" "500" "250" "100")
Method=("UDT" "CTCP" "BiCTCP")
MSS1=("1500")
BK=0
export PATH
for (( c=1; c<=3; c++ ))
do
	for str in ${MSS1[@]}
	do
		cd $TCP_PATH
		./client 140.117.171.182 $BK "cubic" ${Method[$c - 1]} &
		export LD_LIBRARY_PATH=$LB_PATH1
		cd $UDT_PATH1
		./udtclient 140.117.171.182 5000 $str $c $BK
		sleep 40
		killall -9 client
		killall -9 udtclient
		ps
	done
	
done

