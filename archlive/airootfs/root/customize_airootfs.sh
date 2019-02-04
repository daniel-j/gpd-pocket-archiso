#!/bin/bash

set -e -u

# Set locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Fix wifi
ln -s brcmfmac4356-pcie.gpd-win-pocket.txt /usr/lib/firmware/brcm/brcmfmac4356-pcie.txt || true

# Set defaults for gsettings/dconf
dconf update

usermod -s /usr/bin/zsh root

chmod 755 /etc/sudoers.d
chmod 600 /etc/sudoers.d/*

! id arch && useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel,lp" -s /usr/bin/zsh arch

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service tlp.service bluetooth.service NetworkManager.service sddm.service thermald.service
systemctl set-default graphical.target

appstreamcli refresh-cache --force --verbose
