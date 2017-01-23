#!/bin/bash

mtActivationCode=${1}

## setup dsm route53 address
workshopName=$(<./orchestration/DsmWorkshopName)

if [ -z ${workshopName} ]; then
  exit 1
fi

#echo "Setting Route53 dsm.trenddemos.com Alias target to new DSM"
./orchestration/setDsmRoute53.sh ${workshopName}

echo -e "\nSleeping 5 minutes for DNS propogation\n"
sleep 300

## enable MT
./dsm/rest-multiTenantConfigurationEnable.sh MasterAdmin noVirus0! dsm.trenddemos.com 443 ${mtActivationCode}

echo -e "\nSleeping 5 minutes - check that the license key stuck in DSM\n"
sleep 300

## create template tenant
templateTenantId=$(./dsm/rest-createTemplateTenant.sh MasterAdmin noVirus0! dsm.trenddemos.com 443)

## customize template tenant
./dsm/customize-templateTenant.sh MasterAdmin noVirus0! dsm.trenddemos.com 443

## set template tenant as template
./dsm/rest-tenantTemplateCreate.sh MasterAdmin noVirus0! dsm.trenddemos.com 443 ${templateTenantId}

