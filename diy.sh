#!/bin/bash

CLASH_CORE_PATH=package/luci-app-openclash/files/etc/openclash/core

# Modify default IP.
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

wget https://github.com/vernesong/OpenClash/archive/master.zip
unzip master.zip
cp -r OpenClash-master/luci-app-openclash package/

mkdir -p ${CLASH_CORE_PATH}
# core
wget https://github.com/vernesong/OpenClash/releases/download/Clash/clash-linux-amd64.tar.gz -O - \
    |  tar zxvf - -C ${CLASH_CORE_PATH}
# tun
TUN_VERSION=$(curl -sL --connect-timeout 10 --retry 2 \
    https://raw.githubusercontent.com/vernesong/OpenClash/master/core_version -o - | sed -n '2p')
wget https://github.com/vernesong/OpenClash/releases/download/TUN-Premium/clash-linux-amd64-${TUN_VERSION}.gz \
    -O - | gzip -d - --stdout > ${CLASH_CORE_PATH}/clash_tun
# game
wget https://github.com/vernesong/OpenClash/releases/download/TUN/clash-linux-amd64.tar.gz \
    -O - | tar zxvf - -O > ${CLASH_CORE_PATH}/clash_game
chmod a+x ${CLASH_CORE_PATH}/clash*

./scripts/feeds update -a
./scripts/feeds install -a
