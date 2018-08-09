#!/bin/bash

screens=$(screen -ls | grep Socket | awk '{print $1}')

if [ $screens != "No" ]; then
    echo "CUIDADO pequenio primo!!!"
    echo "Hay $screens SCREEN(s) corriendo!"
    echo "si apagas los peces, alguien se pondra triste o quizas se enchuche."
    echo "Si aun tienes deseos de causar danio a la humanidad,"
    echo "ejecuta el script con el parametro --cagazo"
    if [ $# != 0 ]; then
        if [ $1 != "--cagazo" ]; then
            exit 0;
        else
            echo ""
            echo "Iniciando Autodestruccion..."
        fi
    else
        exit 0;
    fi

else
    echo "No hay SCREENs abiertas."
    echo "Apagando peces"
fi

./apagar.sh pcs/core2
./apagar.sh pcs/i5
