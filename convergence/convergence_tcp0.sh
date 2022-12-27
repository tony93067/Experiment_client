#!/bin/bash
# Program:
#	0	 BK TCP Server
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
TCP_PATH1=/home/tony/other_experiment/convergence/TCP1/client/memcpy/test_tcp
TCP_PATH2=/home/tony/other_experiment/convergence/TCP2/client/memcpy/test_tcp
Method=("cubic" "bbr")
BK=0
export PATH
for me in ${Method[@]}
do
	cd $TCP_PATH1
	./client 140.117.171.182 0 $me &
	cd $TCP_PATH2
	./client 140.117.171.182 0 $me 
	sleep 40
	ps
done
	

