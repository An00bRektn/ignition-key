#!/bin/bash

# Credit to John Hammond for base script and colors
# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`
USERHOME=/home/$USER

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
sudo apt upgrade

BLUE "[*] Installing git..."
sudo apt install -y git

BLUE "[*] Installing tmux (and terminator as a fallback)..."
sudo apt install -y tmux terminator

BLUE "[*] Installing openvpn..."
sudo apt-get install -y openvpn

BLUE "[*] Installing curl and wget..."
sudo apt-get install -y curl

BLUE "[*] Installing Powershell..."
sudo apt install -y apt-transport-https software-properties-common
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell

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
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

BLUE "[*] Installing crypto tools..."
sudo -u nayr python3 -m pip install PyCryptodome gmpy2 pwntools
sudo apt install -y sagemath

BLUE "[*] Getting wallpaper..."
curl https://raw.githubusercontent.com/An00bRektn/ignition-key/main/wallpapers/kali-lincox.png -o ~/Desktop/kali-lincox.png

BLUE "[*] Setting up dotfiles..."
cp ./dotfiles/.bash_aliases-ubuntu $USERHOME/.bash_aliases
cp ./dotfiles/.bashrc-ubuntu $USERHOME/.bashrc
chown $USER:$USER $USERHOME/.bashrc $USERHOME/.bash_aliases
cp ./dotfiles/.tmux.conf $USERHOME/.tmux.conf
mkdir -p $USERHOME/.config/alacritty
cp ./dotfiles/alacritty.yml $USERHOME/.config/alacritty/alacritty.yml
source ~/.bash_aliases
source ~/.bashrc

GREEN "[++] All done! Happy developing!"
YELLOW "    \\\\--> Consider installing nim, golang, and rust, hard to automate because of version."