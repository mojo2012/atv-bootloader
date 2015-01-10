#!/bin/bash

if [ ! -f aoetools-32.tar.gz ] ; then
	wget http://downloads.sourceforge.net/project/aoetools/aoetools/32/aoetools-32.tar.gz
fi
#
#
tar -xzf aoetools-32.tar.gz
cd aoetools-32
#
#
make
chmod +x aoe-discover
chmod +x aoe-stat
chmod +x aoe-interfaces
chmod +x aoe-mkdevs
chmod +x aoe-mkshelf
cp -a aoe-discover ../build/
cp -a aoe-stat ../build/
cp -a aoe-interfaces ../build/
cp -a aoe-mkdevs ../build/
cp -a aoe-mkshelf ../build/
#
cd ..
rm -rf aoetools-32

