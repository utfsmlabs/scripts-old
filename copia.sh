#!/bin/bash -x


while read linea
do
scp -r ~/dabd_files/ root@$linea:/localhome/dabd/
done < macs2013
