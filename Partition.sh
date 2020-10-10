#!/bin/bash
echo "4tify-Linux"
echo "3. Partition"

cd support_files/4.3/File_System
ssh -p 2222 root@127.0.0.1 "TwistedMind2 -d1 3221225472 -s2 879124480 -d2 max"
sleep 2
echo "Fetching Patch File..."
srcdirs=$(ssh -p 2222 root@127.0.0.1 "ls /*TwistedMind2*")
echo "$srcdirs"
expect "
spawn scp -P 2222 -o StrictHostKeyChecking=no root@127.0.0.1:$srcdirs .
expect \"root@127.0.0.1's password:\"
send \"alpine\r\"
expect eof"
echo "Done!"
