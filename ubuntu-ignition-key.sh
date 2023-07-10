#!/bin/bash

# Credit to John Hammond for base script and colors
# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`
# Call me bad at bash but it works
REGUSER=$(id -nu 1000)
USERHOME=/home/$REGUSER

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
sudo apt update -y
sudo apt upgrade -y

BLUE "[*] Installing git..."
sudo apt install -y git

BLUE "[*] Installing curl and wget..."
sudo apt-get install -y curl wget

BLUE "[*] Installing vim..."
sudo apt install -y vim-gtk3

BLUE "[*] Installing xclip..."
sudo apt install -y xclip

BLUE "[*] Installing tmux (and terminator as a fallback)..."
sudo apt install -y tmux terminator
git clone https://github.com/tmux-plugins/tpm $USERHOME/.tmux/plugins/tpm

BLUE "[*] Installing alacritty..."
wget https://github.com/barnumbirr/alacritty-debian/releases/download/v0.12.0-1/alacritty_0.12.0_amd64_bullseye.deb
sudo dpkg -i alacritty_0.12.0_amd64_bullseye.deb
sudo apt install -f

BLUE "[*] Installing openvpn..."
sudo apt-get install -y openvpn

BLUE "[*] Installing mingw-w64..."
sudo apt install -y mingw-w64

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

BLUE "[*] Installing pwndbg..."
git clone https://github.com/pwndbg/pwndbg /opt/pwndbg
chown -R $REGUSER:$REGUSER /opt/pwndbg
cd /opt/pwndbg
./setup.sh
cd -

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
sudo usermod -aG docker $REGUSER

BLUE "[*] Installing crypto tools..."
sudo -u $REGUSER python3 -m pip install PyCryptodome gmpy2 pwntools
sudo apt install -y sagemath

BLUE "[*] Installing Nim..."
sudo -u $REGUSER curl https://nim-lang.org/choosenim/init.sh -sSf | sh
echo "export PATH=/home/$REGUSER/.nimble/bin:\$PATH" >> /home/$REGUSER/.bashrc

BLUE "[*] Setting up nvm..."
sudo -u $REGUSER curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

BLUE "[*] Getting wallpaper..."
curl https://raw.githubusercontent.com/An00bRektn/ignition-key/main/wallpapers/kali-lincox.png -o ~/Desktop/kali-lincox.png
sudo apt install neofetch -y
cp ./dotfiles/toad.txt /home/$REGUSER/Public/toad.txt

BLUE "[*] Doing some fonts, theme, and icon stuff..."
mkdir -p ~/.local/share/fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
unzip RobotoMono.zip -d ~/.local/share/fonts/

mkdir -p ~/Documents/themes
git clone https://github.com/vinceliuice/Qogir-theme.git ~/Documents/themes
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
cd ~/Documents/themes/Qogir-theme
sudo ./install.sh
sudo ./install.sh --tweaks round
cd - 

mkdir -p ~/Documents/icons
git clone https://github.com/vinceliuice/Qogir-icon-theme.git ~/Documents/icons
cd ~/Documents/icons
sudo ./install.sh -d ~/.local/share/icons
cd -

BLUE "[*] Setting up dotfiles..."
cp ./dotfiles/bash/.bash_aliases-ubuntu $USERHOME/.bash_aliases
cp ./dotfiles/bash/.bashrc-ubuntu $USERHOME/.bashrc
chown $REGUSER:$REGUSER $USERHOME/.bashrc $USERHOME/.bash_aliases
cp ./dotfiles/vim/.vimrc-full $USERHOME/.vimrc
cp ./dotfiles/.tmux.conf $USERHOME/.tmux.conf
mkdir -p $USERHOME/.config/alacritty
cp ./dotfiles/alacritty.yml $USERHOME/.config/alacritty/alacritty.yml
source ~/.bash_aliases
source ~/.bashrc

GREEN "[++] All done! Happy developing!"
YELLOW "  \\\\--> Consider installing golang and rust, didn't want to automate it"
