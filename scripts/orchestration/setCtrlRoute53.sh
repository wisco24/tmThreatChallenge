#!/bin/bash
dnsname=${1}
baseDomainHostedZoneId=${2}
ctrlPublicHostName=$(curl http://169.254.169.254/latest/meta-data/public-hostname)

##todo: get keys for trenddemos or lookup parameterized hosted zone


aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "'${baseDomainHostedZoneId}'",
  "ChangeBatch" :{
    "Comment": "Set ctrl fqdn",
    "Changes": [
      {
        "Action": "UPSERT", 
        "ResourceRecordSet": {
          "Name": "'${dnsname}'",
          "Type": "CNAME",
          "TTL" : 300,
          "ResourceRecords" : [
            { "Value": "'${ctrlPublicHostName}'" }
          ]
        }
      }
    ]
  }
}'
