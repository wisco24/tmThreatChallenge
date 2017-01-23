#!/bin/bash
stackname=${1}
dnsname='dsm.trenddemos.com'
if [[ -n {2} ]]
then
    dnsname=${2}
fi

##todo: get keys for trenddemos or lookup parameterized hosted zone

dsmurl=$(aws cloudformation describe-stacks --stack-name ${stackname} --profile ctfService --query 'Stacks[0].Outputs[?OutputKey==`DeepSecurityConsole`].OutputValue' --output text)
dsmfqdn=$(echo $dsmurl | cut -d'/' -f3 | cut -d':' -f1)
aws route53 change-resource-record-sets --profile ctfService --cli-input-json '{
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
            "DNSName": "'${dsmfqdn}'", 
            "EvaluateTargetHealth": false
          } 
        }
      }
    ]
  }
}'
