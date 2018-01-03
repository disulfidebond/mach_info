#!/bin/sh

getMacOSXinfo() {
  SWVERS_CHECK=$(which sw_vers)
  if [ -z "$SWVERS_CHECK" ] ; then
    SWVERS_OUTPUT=$(defaults read loginwindow SystemVersionStampAsString)
    echo "Computer is MacOSX running $SWVERS_OUTPUT"
   else
    echo 'Error attempting to find OS version.  Computer is running MacOSX, additional information is as follows:'
    UNAMEOUTPUT=$(uname -a)
    echo "$UNAMEOUTPUT"
}

getLinuxOSinfo() {
  OS_VERSION_CHECK=$(lsb_release -d)
  if [ -z "$OS_VERSION_CHECK" ] ; then
    OS_VERSION_ID=$(lsb_release -d | cut -d$'\t' -f2 | cut -d\  -f1)
    if [[ "$OS_VERSION_ID" = "Ubuntu" ]] ; then
      OS_VERSION_ID_FULL=$(lsb_release -d | cut -d$'\t' -f2)
      echo "Computer is running Ubuntu Linux ${OS_VERSION_ID_FULL}"
    else 
      OS_VERSION_ID_FULL=$(lsb_release -d | cut -d$'\t' -f2 | cut -d\  -f1-)
      echo "Computer is running ${OS_VERSION_ID_FULL}"
    fi
  else
    OSINFO_AVAIL=$(cat /etc/*release)
    echo 'Unable to retrieve information on Linux OS.  Available information is as follows:'
    echo "$OSINFO_AVAIL"
}

getUnknownOSinfo() {
  echo 'attempting to find unknown OS info'
  MAC_SWVERS_CHECK=$(which sw_vers)
  GENERIC_VERS_CHECK=$(ls / | grep proc)
  GENERIC_VERS_CHECK2=$(ls / | grep private)
  UNAMEOUTPUT=$(uname -a)
  if [ -z "$MAC_SWVERS_CHECK" ] ; then
    echo 'OS appears to be running MacOSX, but this may be incorrect.  Additional information is as follows:'
    echo "$UNAMEOUTPUT"
  elif [ -z "$GENERIC_VERS_CHECK" ] ; then
    echo 'OS appears to be running Linux, but this may be incorrect.  Additional information is as follows:'
    echo "$UNAMEOUTPUT"
  elif [ -z "$GENERIC_VERS_CHECK2" ] ; then 
    echo 'OS may be running MacOSX, but the information is conflicting.  Additional information is as follows:'
    echo "$UNAMEOUTPUT"
  else:
    echo 'Unknown OS.  Additional information is as follows:'
    echo "$UNAMEOUTPUT"
}

GCCDETECT=$(uname -r)
let OSTYPE=0
if [[ "$GCCDETECT" = "Linux" ]] ; then
  let OSTYPE=1
elif [[ "$GCCDETECT" = "Darwin" ]] ; then
  let OSTYPE=2
else
  echo 'OS type unknown.  One or more of the following has occurred:'
  echo ''
  echo '* gcc or LLVM compiler has not been installed'
  echo '* compiler $PATH has not been setup correctly'
  echo '* Kourne, Z, or other non-bash shell is being used'
  echo '* OS is neither Linux nor Mac OSX.'
  echo ''
  echo '* Script will proceed in 5 seconds, type Ctrl-C to stop.'
  sleep 5
  let OSTYPE=2
fi

case $OSTYPE in
  1) getLinuxOSinfo
  ;;
  2) getMacOSXinfo
  ;;
  3) getUnknownOSinfo
  ;;
  *) echo 'Unknown error occurred, exiting...'
  ;;
esac


