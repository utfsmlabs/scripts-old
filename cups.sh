#!/bin/bash
./COPiaR_de_APU_a_PeCes.sh pcs-lpa ../printers.conf /etc/cups
./COPiaR_de_APU_a_PeCes.sh pcs-lpa ../printer.ppd /etc/cups/ppd
./COPiaR_de_APU_a_PeCes.sh pcs-lds ../printers.conf /etc/cups
./COPiaR_de_APU_a_PeCes.sh pcs-lds ../printer.ppd /etc/cups/ppd
