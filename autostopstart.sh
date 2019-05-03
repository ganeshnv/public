#!/bin/bash

Install () {
clear
read -p "How many scripts you want to run(Ex: 1 2 3): " COUNT

common () {
read -p "Enter the username who needs to execute the script: " USER

echo -e "\e[1;33;40mCreating run as a service command \e[0m"
wget -q http://reposerver/gwmtrepo/src/CEDP/Utility/autostopstart -O /etc/init.d/appstopstart
chmod 755 /etc/init.d/appstopstart
sed -i 's/user/'${USER}'/g' /etc/init.d/appstopstart
sed -i 's|path|'${STARTPATH}'|g' /etc/init.d/appstopstart

echo -e "\e[1;33;40mEnabling auto stop & start service \e[0m"
chkconfig --add appstopstart
chkconfig appstopstart on

if ( ls /etc/rc.d/rc3.d/ | grep -q -i appstopstart ); then
ls -l /etc/rc.d/rc?.d/ | grep -i appstopstart
echo -e "\e[1;32;40mAuto stop & stop service configured successfully \e[0m"
else
echo -e "\e[1;35;40mUnable to configure auto stop & start \e[0m"
fi
}


case $COUNT in
 1)
read -p "Enter the script path: " STARTPATH
common
 ;;
 2)
read -p "Enter the 1st script path: " STARTPATH
read -p "Enter the 2st script path: " STARTPATH2
common
sed -i '/### Create/i su - '${USER}' -c "'${STARTPATH2}' start"' /etc/init.d/appstopstart
sed -i '/### Now/i su - '${USER}' -c "'${STARTPATH2}' stop"' /etc/init.d/appstopstart
 ;;
 3)
read -p "Enter the 1st script path: " STARTPATH
read -p "Enter the 2st script path: " STARTPATH2
read -p "Enter the 3st script path: " STARTPATH3
common
sed -i '/### Create/i su - '${USER}' -c "'${STARTPATH2}' start"' /etc/init.d/appstopstart
sed -i '/### Now/i su - '${USER}' -c "'${STARTPATH2}' stop"' /etc/init.d/appstopstart
sed -i '/### Create/i su - '${USER}' -c "'${STARTPATH3}' start"' /etc/init.d/appstopstart
sed -i '/### Now/i su - '${USER}' -c "'${STARTPATH3}' stop"' /etc/init.d/appstopstart
 ;;
 *)
echo -e "\e[1;31;40mUnsupported count \e[0m";;

esac
#remove downloaded script
find . -maxdepth 1 -name "autostopstart.sh*" |xargs rm -f
}

Uninstall () {
echo -e "\e[1;33;40mRemoving auto stop & start service configurations \e[0m"
chkconfig appstopstart off
chkconfig --del appstopstart
find /etc/init.d/ -maxdepth 1 -name appstopstart |xargs rm -f
#remove downloaded script
find . -maxdepth 1 -name "autostopstart.sh*" |xargs rm -f
}

case $1 in
 Install)
   Install;;
 Uninstall)
   Uninstall;;
 *)
 echo "Usage: $0 {Install|Uninstall}"
 exit 0;;
esac
