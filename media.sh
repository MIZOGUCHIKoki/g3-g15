#!/bin/bash

USERNAME=$(whoami)
        
if [ $USERNAME = "250373b" ]; then
	echo -e "\e[31m MIZOGUCHI on WS-Linux \e[m"
	make
  cp program.img ~/tsclient/boot/kernel7.img
	make clean
elif [ $USERNAME = "250372y" ]; then
	echo -e "\e[31m MIKAMI on WS-Linux \e[m"
	make
  cp program.img /media/$USERNAME/boot/kernel7.img
	make clean
elif [ $USERNAME = "250341z" ]; then
	echo -e "\e[31m TANAKA on WS-Linux \e[m"
	make
  cp program.img /media/$USERNAME/boot/kernel7.img
	make clean
elif [ $USERNAME = "250382g" ]; then
	echo -e "\e[31m YAMADA on WS-Linux \e[m"
	make
  cp program.img /media/$USERNAME/boot/kernel7.img
	make clean
elif [ $USERNAME = "koki" ]; then
	echo -e "MIZOGUCHI on Mac"
  docker cp ubuntu:/root/git/PL2_Group15/program.img ~/Documents/
  mv ~/Documents/program.img ~/Documents/kernel7.img
  mv ~/Documents/kernel7.img /Volumes/boot/
  diskutil unmount boot
fi
