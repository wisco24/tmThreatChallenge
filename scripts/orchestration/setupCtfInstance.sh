#!/bin/bash

dsmT0Password=$(cat /home/ubuntu/variables/t0AdminPassword)
baseDomain=$(cat /home/ubuntu/variables/baseDomain)
eventName=$(cat /home/ubuntu/variables/eventName)

cd /home/ubuntu/fbctf
./extra/certupdate.sh admin@${baseDomain} ctf.${eventName}.${baseDomain} ${dsmT0Password}
