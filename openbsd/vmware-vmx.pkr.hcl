packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

variable "boot_wait" {
  type    = string
  default = "30s"
}

variable "ftp_proxy" {
  type    = string
  default = "${env("ftp_proxy")}"
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "major_version" {
  type    = string
  default = "7"
}

variable "minor_version" {
  type    = string
  default = "1"
}

variable "arch" {
  type    = string
  default = "arm64"
}

variable "mirror" {
  type    = string
  default = "https://ftp.lysator.liu.se"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "root_ssh_password" {
  type    = string
  default = "vagrant"
}

source "vmware-vmx" "openbsd" {
  # https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/vmx#extra-disk-configuration
  # broken: https://github.com/hashicorp/packer-plugin-vmware/issues/119
  # workaround was to add the disk to miniroot.vmx by hand:
  #  sata0:0.fileName = "packer_cache/20G-1.vmdk"
  #  sata0:0.present = "TRUE"
  #  sata0:0.redo = ""
  # NOTE: "output_directory" needs to be kept in sync here and in the .vmx
  output_directory     = "packer_cache"
  disk_additional_size = [
    "20480"
  ]
  vmdk_name            = "20G"
  disk_adapter_type    = "sata"
  # https://github.com/hashicorp/packer-plugin-vmware/commit/455eb8b29bf2aca5da22309e896976b817499152
  vmx_remove_ethernet_interfaces = true
  # https://github.com/hashicorp/packer-plugin-vmware/blob/v1.0.10/example/pkrvars/debian/fusion-13.pkrvars.hcl
  vmx_data             = {
    "cpuid.coresPerSocket"    = "2"
    "ethernet0.pciSlotNumber" = "32"
    "svga.autodetect"         = true
    "usb_xhci.present"        = true
  }
  source_path          = "vmware-vmx/miniroot.vmx"
  boot_command         = [
    "S<enter>",
    "ifconfig em0 autoconf<enter>",
    "ftp -o install.conf http://{{ .HTTPIP }}:{{ .HTTPPort }}/autoinstall<enter>",
    "echo 'URL to autopartitioning template for disklabel = http://{{ .HTTPIP }}:{{ .HTTPPort }}/disklabel' >> install.conf<enter>",
    "install -af install.conf && reboot<enter>"
  ]
  http_content     = {
    "/disklabel"   = file("${path.root}/scripts/openbsd_20G.disklabel")
    "/autoinstall" = templatefile("${path.root}/scripts/autoinstall.hcl", {
      arch               = var.arch
      mirror             = var.mirror
      major_version      = var.major_version
      minor_version      = var.minor_version
      ssh_username       = var.ssh_username
      ssh_password       = var.ssh_password
      root_ssh_password  = var.root_ssh_password
    })
  }
  boot_wait            = "${var.boot_wait}"
  shutdown_command     = "/sbin/halt -p"
  ssh_username         = "root"
  ssh_password         = "${var.root_ssh_password}"
  ssh_port             = 22
  ssh_wait_timeout     = "10000s"
  vm_name              = "openbsd-${var.major_version}.${var.minor_version}-${var.arch}"
}

build {
  sources = ["source.vmware-vmx.openbsd"]

  provisioner "shell" {
    environment_vars = ["ftp_proxy=${var.ftp_proxy}", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}"]
    execute_command  = "export {{ .Vars }} && cat {{ .Path }} | su -m"
    scripts          = [
      "scripts/postinstall.sh",
      "scripts/vagrant.sh",
      "scripts/minimize.sh"
    ]
  }

  post-processor "vagrant" {
    output               = "openbsd-${var.major_version}.${var.minor_version}-${var.arch}-{{ .Provider }}.box"
    vagrantfile_template = "Vagrantfile.template"
  }
}
