#!/bin/bash
# Program:
#	0	 BK TCP Server
./fairness_tcp5.sh
sleep 100
echo "TCP 5"
./fairness_tcp10.sh
sleep 100
echo "TCP 10 end"
./fairness_udt3.sh
sleep 100
echo "UDT 3 end"
./fairness_udt5.sh
sleep 100
echo "UDT 5 end"
./fairness_udt10.sh
echo "UDT 10 end"
