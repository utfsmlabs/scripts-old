#!/bin/bash
pico=1
picoLargo="="
picoLargA=" "
cont=1
cont2=1
suma=1
while [ $pico -eq 1 ];
do
	clear
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	if [ $picoLargo = "==========" ]; then
		echo "BBBBB                                                    EEE                                       -   *            -"
		echo "BBBBBBB                                                   EEEEE"
		echo "BBBBBBBBB                                                  EEEEEEE "
		echo "BBBBBBBBB                                                      EEEEEEEEE"
		echo "BBBBBBBBB                                                      EEEEEEEEEEE           *"
		echo "BBBBBBBB==========X======X====                              ===EEEEEEEEEEEEEE                       --   *"
		echo "BBBBBB=======X================                              ===EEEEEEEEEEEE  -            -  -"
		echo "BBBB==X==================X====------------XXxxxXxxX---------===EEEEEEE      -            - "
		echo "BBB==============X============---XXXxxxXx-------------------===EEE             *                 -   - - -"
		echo "BBB=======X===================---------------------X-XXxxX--===EEE                             -  - -"
		echo "BBBB=================X========                              ===EEEEEEE         *-  *"
		echo "BBBBBB==========X=============                              ===EEEEEEEEEEEE"
		echo "BBBBBBBB================X=====                              ===EEEEEEEEEEEEEE   *"
		echo "BBBBBBBBB                                                      EEEEEEEEEEE"
		echo "BBBBBBBBB                                                      EEEEEEEEE"
		echo "BBBBBBBBB                                                  EEEEEEE"
		echo "BBBBBBB                                                   EEEEE                                         - * - "
		echo "BBBBB                                                    EEE                                                                *"
		sleep 0.6
	else	
		echo "BBBBB                                             $picoLargA   DDD"
		echo "BBBBBBB                                           $picoLargA   DDDDD"
		echo "BBBBBBBBB                                         $picoLargA   DDDDDDD"
		echo "BBBBBBBBB                                         $picoLargA   DDDDDDDDD"
		echo "BBBBBBBBB                                         $picoLargA   DDDDDDDDDDD"
		echo "BBBBBBBB==========================================$picoLargo===DDDDDDDDDDDD"
		echo "BBBBBB============================================$picoLargo===DDDDDDDDDDDDD"
		echo "BBBB==============================================$picoLargo===DDDDDDDDDDDDD"
		echo "BBB===============================================$picoLargo===DDDDDDDDDDDDD"
		echo "BBB===============================================$picoLargo===DDDDDDDDDDDDD"
		echo "BBBB==============================================$picoLargo===DDDDDDDDDDDDD"
		echo "BBBBBB============================================$picoLargo===DDDDDDDDDDDDD"
		echo "BBBBBBBB==========================================$picoLargo===DDDDDDDDDDDD"
		echo "BBBBBBBBB                                         $picoLargA   DDDDDDDDDDD"
		echo "BBBBBBBBB                                         $picoLargA   DDDDDDDDD"
		echo "BBBBBBBBB                                         $picoLargA   DDDDDDD"
		echo "BBBBBBB                                           $picoLargA   DDDDD"
		echo "BBBBB                                             $picoLargA   DDD"

	fi
	picoLargo="$picoLargo="
	picoLargA="$picoLargA "
	if [ $picoLargo = "===========" ]; then
		picoLargo="="
		picoLargA=" "
	fi
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	sleep 0.1
done
