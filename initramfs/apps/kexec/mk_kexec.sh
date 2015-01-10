#!/bin/bash

if [ ! -f kexec-tools-2.0.8.tar.gz ] ; then
	#wget http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing-20080324.tar.bz2
	wget http://kernel.org/pub/linux/utils/kernel/kexec/kexec-tools-2.0.8.tar.gz
fi
#
#
tar -xzf kexec-tools-2.0.8.tar.gz
cd kexec-tools-2.0.8
#
#
./configure --host=i686-pc-linux-gnu
make

cp -f build/sbin/kexec ../build
#
cd ..
rm -rf kexec-tools-2.0.8

