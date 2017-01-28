#!/bin/bash
dnsname=${1}

recordSetName="'"${dnsname}."'"

dsmRecordDnsName=$(aws route53 list-resource-record-sets --hosted-zone-id Z54BUX0B2EC7C --query "ResourceRecordSets[?Name == ${recordSetName} ]" | jq -r .[].AliasTarget.DNSName)
if [[ ${dsmRecordDnsName} == "" ]]
then
    exit 0
fi
hostedZoneId=$(aws route53 list-resource-record-sets --hosted-zone-id Z54BUX0B2EC7C --query "ResourceRecordSets[?Name == ${recordSetName} ]" | jq -r .[].AliasTarget.HostedZoneId)

aws route53 change-resource-record-sets --cli-input-json '{
  "HostedZoneId": "Z54BUX0B2EC7C",
  "ChangeBatch" :{
    "Comment": "Delete CNAME for DSM to ctrl",
    "Changes": [
      {
        "Action": "DELETE",
        "ResourceRecordSet": {
          "Name": "'${dnsname}'.",
          "Type": "A",
          "AliasTarget": {
            "HostedZoneId": "'${hostedZoneId}'",
            "DNSName": "'${dsmRecordDnsName}'",
            "EvaluateTargetHealth": false
          } 
        }
      }
    ]
  }
}'
