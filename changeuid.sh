uuid1=$(cat /etc/VirtualBox/VirtualBox.xml|grep tsc.vbox|awk '{print substr($2,8,36)}')
uuid2=$(cat /etc/VirtualBox/Machines/tsc/tsc.vbox|grep name=\"tsc\"|awk '{print substr($2,8,36)}')
sed -i -e 's/$uuid1/$uuid2' /etc/VirtualBox/VirtualBox.xml
