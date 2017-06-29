#!/bin/sh

set -e

uname_r=$(uname -r)
arch_s=$(arch -s)

export PKG_PATH
PKG_PATH="$MIRROR/pub/OpenBSD/$uname_r/packages/$arch_s/"

# set pkg path for users
echo "export PKG_PATH=\"$PKG_PATH\"" >> /root/.profile
echo "export PKG_PATH=\"$PKG_PATH\"" >> /home/vagrant/.profile

# install sudo, required by Vagrant
pkg_add sudo--

# passwordless sudo for Vagrant
echo "vagrant ALL=(ALL) NOPASSWD: SETENV: ALL" >> /etc/sudoers

# ansible support
pkg_add -z python-2

# ensure consistent resolvable hostname
hostname=$(hostname -s)
printf "%s\n" "$hostname" > /etc/myname
printf "127.0.0.1\tlocalhost %s\n" "$hostname" > /etc/hosts
printf "::1\t\tlocalhost %s\n" "$hostname" >> /etc/hosts
