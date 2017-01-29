#!/bin/bash
dnsname=${1}
ctrlDnsName=${2}
baseDomainHostedZoneId=${3}

aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "'${baseDomainHostedZoneId}'",
  "ChangeBatch" :{
    "Comment": "Delete CNAME for DSM to ctrl",
    "Changes": [
      {
        "Action": "DELETE",
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
