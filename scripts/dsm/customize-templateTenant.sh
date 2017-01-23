#!/bin/bash
## <user> <pass> <fqdn> <port> <optional tenantName>


username=$1
password=$2
dsmurl="$3:$4"
if [ -z $5 ]
  then
    tenantName="templateTenant"
  else
    tenantName=$5
fi


#echo -e "#####Login to DSM at ${dsmurl}\n"
tempDSSID=$(curl -ks -H "Content-Type: application/json" -X POST "https://${dsmurl}/rest/authentication/login/primary" -d "{"dsCredentials":{"userName":"$username","password":"$password"}}")
#echo -e "\n#### SID:"
#echo $tempDSSID


tenantDSSID=$(curl -ks -H "Content-Type: text/plain" -X GET "https://${dsmurl}/rest/authentication/signinastenant/name/${tenantName}?sID=${tempDSSID}")

#echo -e "\ntenantSID: $tenantDSSID"

##### get base policy id
## get Deep Security Manager policyId
policyid=$(curl -ks -H "Content-Type: text/xml;charset=UTF-8" -H 'SOAPAction: "securityProfileRetrieveByName"' "https://${dsmurl}/webservice/Manager" -d '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:Manager"><soapenv:Header/><soapenv:Body><urn:securityProfileRetrieveByName><urn:name>Base Policy</urn:name><urn:sID>'${tenantDSSID}'</urn:sID></urn:securityProfileRetrieveByName></soapenv:Body></soapenv:Envelope>' | xml_grep ID --text_only)

#echo -e "\npolicyid: $policyid"


##### set base policy to AIC

curl -ks -H "Content-Type: text/xml;charset=UTF-8" -H 'SOAPAction: "securityProfileSettingSet"' "https://${dsmurl}/webservice/Manager" -d \
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:Manager">'\
'<soapenv:Header/>'\
'<soapenv:Body>'\
'<urn:securityProfileSettingSet>'\
'<urn:securityProfileID>'${policyid}'</urn:securityProfileID>'\
'<urn:editableSettings>'\
'<urn:settingKey>CONFIGURATION_AGENTCOMMUNICATIONS</urn:settingKey>'\
'<urn:settingUnit>NONE</urn:settingUnit>'\
'<urn:settingValue>1</urn:settingValue>'\
'</urn:editableSettings>'\
'<urn:sID>'${tenantDSSID}'</urn:sID>'\
'</urn:securityProfileSettingSet>'\
'</soapenv:Body>'\
'</soapenv:Envelope>'


curl -k -X DELETE https://${dsmurl}/rest/authentication/logout?sID=$tenantDSSID > /dev/null

curl -k -X DELETE https://${dsmurl}/rest/authentication/logout?sID=$tempDSSID > /dev/null

unset tempDSSID
unset username
unset password

echo $tenantId