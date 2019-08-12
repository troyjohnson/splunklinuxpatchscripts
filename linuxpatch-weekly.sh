#! /bin/bash

# linuxpatch-weekly.sh

# Throw into /etc/cron.weekly/ directory

# constants
LSBRELEASE=/usr/bin/lsb_release
YUM=/usr/bin/yum
APTITUDE=/usr/bin/aptitude
AWK=/usr/bin/awk
LOGGER=/usr/bin/logger
UNAME=/bin/uname
SLEEP=/bin/sleep

# variables
TAG=LP
PRIORITY=local0.info
LSBI=`$LSBRELEASE -s -i`
LSBR=`$LSBRELEASE -s -r`
LSBC=`$LSBRELEASE -s -c`
UNMS=`$UNAME -s`
UNMM=`$UNAME -m`
UNMP=`$UNAME -p`
UNMI=`$UNAME -i`
UNMR=`$UNAME -r`
UNMV=`$UNAME -v`
export LOGCMD="$LOGGER -p $PRIORITY -t $TAG"

#begin
# move to daily script
# LSB information
#$LOGCMD "LSB lsbdistributor=\"$LSBI\" lsbrelease=\"$LSBR\" lsbcodename=\"$LSBC\""
#$SLEEP 1

# move to daily script
# uname information
#$LOGCMD "UNM unmkname=\"$UNMS\" unmmachine=\"$UNMM\" unmprocessor=\"$UNMP\" unmhardware=\"$UNMI\" unmkrelease=\"$UNMR\" unmkversion=\"$UNMV\""
#$SLEEP 1

# a different set of command for each distribution
# Ubuntu
if [ $LSBI == "Ubuntu" ]; then

	$APTITUDE search -F '%p %35V' ~i | $AWK '/./ { cmd = ENVIRON["LOGCMD"] ; printf "PKG pkgname=\"%s\" pkgversion=\"%s\" pkgstate=\"installed\"\n", $1, $2 | cmd ; close(cmd) }'

# CentOS
elif [ $LSBI == "CentOS" ]; then

	$YUM -q list installed 2>&1 | $AWK '/./ { cmd = ENVIRON["LOGCMD"] ; printf "PKG pkgname=\"%s\" pkgversion=\"%s\" pkgstate=\"installed\"\n", $1, $2 | cmd ; close(cmd) }'

# Fedora
elif [ $LSBI == "Fedora" ]; then

	$YUM -q list installed 2>&1 | $AWK '/./ { cmd = ENVIRON["LOGCMD"] ; printf "PKG pkgname=\"%s\" pkgversion=\"%s\" pkgstate=\"installed\"\n", $1, $2 | cmd ; close(cmd) }'

fi

# end

