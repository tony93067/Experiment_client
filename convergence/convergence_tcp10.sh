#!/bin/bash
# Program:
#	0	 BK TCP Server
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
TCP_PATH=/home/tony/實驗code/論文code/實驗一/TCP/client/memcpy/test_tcp
TCP_PATH1=/home/tony/other_experiment/convergence/TCP1/client/memcpy/test_tcp
TCP_PATH2=/home/tony/other_experiment/convergence/TCP2/client/memcpy/test_tcp
Method=("cubic" "bbr")
BK=10
export PATH
for me in ${Method[@]}
do
	cd $TCP_PATH
	./downlink_run10.sh
	ps
	cd $TCP_PATH1
	./client 140.117.171.182 $BK $me &
	cd $TCP_PATH2
	./client 140.117.171.182 $BK $me
	killall -9 background_client_downlink
	sleep 40
	killall -9 client
	ps
done
	

