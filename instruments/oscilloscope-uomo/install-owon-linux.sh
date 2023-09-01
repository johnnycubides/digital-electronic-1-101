#!/bin/sh -e
#						 ↑
# debug [-x -v]:[complete, abbreviated]
# Brief:	Instalación de owon en Linux
# Author: Johnny Cubides
# e-mail: jgcubidesc@unal.edu.co
# date: Thursday 31 August 2023
status=$?

APP=OWON-VDS1022
VERSION=1.1.5-cf19

wget -O "$APP-$VERSION.tar.gz" https://github.com/florentbr/OWON-VDS1022/archive/refs/tags/$APP-$VERSION.tar.gz
tar xvf $APP-$VERSION.tar.gz
cd $APP-$VERSION/ && sudo sh install-linux.sh
