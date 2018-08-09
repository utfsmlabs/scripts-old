#!/bin/bash
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "usar $0 pcs"
	exit 0
fi
carpetas="/localhome /usr /var /tmp"
json="json_espacio_discos.json"

echo "{" > $json

for pc in $(grep -v '^#' $1)
do
	echo $pc
	echo "\"$pc\": {" >> $json
		let cont=1
		for carpeta in $(ssh root@$pc "du -s $carpetas" | awk {'print $1'})
		do
			size[$cont]=$carpeta
			let cont=$cont+1
		done
		echo "\"/localhome\" : \"${size[1]}\"," >> $json
		echo "\"/usr\" : \"${size[2]}\"," >> $json
		echo "\"/var\" : \"${size[3]}\"," >> $json
		echo "\"/tmp\" : \"${size[4]}\"" >> $json
	echo "}," >> $json
done

echo "\"final\": \"finalizado\"" >> $json
echo "}" >> $json
