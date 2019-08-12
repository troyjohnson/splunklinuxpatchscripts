#! /bin/bash

# linuxpatch-daily.sh

# Throw into /etc/cron.daily/ directory

# constants
LSBRELEASE=/usr/bin/lsb_release
LOGGER=/usr/bin/logger
YUM=/usr/bin/yum
APTITUDE=/usr/bin/aptitude
WC=/usr/bin/wc
AWK=/usr/bin/awk
EXPR=/usr/bin/expr
UTPROC=/proc/uptime
SLEEP=/bin/sleep
UNAME=/bin/uname

# variables
TAG=LP
PRIORITY=local0.info
SECSPERDAY=86400
LSBI=`$LSBRELEASE -s -i`
LSBR=`$LSBRELEASE -s -r`
LSBC=`$LSBRELEASE -s -c`
UNMS=`$UNAME -s`
UNMM=`$UNAME -m`
UNMP=`$UNAME -p`
UNMI=`$UNAME -i`
UNMR=`$UNAME -r`
UNMV=`$UNAME -v`
UTSECS=`$AWK -F. '{print $1}' $UTPROC`
UTDAYS=`$EXPR $UTSECS / $SECSPERDAY`
export LOGCMD="$LOGGER -p $PRIORITY -t $TAG"

# begin
# LSB information
$LOGCMD "LSB lsbdistributor=\"$LSBI\" lsbrelease=\"$LSBR\" lsbcodename=\"$LSBC\""
$SLEEP 1

# uname information
$LOGCMD "UNM unmkname=\"$UNMS\" unmmachine=\"$UNMM\" unmprocessor=\"$UNMP\" unmhardware=\"$UNMI\" unmkrelease=\"$UNMR\" unmkversion=\"$UNMV\""
$SLEEP 1

# uptime log
$LOGCMD "UPT uptdays=\"${UTDAYS}\""
$SLEEP 1

# do different tasks for different flavors of Linux
# Ubuntu Linux
if [ $LSBI == "Ubuntu" ]; then

	# update local package lists
#	$APTITUDE update > /dev/null
	# package update log
	$APTITUDE search -F '%p %35V' ~U | $AWK '/./ { cmd = ENVIRON["LOGCMD"] ; printf "PKG pkgname=\"%s\" pkgversion=\"%s\" pkgstate=\"update\"\n", $1, $2 | cmd ; close(cmd) }'

# CentOS Linux
elif [ $LSBI == "CentOS" ]; then

	# package update log
	$YUM -q check-update 2>&1 | $AWK '/./ { cmd = ENVIRON["LOGCMD"] ; printf "PKG pkgname=\"%s\" pkgversion=\"%s\" pkgstate=\"update\"\n", $1, $2 | cmd ; close(cmd) }'

# Fedora Linux
elif [ $LSBI == "Fedora" ]; then

	# package update log
	$YUM -q check-update 2>&1 | $AWK '/./ { cmd = ENVIRON["LOGCMD"] ; printf "PKG pkgname=\"%s\" pkgversion=\"%s\" pkgstate=\"update\"\n", $1, $2 | cmd ; close(cmd) }'

fi
# end

