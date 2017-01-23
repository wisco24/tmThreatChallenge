#!/bin/bash
# rest-multiTenantConfigurationEnable.sh dsmuser dsmpass dsmfqdn guiPort activationcode
username=${1}
password=${2}
dsmurl=${3}:${4}
activationCode=${5}
configurationType=ENTERPRISE
licenseModeType=PRIMARY_TENANT_INHERITANCE

tempDSSID=$(curl -ks -H "Content-Type: application/json" -X POST "https://${dsmurl}/rest/authentication/login/primary" -d '{"dsCredentials":{"userName":"'${username}'","password":"'${password}'"}}')

curl -ks -H "Content-Type: application/json" "Accept: application/json" -X PUT "https://${dsmurl}/rest/multitenantconfiguration" -d '{"updateMultiTenantConfigurationRequest":{"multiTenantConfigurationElement": {"activationCode": "'${activationCode}'","configurationType": "'${configurationType}'","licenseModeType": "'${licenseModeType}'"},"sessionId": "'${tempDSSID}'"}}'

curl -ks -X DELETE https://${dsmurl}/rest/authentication/logout?sID=$tempDSSID > /dev/null


unset tempDSSID
unset username
unset password


