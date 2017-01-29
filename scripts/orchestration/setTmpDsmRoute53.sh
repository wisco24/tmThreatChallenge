#!/bin/bash
dnsname=${1}
ctrlDnsName=${2}
baseDomainHostedZoneId=${3}

aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "'${baseDomainHostedZoneId}'",
  "ChangeBatch" :{
    "Comment": "update DSM CNAME to ctrl for cert create",
    "Changes": [
      {
        "Action": "UPSERT", 
        "ResourceRecordSet": {
          "Name": "'${dnsname}'.",
          "Type": "CNAME",
          "AliasTarget": {
            "HostedZoneId": "'${baseDomainHostedZoneId}'",
            "DNSName": "'${ctrlDnsName}'.",
            "EvaluateTargetHealth": false
          } 
        }
      }
    ]
  }
}'
