#!/bin/bash


# Modify default IP.
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

wget https://github.com/vernesong/OpenClash/archive/master.zip
unzip master.zip
cp -r OpenClash-master/luci-app-openclash package/
./scripts/feeds update -a
./scripts/feeds install -a
