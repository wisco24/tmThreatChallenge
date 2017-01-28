#!/bin/bash
dnsname=${1}
ctrlDnsName=${2}


aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "Z54BUX0B2EC7C",
  "ChangeBatch" :{
    "Comment": "Delete CNAME for DSM to ctrl",
    "Changes": [
      {
        "Action": "DELETE",
        "ResourceRecordSet": {
          "Name": "'${dnsname}'.",
          "Type": "CNAME",
          "AliasTarget": {
            "HostedZoneId": "Z54BUX0B2EC7C",
            "DNSName": "'${ctrlDnsName}'.",
            "EvaluateTargetHealth": false
          } 
        }
      }
    ]
  }
}'
