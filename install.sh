#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get update
apt-get upgrade -y
touch /var/swap.img
chmod 600 /var/swap.img
dd if=/dev/zero of=/var/swap.img bs=1024k count=4000
mkswap /var/swap.img
swapon /var/swap.img
echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
apt-get -y install software-properties-common
apt-add-repository -y ppa:bitcoin/bitcoin
apt-get update
apt-get -y install wget git unzip libevent-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev libminiupnpc-dev build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libzmq3-dev nano libdb4.8-dev libdb4.8++-dev

git clone https://github.com/eastcoastcrypto/Civitas
cd Civitas
find . -name "*.sh" -exec sudo chmod 755 {} \;
chmod 755 src/leveldb/build_detect_platform
./autogen.sh
./configure --without-gui --disable-tests
make
make install
