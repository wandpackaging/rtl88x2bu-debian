#!/bin/bash

set -x -e -o pipefail

# disable all platforms
sed -i 's/\(CONFIG_PLATFORM_[A-Z0-9_]*\) = y/\1 = n/' rtl88x2bu/Makefile

# enable the one we want to build for
if [ `dpkg --print-architecture` = "armhf" ]; then
    if [ `lsb_release -i -s` = "Raspbian" ]; then
        sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/' rtl88x2bu/Makefile
    else
        echo "Non raspberry pi ARM architectures not currently supported"
        exit 1
    fi
else
    sed -i 's/CONFIG_PLATFORM_I386_PC = n/CONFIG_PLATFORM_I386_PC = y/' rtl88x2bu/Makefile
fi

mk-build-deps -i -r -t 'apt-get -f -y --force-yes'
dpkg-buildpackage -b -us -uc -rfakeroot
