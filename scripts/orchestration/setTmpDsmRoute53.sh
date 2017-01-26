#!/bin/bash
dnsname=${1}
ctrlDnsName=$(curl http://169.254.169.254/latest/meta-data/public-hostname)


aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "Z54BUX0B2EC7C",
  "ChangeBatch" :{
    "Comment": "update DSM for hybrid cloud workshop ctf", 
    "Changes": [
      {
        "Action": "UPSERT", 
        "ResourceRecordSet": {
          "Name": "'${dnsname}'.",
          "Type": "A", 
          "AliasTarget": {
            "HostedZoneId": "Z35SXDOTRQ7X7K", 
            "DNSName": "'${ctrlDnsName}'",
            "EvaluateTargetHealth": false
          } 
        }
      }
    ]
  }
}'
