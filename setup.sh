#!/usr/bin/env bash 

# Confirm root/sudo user
if [[ $EUID -ne 0 ]]; then
  echo "Requires root privileges."
  exit 1
fi


# Back up dconf; append timestamp in case multiple backups exists
timestamp=$(date +%Y%m%d_%H%M%S)
echo "Backing up configuration to ~/.dconf-backup_$timestamp.conf"
echo " This can be reverted with dconf load / <" 
dconf dump / > "$HOME/.dconf-backup_$timestamp.conf"


####
#### GSETTINGS - GNOME
####

# Make sure to run asuser.sh seperately

# Privacy settings
echo "Changing privacy settings"
gsettings set org.gnome.system.location enabled "false"
gsettings set org.gnome.software review-server ""
gsettings set org.gnome.desktop.privacy disable-camera "true"
gsettings set org.gnome.desktop.privacy disable-microphone "true"
gsettings set org.gnome.desktop.privacy disable-sound-output "true"
gsettings set org.gnome.desktop.privacy hide-identity "true"
gsettings set org.gnome.desktop.privacy old-files-age "7"
gsettings set org.gnome.desktop.privacy recent-files-max-age "3"
gsettings set org.gnome.desktop.privacy remember-app-usage "false"
gsettings set org.gnome.desktop.privacy remember-recent-files "false"
gsettings set org.gnome.desktop.privacy remove-old-temp-files "true"
gsettings set org.gnome.desktop.privacy remove-old-trash-files "true"
gsettings set org.gnome.desktop.privacy report-technical-problems "false"
gsettings set org.gnome.desktop.privacy send-software-usage-stats "false"
gsettings set org.gnome.desktop.privacy show-full-name-in-top-bar "false"

echo "Changing performance settings"
gsettings set org.gnome.desktop.interface enable-animations "false"
gsettings set org.gnome.desktop.interface scaling-factor "2"
gsettings set org.gnome.desktop.interface font-hinting 'full' 
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Quality of life 
echo "Changing quality-of-life settings"
gsettings set org.gnome.desktop.interface enable-hot-corners "false"
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-seconds "true"
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll "true"
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll "true"


####
#### PACKAGES - DNF
####


# Update
sudo dnf update

# This is a KVM/QEMU guest in UTM on MacOS host
sudo dnf -y install spice-vdagent qemu-guest-agent qemu-kvm-device-display-virtio-gpu qemu-kvm-device-display-virtio-gpu-pci cifs-utils

# Expanded package access
crb enable
dnf install epel-release
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-"$(rpm -E %rhel)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-"$(rpm -E %rhel)".noarch.rpm

# Basic stuff
sudo dnf -y install python3 python3-pip git curl wget policycoreutils-python-utils python3-virtualenv unzip

# Media work
dnf install -y ffmpeg ghostscript imagemagick perl-Image-ExifTool

# Network utilities
dnf install -y nmap tcpdump mtr wireshark


####
#### PACKAGES - FLATPAK
####


# Flatpaks I'll use a lot
flatpak remote-add -y --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak update
flatpak install com.vscodium.codium org.mozilla.firefox org.chromium.Chromium org.videolan.VLC com.github.hluk.copyq -y

# # Dependencies for the Atoms flatpak
# flatpak install org.gnome.Platform org.gnome.Sdk org.gnome.Platform.Compat.i386 org.freedesktop.Platform.GL32.default org.flatpak.Builder -y

# # Get fonts https://fonts.google.com/download?family=Source+Code+Pro
# # Another dependencies
# mkdir /usr/share/fonts/google-source-code-pro/
# unzip GoogleSourceCodePro.zip -d /usr/share/fonts/google-source-code-pro/
# fc-cache

# # build atoms
# flatpak run org.flatpak.Builder build pm.mirko.Atoms.yml --user --install --force-clean
# flatpak run pm.mirko.Atoms

# # permission to talk to org.freedesktop.Flatpak
# flatpak run pm.mirko.Atoms --talk-name=org.freedesktop.Flatpak


####
#### SECURITY
####


# Get rid of uncessary firewall rules
firewall-cmd --remove-service=cockpit --permanent
firewall-cmd --remove-service=dhcpv6-client --permanent
firewall-cmd --remove-service=ssh --permanent
firewall-cmd --reload

systemctl disable cockpit.service
systemctl disable cockpit.socket
systemctl stop cockpit.service
systemctl stop cockpit.socket

systemctl stop sshd.service
systemctl disable sshd.service


echo "Ensuring NTP is enabled for time synchronization..."
sudo systemctl enable --now chronyd

sudo dnf clean all
