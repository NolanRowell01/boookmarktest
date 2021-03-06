#!/bin/bash
# shortened URL = https://goo.gl/6G2sfB
# work in progress, use at your own risk
# assumptions:
#   1.  assumes its being run as root
#   2.  only tested from kubuntu 14.04 install
#   3.
# if you are behind a webfilter and need weblogin, try w3m
#
# TODO
#  1.  test to see if kubuntu-desktop is installed, if not install it
#  2.  is there a way to see about changing network setup from server to workstation?
#
# make some directories used in script
mkdir -p /root/setup
mkdir -p /home/System/scripts
#
# update system first
apt-get update
apt-get -y install aptitude
apt-get -y upgrade
# force held-back packages
aptitude -y --full-resolver safe-upgrade
# clean up everything, drives are big, but images should be small.  :-)
apt-get -y autoremove
apt-get clean
#
# install some tools
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java7-installer mc mutt git git-doc pv
apt-get -f -y install
# download script for "unattended" updating
cd /home/System/scripts/
# CHANGE:  be sure to update to correct repository
wget https://raw.githubusercontent.com/SSCPS/TechTools-Linux/master/update_bruteforce.sh
chmod a+x /home/System/scripts/update_bruteforce.sh
#
# install DE in case needed to use Ubuntu Server CD for install
apt-get -y install lubuntu-desktop
# clean up everything, drives are big, but images should be small.  :-)
apt-get -y autoremove
apt-get clean
#
# SSCPS Branding, install boot splash  theme
#need to be after desktop because that installs its own
apt-get -y install plymouth-theme-edubuntu
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
update-alternatives --set default.plymouth /lib/plymouth/themes/edubuntu-logo/edubuntu-logo.plymouth
update-grub
update-initramfs -u
#
# remove unneeded apps and add other needed apps.
apt-get -y remove xpad mtpaint pidgin sylpheed* transmission* abiword gnumeric* audacious* xfburn
apt-get -y install lubuntu-restricted-extras wine firefox filezilla
apt-get -y install ubuntu-wallpapers kde-wallpapers kde-wallpapers-default kdewallpapers peace-wallpapers tropic-wallpapers lubuntu-artwork xubuntu-wallpapers
apt-get -y install screensaver-default-images
apt-get -y install libreoffice-calc libreoffice-impress libreoffice-writer libreoffice-draw libreoffice-gtk libreoffice-help-en-us libreoffice-pdfimport libreoffice-templates openclipart-libreoffice openclipart2-libreoffice
apt-get -y install vlc gimp marble inkscape audacity blender
apt-get -y remove flashplugin-installer
apt-get -y install flashplugin-installer
# clean up everything, drives are big, but images should be small.  :-)
apt-get -y autoremove
apt-get clean
#
# install Google Chrome
cd /root/setup
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb
apt-get -f -y install
#
# clean up everything
apt-get -y autoremove
apt-get clean
