#!/bin/bash
username=${1}
password=${2}
dsmurl=${3}:${4}
tenantId=${5}


## log in
tempDSSID=$(curl -ks -H "Content-Type: application/json" -X POST "https://${dsmurl}/rest/authentication/login/primary" -d '{"dsCredentials":{"userName":"'${username}'","password":"'${password}'"}}')


curl -ks -H "Content-Type: application/json" -X POST "https://${dsmurl}/rest/tenanttemplate" -d '{"createTenantTemplateRequest":{"sessionId":"'${tempDSSID}'","tenantId":"'${tenantId}'"}}'


## log out
curl -ks -X DELETE https://${dsmurl}/rest/authentication/logout?sID=$tempDSSID > /dev/null


unset tempDSSID
unset username
unset password