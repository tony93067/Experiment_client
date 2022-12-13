#!/bin/bash
# Program:
#	0	 BK TCP Server
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
TCP_PATH1=/home/tony/other_experiment/compatibility/TCP1/client/memcpy/test_tcp
TCP_PATH2=/home/tony/other_experiment/compatibility/TCP2/client/memcpy/test_tcp
BK=0
export PATH
cd $TCP_PATH1
./client 140.117.171.182 0 "cubic" "bbr"&
cd $TCP_PATH2
./client 140.117.171.182 0 "bbr"
killall -9 client
	

