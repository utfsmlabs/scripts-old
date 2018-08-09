#!/bin/bash

overall='SMART overall-health self-assessment test result:'
reallocated='Reallocated_Sector_Ct'
poweron='Power_On_Hours'
pending='Current_Pending_Sector'
uncorrectable='Offline_Uncorrectable'

echo $exp_grep

for pc in $(grep -v '^#' pcs/lds)
do
	echo "        "$pc
	if [ $(Core-scripts/is_prendido.sh $pc) = "si" ]; then
		ssh root@$pc "smartctl -a /dev/sda" > tmp/smartTMP
		if [ "X$(cat tmp/smartTMP)" != "X" ]; then
			response=$(grep "$overall" tmp/smartTMP)
			ro=$(awk '{split($0, r, ": "); print r[2]}' <<< $response)
			echo 'overall-healt:  '$ro
			
			response=$(grep "$reallocated" tmp/smartTMP)
			rr=$(awk '{split($0, r, " "); print r[10]}' <<< $response)
			response=$(grep "$pending" tmp/smartTMP)
			rp=$(awk '{split($0, r, " "); print r[10]}' <<< $response)
			response=$(grep "$uncorrectable" tmp/smartTMP)
			ru=$(awk '{split($0, r, " "); print r[10]}' <<< $response)
			if [ $rr != "0" ] || [ $rp != "0" ] || [ $ru != "0" ]; then
				echo $reallocated": "$rr"  !!!"
				echo $pending": "$rp"   !!!"
				echo $uncorrectable": "$ru"   !!!"
			fi
			response=$(grep "$poweron" tmp/smartTMP)
			powertime=$(awk '{split($0, r, " "); print r[10]}' <<< $response)
			echo "powertime: "$powertime
			response=$(grep 'Error .* occurred' tmp/smartTMP | head -n1)
			#echo $response
			response=$(awk '{split($0, r, ": "); print r[2]}' <<< $response)
			#echo $response
			lasterror=$(awk '{split($0, r, " "); print r[1]}' <<< $response)
			if [ "X$lasterror" != "X" ]; then
				hours=$(expr $powertime - $lasterror)
				#echo "$powertime"
				#echo "$lasterror"
				echo "Ultimo error hace $hours horas."
			fi
		fi
	fi
	echo " "
done
