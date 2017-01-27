#!/bin/bash

dnsname=${1}
ctrlPublicHostName=$(curl http://169.254.169.254/latest/meta-data/public-hostname)

##todo: get keys for trenddemos or lookup parameterized hosted zone


aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "Z54BUX0B2EC7C",
  "ChangeBatch" :{
    "Comment": "update DSM for hybrid cloud workshop ctf", 
    "Changes": [
      {
        "Action": "UPSERT", 
        "ResourceRecordSet": {
          "Name": "'${dnsname}'.",
          "Type": "CNAME",
          "ResourceRecords" : [
            { "Value": "'${ctrlPublicHostName}'" }
            ]
          } 
        }
      }
    ]
  }
}'