#!/bin/bash
hname=$(hostname)
cat /etc/hosts | grep $hname >> /dev/null
if [ $? -ne 0 ];then
 sudo bash -c "echo '127.0.0.1 $hname' >> /etc/hosts"
fi
netfile=$(find /etc/network/interfaces.d -name "*.cfg")
for interface in $(ls -1 /sys/class/net | grep ens | egrep -v ens3) ;do
  cat $netfile | grep $interface >> /dev/null
  if [ $? -ne 0 ];then
    sudo bash -c "echo 'auto $interface' >> ${netfile}"
    sudo bash -c "echo 'iface $interface inet dhcp' >> ${netfile}"
    sudo ifup $interface
  fi
done
