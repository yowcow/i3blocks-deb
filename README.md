i3blocks-deb
============

i3blocks deb package

HOW TO USE
----------

To create a deb package:

    make all build

To install a package:

    sudo deb -i i3blocks_1.5-1_amd64.deb

To uninstall a package:

    sudo deb -r i3blocks

DOCKER
------

To create a package within a docker container, do:

    make -f docker.mk all build

SEE ALSO
--------

+ https://github.com/vivien/i3blocks
