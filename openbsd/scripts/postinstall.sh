#!/bin/sh

set -e

uname_r=$(uname -r)
arch_s=$(arch -s)

# install sudo, required by Vagrant
pkg_add sudo--

# passwordless sudo for Vagrant
echo "vagrant ALL=(ALL) NOPASSWD: SETENV: ALL" >> /etc/sudoers

# ansible support
pkg_add -z "python%3.7"

# ensure consistent resolvable hostname
hostname=$(hostname -s)
printf "%s\n" "$hostname" > /etc/myname
printf "127.0.0.1\tlocalhost %s\n" "$hostname" > /etc/hosts
printf "::1\t\tlocalhost %s\n" "$hostname" >> /etc/hosts
