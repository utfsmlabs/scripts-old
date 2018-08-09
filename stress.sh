#!/bin/bash
pcs=$(cat pcs-lpa )
users=$(cat logins)
j=1;
for i in $pcs
do
	#for j in $pcs
	#do
		echo $i $users[$j]
		ssh root@$i "su - $users[$j] -c exit" & 
	#done
	j=$[j+1]
	sleep 1;
done
