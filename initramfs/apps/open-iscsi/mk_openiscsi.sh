#!/bin/bash

if [ ! -f open-iscsi-2.0-871.tar.gz ] ; then
	wget http://www.open-iscsi.org/bits/open-iscsi-2.0-871.tar.gz
fi
#
#
tar -xzf open-iscsi-2.0-871.tar.gz
cp iscsi_settings.h open-iscsi-2.0-871/usr/iscsi_settings.h
cd open-iscsi-2.0-871
#
#
make user

cp -f usr/iscsistart ../build
#
cd ..
rm -rf open-iscsi-2.0-871

