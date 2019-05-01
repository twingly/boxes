# boxes

Build [Vagrant] boxes with [Packer]. Hosted [on Vagrant Cloud].

## Build a box

You need to change the working directory

    cd freebsd/

Validate

    packer validate template.json

Build

    packer build template.json

Import the box so you can test it with some existing Vagrantfile

    vagrant box add --name "test/freebsd-10.1-amd64" packer_freebsd-10.1-amd64_virtualbox.box

## Release a box

Upload the box [to Vagrant Cloud].

Tag the commit that was used to build the box that was uploaded:

    git tag freebsd-10.1-v1.0.0 007ecdb -a

This will open your `$EDITOR`, follow this example in the message:

```
FreeBSD 10.1 v1.0.0

Used to build:
  https://app.vagrantup.com/twingly/boxes/freebsd-10.1-amd64/versions/1.0.0
```

Push the tag:

    git push --tags

## Getting started

Install Packer using Homebrew:

    brew install packer

## License

Different parts of this repository uses different licenses, see the individual licenses in each subdirectory:

* [`freebsd/LICENSE`](freebsd/LICENSE)
* [`openbsd/LICENSE`](openbsd/LICENSE)

## Credits

* The FreeBSD box is based on [nickchappell/packer-templates].
* The OpenBSD box is based on [tmatilai/packer-openbsd].

[Vagrant]: https://www.vagrantup.com/
[Packer]: https://www.packer.io/
[nickchappell/packer-templates]: https://github.com/nickchappell/packer-templates
[tmatilai/packer-openbsd]: https://github.com/tmatilai/packer-openbsd
[on Vagrant Cloud]: https://app.vagrantup.com/twingly
[to Vagrant Cloud]: https://app.vagrantup.com
