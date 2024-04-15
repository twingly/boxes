#!/bin/sh

set -e

uname_r=$(uname -r)
arch_s=$(arch -s)

# install sudo, required by Vagrant
pkg_add sudo--

# passwordless sudo for Vagrant
echo "vagrant ALL=(ALL) NOPASSWD: SETENV: ALL" >> /etc/sudoers

# ansible support
pkg_add "python3"

# ensure consistent resolvable hostname
hostname=$(hostname -s)
printf "%s\n" "$hostname" > /etc/myname
printf "127.0.0.1\tlocalhost %s\n" "$hostname" > /etc/hosts
printf "::1\t\tlocalhost %s\n" "$hostname" >> /etc/hosts

# wait until relink kernel is done, as it blocks syspatch
echo "Waiting on kernel relink"
while $(pgrep -qxf '/bin/ksh .*reorder_kernel'); do sleep 1; done

# list and install available patches
syspatch -c
# handle: "syspatch: updated itself, run it again to install missing patches"
syspatch || syspatch || true
