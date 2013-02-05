#!/bin/bash

while :

do
	echo "Press [CTRL+C] to stop..."
	read -p "Press [Enter] to turn off drives"
	echo 1 > /sys/class/scsi_host/host0/device/target0\:0\:1/0\:0\:1\:0/delete
	echo 1 > /sys/class/scsi_host/host1/device/target1\:0\:0/1\:0\:0\:0/delete
	echo 1 > /sys/class/scsi_host/host2/device/target2\:0\:0/2\:0\:0\:0/delete
	echo 1 > /sys/class/scsi_host/host3/device/target3\:0\:0/3\:0\:0\:0/delete
	sleep 5

	read -p "Disconnect and connect new drives. Then press Enter"
	echo "- - -" > /sys/class/scsi_host/host0/scan
	echo "- - -" > /sys/class/scsi_host/host1/scan
	echo "- - -" > /sys/class/scsi_host/host2/scan
	echo "- - -" > /sys/class/scsi_host/host3/scan
	sleep 2
	
	mkntfs -L "Default" /dev/sdb1 &
	mkntfs -L "Default" /dev/sdc1 &
	mkntfs -L "Default" /dev/sdd1 &
	mkntfs -L "Default" /dev/sde1 &
	wait
	
	echo "All Drives Formated!"
done
