#!/bin/bash
#
#
#
if [ ! -f refit-src-0.14.tar.gz ] ; then
	#wget http://superb-west.dl.sourceforge.net/sourceforge/refit/refit-src-0.11.tar.gz
	wget http://downloads.sourceforge.net/project/refit/rEFIt/0.14/refit-src-0.14.tar.gz
fi
#
#
tar -xzf refit-src-0.14.tar.gz
# make just gptsync
cd refit-src-0.14/gptsync
make -f Makefile.unix

cd ../..
cp refit-src-0.14/gptsync/gptsync build/
#
rm -rf refit-src-0.14

