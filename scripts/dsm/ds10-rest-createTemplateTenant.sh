#!/bin/bash
## rest-createTemplateTenant <user> <pass> <fqdn> <port>

username=$1
password=$2
dsmurl="$3:$4"
tenantName=templateTenant
tenantAdminPassword=This1sNotMyP@ssword

#echo -e "#####Login to DSM at ${dsmurl}\n"
tempDSSID=$(curl -ks -H "Content-Type: application/json" -X POST "https://${dsmurl}/rest/authentication/login/primary" -d '{"dsCredentials":{"userName":"'${username}'","password":"'${password}'"}}') >/dev/null
#echo -e "\n#### SID:"
#echo $tempDSSID

#echo -e "\n####Create tenant ${tenantName}\n"
createTenantResponse=$(curl -ks -H "Content-Type: application/xml" -X POST "https://${dsmurl}/rest/tenants" -d \
'<createTenantRequest>
  <createOptions>
    <adminAccount>MasterAdmin</adminAccount>
    <adminPassword>'${tenantAdminPassword}'</adminPassword>
    <adminEmail>MasterAdmin@ctf.labs.local</adminEmail>
  </createOptions>
  <tenantElement>
    <name>'${tenantName}'</name>
    <language>en</language>
    <country>US</country>
    <timeZone>US/Eastern"</timeZone>
  </tenantElement>
  <sessionId>'${tempDSSID}'</sessionId>
</createTenantRequest>')

#echo -e "\nCreateResponse:\n${createTenantResponse}\n"

tenantId=$(echo $createTenantResponse | xml_grep --text_only tenantID)


curl -k -X DELETE https://${dsmurl}/rest/authentication/logout?sID=$tempDSSID > /dev/null

unset tempDSSID
unset username
unset password

echo ${tenantId}