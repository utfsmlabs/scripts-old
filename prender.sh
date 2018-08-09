#!/bin/bash -x


while read linea
do
sudo ether-wake -i eth1 "$linea"
done < macs-lds-new
