#!/bin/bash

cd /home/ubuntu/
apt-get update
apt-get -y install git
git clone https://github.com/wisco24/fbctf.git fbctf
chown -R ubuntu:ubuntu fbctf
cd fbctf
export HOME=/root
./extra/provision.sh -m dev -s $PWD