#!/bin/bash
IPSW7="iPhone3,1_7.1.2_11D257_Restore.ipsw"
IPSWCustom="iPhone3,1_7.1.2_11D257_Custom.ipsw"
echo "4tify-Linux"
echo "1. Create-Restore"

cd support_restore
echo "Fetching 7.1.2 blobs for: $ECID"
./tsschecker -d iPhone3,1 -i 7.1.2 -s --save-path shsh -e $ECID --boardconfig N90AP
for file in shsh/*.shsh2
do
   mv "$file" "shsh/$ECID-iPhone3,1-7.1.2.shsh"
done
if [[ ! -e $IPSW7 ]]; then
    echo "iOS 7.1.2 IPSW not found."
    echo "Downloading 7.1.2 IPSW..."
    curl -L https://secure-appldnld.apple.com/iOS7.1/031-4812.20140627.cq6y8/$IPSW7 -o $IPSW7
fi
echo "* By default, memory option is set to Y, you may select N later if you encounter problems"
echo "* If it doesn't work with both, you might not have enough RAM or tmp storage"s
read -p "Memory option? (press ENTER if unsure) (Y/n): " Memory
[[ $Memory != n ]] && [[ $Memory != N ]] && Memory="-memory" || Memory=
echo "Patching IPSW..."
./ipsw $IPSW7 $IPSWCustom $Memory # will be adading jailbreak stuff here later
./xpwntool `unzip -j $IPSWCustom 'Firmware/dfu/iBSS*' | awk '/inflating/{print $2}'` pwnediBSS
mv `unzip -j custom.ipsw 'Firmware/dfu/iBEC*' | awk '/inflating/{print $2}'` pwnediBEC
echo "Patching DeviceTree..."
cd ../support_files/7.1.2/Restore/
zip -d -qq ../../../support_restore/custom.ipsw Downgrade/DeviceTree.n90ap.img3
zip -qq ../../../support_restore/custom.ipsw Downgrade/DeviceTree.n90ap.img3
echo "Done!"
