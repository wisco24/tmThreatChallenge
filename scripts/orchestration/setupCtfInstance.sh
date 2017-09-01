#!/bin/bash

dsmT0Password=$(cat /home/ubuntu/variables/t0AdminPassword)
baseDomain=$(cat /home/ubuntu/variables/baseDomain)
eventName=$(cat /home/ubuntu/variables/eventName)

chown -R ubuntu:ubuntu fbctf
cd /home/ubuntu/fbctf
export HOME=/root
chmod +x /extra/certupdate.sh
./extra/certupdate.sh admin@${baseDomain} ctf.${eventName}.${baseDomain} ${dsmT0Password}
