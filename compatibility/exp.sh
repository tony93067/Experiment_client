#!/bin/bash
# Program:
#	0	 BK TCP Server
./compatibility_udt0.sh
sleep 50
./compatibility_tcp0.sh
sleep 100
./compatibility_udt3.sh
sleep 50
./compatibility_tcp2.sh
sleep 100
./compatibility_udt5.sh
sleep 50
./compatibility_tcp5.sh
sleep 100
./compatibility_udt10.sh
sleep 50
./compatibility_tcp10.sh
