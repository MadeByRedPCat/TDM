#!/bin/bash
set -eo pipefail

ROOTUID="0"

if [ "$(id -u)" -ne "$ROOTUID" ] ; then
    echo "This script must be executed with root privileges."
    exit 1
fi

if ! command -v dialog > /dev/null; then
  echo "dialog is not installed, installing..." >&2
  sudo apt-get install dialog -y
fi

echo ":: Terminal Display Manager Installer"
echo ":: =================================="

if systemctl is-enabled tdm.service > /dev/null; then
  echo ":: Disabling tdm.service"
  sudo systemctl disable tdm.service
fi

echo ":: Downloading tdm"
sudo curl --location "https://raw.githubusercontent.com/MadeByRedPCat/TDM/main/tdm" \
  --output "/usr/bin/tdm" --fail
sudo chmod +x "/usr/bin/tdm"

echo ":: Installing tdm.service"
sudo curl --location "https://raw.githubusercontent.com/MadeByRedPCat/TDM/main/tdm.service" \
  --output "/etc/systemd/system/tdm.service"
sudo systemctl daemon-reload
sudo systemctl enable --now tdm.service

echo ":: Done"
