# boxes

Build [Vagrant] boxes with [Packer].

## Build a box

You need to change the working directory

    cd freebsd/

Validate

    packer validate template.json

Build

    packer build template.json

## Getting started

Install Packer using Homebrew:

    brew install packer

## Credits

* The FreeBSD box is based on [nickchappell/packer-templates].

[Vagrant]: https://www.vagrantup.com/
[Packer]: https://www.packer.io/
[nickchappell/packer-templates]: https://github.com/nickchappell/packer-templates
