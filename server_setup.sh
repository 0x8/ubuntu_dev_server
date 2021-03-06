#!/bin/bash

# Author: Ian Guibas
# Ubuntu Server setup script (18.04) for setting up an ultra-light
# development and testing environment. This setup will utilize the
# i3-gaps window manager, lightdm desktop manager, the oh-my-zsh
# shell environment, as well as a few other lightweight goodies.
#
# This script is written under the assumption that the server in
# question is hosted via VMWare Workstation, VMWare Fusion, etc. 
# and not on bare-metal. This should still work just fine on bare
# metal but the virtual machine components are then unnecessary.

# Prepare to install software
sudo apt update
sudo apt upgrade -fy

# Ensure vim and python requirements are met
sudo apt install -fy vim open-vm-tools tmux python python-dev python3 \
python3-dev python-pip python3-pip

# Get gcc requirements
sudo apt install -fy gcc gcc-multilib 

# Get desktop environment requirements
sudo apt install -fy lightdm xinit dmenu lightdm-gtk-greeter i3 feh \
compton

# More general software
sudo apt install -fy zsh firefox rxvt-unicode ruby-full build-essential \
libgtk2.0-0

# i3-gaps requirements
# From https://github.com/airblader/i3/wiki/compiling-&-installing
# from under "16.10+" in the Ubuntu section
sudo apt install -fy libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libxcb-cursor-dev \
libstartup-notification0-dev libxcb-randr0-dev libev-dev automake \
libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev autoconf \
libxkbcommon-x11-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0-dev

# Installation of i3-gaps
HERE="$(dirname $(readlink -e $0))"
git clone https://github.com/airblader/i3 .i3-gaps
cd .i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build
cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd $HERE

# Set i3 as the default session of lightdm by editing
# /etc/lightdm/lightdm.conf: user-session=i3
#sudo sed -i "s/user-session=\w*/user-session=i3/g" \
#/etc/lightdm/lightdm.conf
echo "[Seat:*]" | sudo tee -a /etc/lightdm/lightdm.conf.d/lightdm.conf
echo "user-session=i3" | sudo tee -a /etc/lightdm/lightdm.conf.d/lightdm.conf

# Ensure lightdm is enabled in systemctl
sudo systemctl enable lightdm.service

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Powerline fonts
git clone https://github.com/powerline/fonts ~/.fonts
cd ~/.fonts
./install.sh

# Vim pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Powerline
sudo pip3 install powerline-status

# Dotfiles
if [ -d "$HOME/.nptr_dotfiles" ]
then
    echo "Moving existing .nptr_dotfiles directory to .old_nptr_dotfiles."
    echo "If you no longer need the directory, you should manually remove it once this script finishes"
    mv "$HOME/.nptr_dotfiles" "$HOME/.old_nptr_dotfiles"
fi
git clone https://github.com/0x8/nptr_dotfiles --branch ubuntu_server --single-branch ~/.nptr_dotfiles 
cd ~/.nptr_dotfiles
sudo ./install.sh

# Clean up
# Remove i3-gaps source dir
rm -r $HERE/.i3-gaps

# End of Script, reboot machine
reboot
