#!/bin/bash
## createTenant <user> <pass> <fqdn> <port>

username=$1
password=$2
tenant=$5

# replace this with your DSM IP or FQDN
DSMURL="$3:$4"


echo "#####Login to DSM"
if [[ -z $tenant ]]
  then
      SID=`curl -ks -H "Content-Type: application/json" -X POST "https://${DSMURL}/rest/authentication/login/primary" -d '{"dsCredentials":{"userName":"'${username}'","password":"'${password}'"}}'`
  else
      SID=`curl -ks -H "Content-Type: application/json" -X POST "https://${DSMURL}/rest/authentication/login" -d '{"dsCredentials":{"userName":"'${username}'","password":"'${password}'","tenantName":"'${tenant}'"}}'`
fi


policyid=$(curl -ks -H "Content-Type: text/xml;charset=UTF-8" -H 'SOAPAction: "securityProfileRetrieveByName"' "https://${DSMURL}/webservice/Manager" -d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:Manager"><soapenv:Header/><soapenv:Body><urn:securityProfileRetrieveByName><urn:name>Linux Server</urn:name><urn:sID>'${SID}'</urn:sID></urn:securityProfileRetrieveByName></soapenv:Body></soapenv:Envelope>' | xml_grep ID --text_only)

curl -ks --cookie "sID=${SID}" -H "Content-Type: application/json" "Accept: application/json" -X POST "https://${DSMURL}/rest/tasks/event-based" -d \
'{"CreateEventBasedTaskRequest":
{"task":
{"actions": [{"type":"assign-policy","parameterValue":'${policyid}'}],
"conditions": [{"field":"tag","key":"Name","value":".*JMP.*|.*ATK.*"}],
"enabled": true,
"name": "ATK-JMP SKO AIA Policy Assignment",
"type": "agent-initiated-activation"} } }'

curl -k -X DELETE https://${DSMURL}/rest/authentication/logout?sID=${SID} > /dev/null

unset tempDSSID
unset username
unset password
