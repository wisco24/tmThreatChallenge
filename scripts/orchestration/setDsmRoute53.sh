#!/bin/bash
stackname=${1}
dnsname=${2}


##todo: get keys for trenddemos or lookup parameterized hosted zone

dsmurl=$(aws cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[0].Outputs[?OutputKey==`DeepSecurityConsole`].OutputValue' --output text)
elbfqdn=$(echo $dsmurl | cut -d'/' -f3 | cut -d':' -f1)
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
            "DNSName": "'${elbfqdn}'",
            "EvaluateTargetHealth": false
          } 
        }
      }
    ]
  }
}'
