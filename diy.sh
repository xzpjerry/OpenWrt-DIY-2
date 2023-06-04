#!/bin/bash

CLASH_CORE_PATH=package/luci-app-openclash/root/etc/openclash/core

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


# Backup the existing .config file
cp .config .config.bak

# Generate a fresh .config file
make defconfig

# Compare the fresh .config with the backup
diff -u .config.bak .config > config.diff

# Check if there are any differences
if [ -s config.diff ]
then
  echo "There are changes in the .config file. Updating..."
  cp .config .config.bak2  # Backup the fresh .config
  
  # Update the existing .config file
  patch -u .config.bak -i config.diff -o .config
  
  # Check if patch was successful
  if [ $? -eq 0 ]
  then
    echo "Update successful"
  else
    echo "Update failed. Restoring the backup..."
    cp .config.bak .config  # Restore the original .config
    exit 1
  fi
else
  echo "No changes in the .config file"
fi

# Clean up
rm .config.bak config.diff
if [ -f .config.bak2 ]
then
    rm .config.bak2  # Remove .config.bak2 only if it exists
fi
