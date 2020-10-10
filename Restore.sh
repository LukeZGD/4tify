#!/bin/bash
#  Script.sh
#  Created by Zane Kleinberg on 4/18/20.

echo "4tify-Linux"
echo "2. Restore"
IPSWCustom="iPhone3,1_7.1.2_11D257_Custom.ipsw"

cd support_restore
iproxy 2222 22 &
iproxyPID=$!
echo "Copying stuff to device via SSH..."
echo "* Make sure OpenSSH is installed on the device!"
echo "* Enter root password of your iOS device when prompted, default is 'alpine'"
[ $? == 1 ] && echo -e "Cannot connect to device via SSH. Please check your ~/.ssh/known_hosts file and try again\nYou may also run: rm ~/.ssh/known_hosts" && exit
scp -P 2222 kloader pwnediBSS root@127.0.0.1:/
ssh -p 2222 root@127.0.0.1 "/kloader /pwnediBSS"
echo "* Press POWER or HOME button when screen goes black on the device"
echo "Finding device in DFU mode..."
while [[ $DFUDevice != 1 ]]; do
    DFUDevice=$(lsusb | grep -c '1227')
    sleep 1
done
echo "Found device in DFU mode."
kill $iproxyPID
sudo ./idevicerestore -e -y $IPSWCustom
echo "Done!"
