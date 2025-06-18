#!/usr/bin/env bash

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
