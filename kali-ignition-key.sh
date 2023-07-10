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

distro=$(uname -a | grep -i -c "kali") # distro check
if [ $distro -ne 1 ]
then 
	RED "[!] Kali Linux Not Detected - This script will not work with anything other than Kali!" && echo
	exit
fi

BLUE "[*] Pimping my kali..."
git clone https://github.com/Dewalt-arch/pimpmykali.git /home/kali/pimpmykali
cd /home/kali/pimpmykali
sudo ./pimpmykali.sh --all
cd -

BLUE "[*] Installing virtualenv..."
sudo apt install -y virtualenv

BLUE "[*] Installing pipx..."
sudo apt install -y pipx

BLUE "[*] Installing pyftpdlib..."
sudo -u kali pip3 install -U pyftpdlib 
#sudo apt install python3-pyftpdlib

BLUE "[*] Installing xclip..."
sudo apt install -y xclip

BLUE "[*] Installing mingw-w64..."
sudo apt install -y mingw-w64

BLUE "[*] Installing tmux (and terminator as a fallback)..."
sudo apt install -y tmux terminator

BLUE "[*] Installing alacritty..."
wget https://github.com/barnumbirr/alacritty-debian/releases/download/v0.11.0-1/alacritty_0.11.0-1_amd64_bullseye.deb
sudo dpkg -i alacritty_0.11.0-1_amd64_bullseye.deb
sudo apt install -f

BLUE "[*] Getting enum4linux-ng..."
git clone https://github.com/cddmp/enum4linux-ng.git /opt/enum4linux-ng

BLUE "[*] Installing rustscan..."
sudo apt install -y rustscan

BLUE "[*] Installing ffuf..."
sudo apt install -y ffuf

BLUE "[*] Installing up..."
git clone https://github.com/An00bRektn/up-http-tool.git /opt/up-http-tool
chown -R kali:kali /opt/up-http-tool
sudo -u kali python3 -m pip install waitress
cp /opt/up-http-tool/up /home/kali/.local/bin/up

BLUE "[*] Installing feroxbuster..."
sudo apt install -y feroxbuster

BLUE "[*] Installing Bloodhound and CrackMapExec..."
sudo apt install -y bloodhound
sudo apt install -y neo4j
#sudo -u kali pipx install -U bloodhound
sudo -u kali python3 -m pip install -U bloodhound
sudo -u kali pipx install git+https://github.com/mpgn/CrackMapExec

BLUE "[*] Installing seclists..."
sudo apt install -y seclists

BLUE "[*] Installing gdb..."
sudo apt install -y gdb

BLUE "[*] Installing pwndbg..."
git clone https://github.com/pwndbg/pwndbg /opt/pwndbg
chown -R kali:kali /opt/pwndbg
cd /opt/pwndbg
./setup.sh
cd -

BLUE "[*] Installing gef..."
mkdir -p /opt/gef; chown kali:kali /opt/gef
wget -O /opt/gef/.gdbinit-gef.py -q https://gef.blah.cat/py
echo source ~/.gdbinit-gef.py >> ~/.gdbinit-gef

BLUE "[*] Installing ghidra..."
sudo apt install -y ghidra

BLUE "[*] Installing pwntools and other binary exploitation tools..."
#sudo apt install python3-pwntools
#sudo -u kali pipx install -U ropper
sudo -u kali python3 -m pip install -U pwntools
sudo gem install one_gadget seccomp-tools

BLUE "[*] Installing codium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo apt install codium -y

BLUE "[*] Installing docker..."
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo usermod -aG docker kali

BLUE "[*] Installing sliver..."
curl https://sliver.sh/install | sudo bash

BLUE "[*] Installing Nim..."
sudo -u kali curl https://nim-lang.org/choosenim/init.sh -sSf | sh
echo 'export PATH=/home/kali/.nimble/bin:$PATH' >> /home/kali/.zshrc

YELLOW "Please read!"
BLUE "   The kali default shell is zsh, which has some minor differences from how bash works."
BLUE "   If you would like to swap your default shell to bash, please type Y, otherwise, type N"
read -n1 -p "   Please type Y or N : " userinput

dotfiles(){
	BLUE "[*] Setting up dotfiles..."
	cp ./dotfiles/bash/.bash_aliases-kali /home/kali/.bash_aliases
	cp ./dotfiles/bash/.bashrc-kali /home/kali/.bashrc
	cp ./dotfiles/vim/.vimrc /home/kali/.vimrc
	chown kali:kali /home/kali/.bashrc /home/kali/.bash_aliases
	echo 'export PATH=/home/kali/.nimble/bin:$PATH' >> /home/kali/.bashrc
	source /home/kali/.bash_aliases
	source /home/kali/.bashrc
}

case $userinput in
	y|Y) BLUE "[*] Swapping to bash..."; chsh -s /bin/bash kali; dotfiles  ;;
	n|N) BLUE "[*] Sticking to zsh..." ;;
	*) RED "[!] Invalid response, keeping zsh...";;
esac

cp ./dotfiles/.tmux.conf /home/kali/.tmux.conf
mkdir -p /home/kali/.tmux/logs
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p /home/kali/.config/alacritty
cp ./dotfiles/alacritty.yml /home/kali/.config/alacritty/alacritty.yml

GREEN "[++] All done! Happy hacking! Remember to reboot and login again to see the full changes!"
BLUE  "  [*] Also remember to install the tmux plugins!"
