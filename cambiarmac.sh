j=1
for i in $(cat $1) 
do
    echo $i
    newmac=$(echo $((0x0800279680FD + $j)) | awk '{printf "0%x\n",$1}')
    echo $newmac
    #ssh root@$i "sed -i -e 's/0800279680FD/$newmac/' /etc/VirtualBox/Machines/tsc/tsc.vbox"
    newmac=$(echo $((0x08002744687C + $j)) | awk '{printf "0%x\n",$1}')
    echo $newmac
    #ssh root@$i "sed -i -e 's/08002744687C/$newmac/' /etc/VirtualBox/Machines/tsc-2/tsc-2.vbox"
    j=$j+1
done
