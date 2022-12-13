#!/bin/bash
# Program:
#	0	 BK TCP Server
./fairness_udt0.sh
sleep 50
./fairness_udt3.sh
sleep 50
./fairness_udt5.sh
sleep 50
./fairness_tcp5.sh
sleep 100
./fairness_udt10.sh
sleep 50
./fairness_tcp10.sh
