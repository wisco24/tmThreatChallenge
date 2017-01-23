#!/bin/bash

cd /home/ubuntu/
apt-get update
apt-get install git
git clone https://github.com/wisco24/fbctf.git fbctf
cd fbctf
./extra/provision.sh -m dev -s $PWD