#!/bin/bash
eval "clear"

if find /mnt/userhome/ -maxdepth 0 -empty | read v; then

	echo "Instrucciones:"
	echo "Primero te preguntará tu usuario de laboratorio, ejemplo: benjamin.fantini"
	echo "Luego te preguntará la contraseña con la que te conectas a estos, luego de la conexión podrá ver tu carpeta personal en el escritorio con el nombre de \"Mi Carpeta\""
	echo ""

	echo "Por favor ingresa tu usuario de laboratorio:"
	read user

#	eval "mkdir /Volumes/MountNoMeCambiesNiPorsiacaso"
	eval "sshfs ${user}@ssh:/home/${user} /mnt/userhome -o auto_cache"

	echo "Si por alguna razón no funciona la conexión, habla con los administradores del laboratorio (primos)"
	echo "Puedes cerrar esta ventana"

else

	echo "Ya existe alguna carpeta montada"

fi

