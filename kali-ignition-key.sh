#!/bin/bash

# Credit to John Hammond for base script and colors

# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`

FTPSCRIPT='IyEvYmluL2Jhc2gKCgpHUkVFTj1gdHB1dCBib2xkICYmIHRwdXQgc2V0YWYgMmAKZnVuY3Rpb24gR1JFRU4oKXsKCWVjaG8gLWUgIiR7R1JFRU59JHsxfWB0cHV0IHNncjBgIgp9CgpHUkVFTiAiWytdIFN0YXJ0aW5nIHVwIEZUUCBzZXJ2ZXIuIENyZWRzIGFyZSBhbm9uOmFub24sIHBvcnQgMjEiCkdSRUVOICJbK10gTmF2aWdhdGUgdG8gfi8ubG9jYWwvYmluL2Z0cHNlcnZlciB0byBjaGFuZ2UgYW55IHNldHRpbmdzIgoKcHl0aG9uMyAtbSBweWZ0cGRsaWIgLS11c2VybmFtZSBhbm9uIC0tcGFzc3dvcmQgYW5vbiAtcCAyMSAtdwoKZWNobyAtZSAiYHRwdXQgYm9sZCAmJiB0cHV0IHNldGFmIDFgWyFdIFNodXR0aW5nIGRvd24uLi5gdHB1dCBzZ3IwYCIK'

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

distro=$(uname -a | grep -i -c "kali") # distro check
if [ $distro -ne 1 ]
then 
	RED "[!] Kali Linux Not Detected - This script will not work with anything other than Kali!" && echo
	exit
fi

BLUE "[*] Pimping my kali..."
wget https://raw.githubusercontent.com/Dewalt-arch/pimpmykali/master/pimpmykali.sh
chmod +x pimpmykali.sh
sed 's/--all) fix_all/--all) fix_all; fix_upgrade/'
sudo ./pimpmykali.sh --all
sed 's/--all) fix_all; fix_upgrade/--all) fix_all/'

BLUE "[*] Installing virtualenv..."
sudo apt install -y virtualenv

BLUE "[*] Installing mingw-w64..."
sudo apt install -y mingw-w64

BLUE "[*] Installing terminator..."
sudo apt install -y terminator

BLUE "[*] Getting enum4linux-ng..."
git clone https://github.com/cddmp/enum4linux-ng.git /opt/enum4linux-ng

BLUE "[*] Installing rustscan..."
sudo apt install -y rustscan

BLUE "[*] Installing gdb..."
sudo apt install -y gdb

BLUE "[*] Installing seclists..."
sudo apt install -y seclists

BLUE "[*] Installing pwndbg..."
git clone https://github.com/pwndbg/pwndbg /opt/pwndbg
cd /opt/pwndbg
./setup.sh
cd -

BLUE "[*] Installing AutoRecon..."
git clone https://github.com/Tib3rius/AutoRecon.git /opt/AutoRecon
cd /opt/AutoRecon
virtualenv env -p $(which python3)
source env/bin/activate
pip install -r requirements.txt
deactivate

BLUE "[*] Installing pwntools..."
sudo -u kali pip install -U pwntools

BLUE "[*] Setting up ftpserver macro..."
echo $FTPSCRIPT | base64 -d > /home/kali/.local/bin/ftpserver
chmod +x /home/kali/.local/bin/ftpserver

BLUE "[*] Installing codium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo apt install codium -y

BLUE "[*] Installing docker..."
sudo apt-get install ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

BLUE "[*] Installing sliver..."
curl https://sliver.sh/install | sudo bash

GREEN "[++] All done! Happy hacking!"