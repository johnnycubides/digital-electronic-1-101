#!/bin/bash -e
#						 ↑
# debug [-x -v]:[complete, abbreviated]
# Brief:	Dar permisos al hardware
# Author: Johnny Cubides
# e-mail: jgcubidesc@unal.edu.co
# date: Thursday 22 February 2024
status=$?

echo "Agregando reglas para uso de hardware"
wget -O "99-openfpgaloader.rules" https://raw.githubusercontent.com/trabucayre/openFPGALoader/master/99-openfpgaloader.rules
sudo mv 99-openfpgaloader.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo usermod -a $USER -G plugdev

echo "Permisos para puertos seriales"
sudo usermod -a -G dialout `whoami`

