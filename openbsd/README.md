# OpenBSD

Pointers for building a box for a new OpenBSD version.

# VirtualBox

Used to build `amd64` boxes.

1. Verify the checksum of the new ISO [with signify]
1. Update the template file
    1. Update the version
    1. Update the checksum

[with signify]: https://www.openbsd.org/faq/faq4.html#Download

# VMware Fusion

Used to build `arm64` boxes.

1. Download miniroot image: `curl -LO https://cdn.openbsd.org/pub/OpenBSD/7.9/arm64/miniroot79.img`
1. Download SHA256: `curl -LO https://cdn.openbsd.org/pub/OpenBSD/7.9/arm64/SHA256.sig`
1. Download OpenBSD Base: `curl -LO https://cdn.openbsd.org/pub/OpenBSD/7.9/openbsd-79-base.pub`
1. Verify the checksum of the miniroot image [with signify] `signify -Cp /etc/signify/openbsd-79-base.pub -x SHA256.sig miniroot79.img`
1. Convert miniroot image to VMware disk: `qemu-img convert -f raw -O vmdk miniroot79.img vmware-vmx/miniroot.vmdk`
1. Adjust box config to match current version
    - Change major and/or minor version in `template.json` and `vmware-vmx.pkr.hcl`
    - Change `iso_checksum` to the one in SHA256 (miniroot79.img) in `template.json`
1. Validate box config: `packer validate vmware-vmx.pkr.hcl`
1. Build the box: `packer build vmware-vmx.pkr.hcl`
