#!/bin/bash

USERNAME=$(whoami)
        
if [ $USERNAME = "250373b" ]; then
	echo -e "\e[31m MIZOGUCHI on WS-Linux \e[m"
	make $1.img
  cp $1.img ~/tsclient/boot/kernel7.img
	make clean
elif [ $USERNAME = "250372y" ]; then
	echo -e "\e[31m MIKAMI on WS-Linux \e[m"
	make $1.img
  cp $1.img /media/$USERNAME/boot/kernel7.img
	make clean
elif [ $USERNAME = "250341zy" ]; then
	echo -e "\e[31m TANAKA on WS-Linux \e[m"
	make $1.img
  cp $1.img /media/$USERNAME/boot/kernel7.img
	make clean
elif [ $USERNAME = "250372y" ]; then
	echo -e "\e[31m 250382g on WS-Linux \e[m"
	make $1.img
  cp $1.img /media/$USERNAME/boot/kernel7.img
	make clean
elif [ $USERNAME = "koki" ]; then
	echo -e "MIZOGUCHI on Mac"
  docker cp ubuntu:/root/git/PL2_Group15/$1.img ~/Documents/
  mv ~/Documents/$1.img ~/Documents/kernel7.img
  mv ~/Documents/kernel7.img /Volumes/boot/
  diskutil unmount boot
fi
make clean
