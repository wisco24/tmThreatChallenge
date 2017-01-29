#!/bin/bash

dsmT0Password=$(cat /home/ec2-user/variables/t0AdminPassword)
baseDomain=$(cat /home/ec2-user/variables/baseDomain)
eventName=$(cat /home/ec2-user/variables/eventName)

cd /home/ubuntu/
apt-get update
apt-get -y install git
git clone https://github.com/wisco24/fbctf.git fbctf
chown -R ubuntu:ubuntu fbctf
cd fbctf
export HOME=/root
source ./extra/lib.sh
set_password ${dsmT0Password} ctf ctf fbctf $PWD
./extra/provision.sh -m prod -c certbot -D ctf.${eventName}.${baseDomain} -e admin@${baseDomain} -s $PWD
