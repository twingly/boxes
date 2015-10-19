# boxes

Build [Vagrant] boxes with [Packer]. Hosted [on Atlas].

## Build a box

You need to change the working directory

    cd freebsd/

Validate

    packer validate template.json

Build

    packer build template.json

Upload the box [to Atlas].

## Getting started

Install Packer using Homebrew:

    brew install packer

## Credits

* The FreeBSD box is based on [nickchappell/packer-templates].

[Vagrant]: https://www.vagrantup.com/
[Packer]: https://www.packer.io/
[nickchappell/packer-templates]: https://github.com/nickchappell/packer-templates
[on Atlas]: https://atlas.hashicorp.com/twingly
[to Atlas]: https://atlas.hashicorp.com/vagrant
