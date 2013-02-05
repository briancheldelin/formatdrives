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

	# Remove each partition on sdb
	for v_partition in $(parted -s /dev/sdb print|awk '/^ / {print $1}')
	do
	   parted -s /dev/sdb rm ${v_partition}
	done

	# Remove each partition on sdc
	for v_partition in $(parted -s /dev/sdc print|awk '/^ / {print $1}')
	do
	   parted -s /dev/sdc rm ${v_partition}
	done

	# Remove each partition on sdd
	for v_partition in $(parted -s /dev/sdd print|awk '/^ / {print $1}')
	do
	   parted -s /dev/sdd rm ${v_partition}
	done

	# Remove each partition on sde
	for v_partition in $(parted -s /dev/sde print|awk '/^ / {print $1}')
	do
	   parted -s /dev/sde rm ${v_partition}
	done

	# Find size of disk and Create single partion
	v_disk=$(parted -s /dev/sdb print|awk '/^Disk/ {print $3}'|sed 's/[Mm][Bb]//')
	parted -s /dev/sdb mkpart primary 0 ${v_disk}
	
	# Find size of disk and Create single partion
	v_disk=$(parted -s /dev/sdc print|awk '/^Disk/ {print $3}'|sed 's/[Mm][Bb]//')
	parted -s /dev/sdc mkpart primary 0 ${v_disk}
	
	# Find size of disk and Create single partion
	v_disk=$(parted -s /dev/sdd print|awk '/^Disk/ {print $3}'|sed 's/[Mm][Bb]//')
	parted -s /dev/sdd mkpart primary 0 ${v_disk}

	# Find size of disk and Create single partion
	v_disk=$(parted -s /dev/sde print|awk '/^Disk/ {print $3}'|sed 's/[Mm][Bb]//')
	parted -s /dev/sde mkpart primary 0 ${v_disk}
	
	# Format the partition
	mkntfs -L "Default" /dev/sdb1 &
	mkntfs -L "Default" /dev/sdc1 &
	mkntfs -L "Default" /dev/sdd1 &
	mkntfs -L "Default" /dev/sde1 &
	wait
	
	echo "All Drives Formated!"
done
