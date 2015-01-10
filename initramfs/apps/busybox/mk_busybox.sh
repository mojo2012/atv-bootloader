#!/bin/bash

if [ ! -f busybox-1.23.0.tar.bz2 ] ; then
	wget http://busybox.net/downloads/busybox-1.23.0.tar.bz2
fi
#
tar -xvjf busybox-1.23.0.tar.bz2
cp busybox.config busybox-1.23.0/.config

cd busybox-1.23.0
make oldconfig
make
make install

cd ..
rm -rf build/*
cp -arp busybox-1.23.0/_install/* build/

rm -rf busybox-1.23.0

