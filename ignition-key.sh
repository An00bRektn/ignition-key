#!/bin/bash

# Credit to John Hammond for base script and colors

# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`

function RED(){
	echo -e "\n${RED}${1}${NC}"
}
function GREEN(){
	echo -e "\n${GREEN}${1}${NC}"
}
function YELLOW(){
	echo -e "\n${YELLOW}${1}${NC}"
}
function BLUE(){
	echo -e "\n${BLUE}${1}${NC}"
}

# Testing if root...
if [ $EUID -ne 0 ]
then
	RED "[!] You must run this script as root!" && echo
	exit
fi

BLUE "[*] Updating repositories..."
sudo apt update

BLUE "[*] Installing git..."
sudo apt install -y git

BLUE "[*] Installing terminator..."
sudo apt install -y terminator

BLUE "[*] Installing openvpn..."
sudo apt-get install -y openvpn

BLUE "[*] Installing curl..."
sudo apt-get install -y curl

BLUE "[*] Installing Wireshark..."
sudo apt-get install -y wireshark

BLUE "[*] Installing hexedit..."
sudo apt install -y hexedit	

BLUE "[*] Installing gdb..."
sudo apt install -y gdb	

BLUE "[*] Installing pip..."
sudo apt-get install -y python-pip

BLUE "[*] Installing VS Code..."
sudo snap install code --classic

BLUE "[*] Installing docker..."
sudo apt-get install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io