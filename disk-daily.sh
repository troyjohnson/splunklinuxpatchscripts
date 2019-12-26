#! /bin/bash

# disk-daily.sh

# Throw into /etc/cron.daily/ directory

# constants
HOSTNAME=/bin/hostname
DF=/bin/df
LOGGER=/usr/bin/logger
AWK=/usr/bin/awk
GREP=/bin/grep
SLEEP=/bin/sleep
ECHO=/bin/echo

# variables
TAG=DISK
PRIORITY=local0.info

export LOGCMD="$LOGGER -p $PRIORITY -t $TAG"

$DF -B 1 -x tmpfs -x devtmpfs | $GREP -vE '^Filesystem|tmpfs|cdrom|udev|cgmfs|loop' | while read output ;
do
	DEVNAME=$($ECHO $output | awk '{print $1}')
	DEVSIZE=$($ECHO $output | awk '{print $2}')
	DEVUSED=$($ECHO $output | awk '{print $3}')
	DEVAVAL=$($ECHO $output | awk '{print $4}')
	DEVPUSE=$($ECHO $output | awk '{print $5}' | cut -d'%' -f1)
	DEVMNTP=$($ECHO $output | awk '{print $6}')
	
	$LOGCMD "DF devicename=\"$DEVNAME\" devicesize=\"$DEVSIZE\" spaceused=\"$DEVUSED\" spaceavailable=\"$DEVAVAL\" percentused=\"$DEVPUSE\" mountpoint=\"$DEVMNTP\""
	$SLEEP 1
done

# end

