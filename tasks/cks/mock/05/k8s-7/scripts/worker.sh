#!/bin/bash
echo " *** worker node mock-5  k8s-7"

# Install Falco
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | \
tee -a /etc/apt/sources.list.d/falcosecurity.list

apt-get install apt-transport-https -y
apt-get update -y
apt install -y dkms make linux-headers-$(uname -r) clang llvm dialog

FALCO_FRONTEND=noninteractive FALCO_DRIVER_CHOICE=kmod apt-get install -y falco=0.40.0
systemctl stop falco

# Install sysdig
curl -fsSL https://download.sysdig.com/DRAIOS-GPG-KEY.public | gpg --dearmor -o /usr/share/keyrings/draios.gpg
echo 'deb [signed-by=/usr/share/keyrings/draios.gpg] https://download.sysdig.com/stable/deb stable-$(ARCH)/' > /etc/apt/sources.list.d/draios.list
apt-get update -y
apt-get install -y sysdig
