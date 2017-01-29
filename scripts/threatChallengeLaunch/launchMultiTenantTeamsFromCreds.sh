#!/bin/bash


dsmT0Admin='t0Admin'
dsmConsolePort='443'


dsmT0Password=$(cat /home/ec2-user/variables/t0AdminPassword)
eventName=$(cat /home/ec2-user/variables/eventName)
keyPair=$(cat /home/ec2-user/variables/sshkey)
activationCode=$(cat /home/ec2-user/variables/featureAC)
mtActivationCode=$(cat /home/ec2-user/variables/multiTenantAC)
vpc=$(cat /home/ec2-user/variables/vpcid)
dsmSubnet=$(cat /home/ec2-user/variables/dsmSubnet)
dbSubnet1=$(cat /home/ec2-user/variables/dbSubnet1)
dbSubnet2=$(cat /home/ec2-user/variables/dbSubnet2)
baseDomain=$(cat /home/ec2-user/variables/baseDomain)
baseDomainHostedZoneId=$(cat /home/ec2-user/variables/baseDomainHostedZoneId)

dsStackName="tmtcDsStack-${eventName}"

ctfFqdn="ctf.${eventName}.${baseDomain}"
ctrlFqdn="ctrl.${eventName}.${baseDomain}"
dsmFqdn="dsm.${eventName}.${baseDomain}"


logfile=launchMulti.log



echo "Launch MT DSM" >> ${logfile} 2>&1
./launchMtDSM.sh "${dsmT0Password}" ${activationCode} ${keyPair} ${vpc} ${dsmSubnet} ${dbSubnet1} ${dbSubnet2} ${dsStackName}
echo "Running configMtDsm.sh" >> ${logfile} 2>&1
./configMtDsm.sh "${dsmT0Password}" ${mtActivationCode} ${dsmFqdn} ${dsStackName} ${ctrlFqdn} ${baseDomain} ${baseDomainHostedZoneId}
echo "Sleep 60 for manager multi tenant settings"
sleep 60
echo "Getting creds from S3 and storing new file locally" >> ${logfile} 2>&1
filename=$(./getTeamsCsv.sh)
echo "Looping creds to create teams" >> ${logfile} 2>&1
while read line
do
    creds=(${line})
    teamlog=${creds[0]}.log
    echo "Launching environment for ${creds[0]}" >> ${logfile} 2>&1
    nohup ./launchTmtcTeam.sh ${dsmT0Admin} "${dsmT0Password}" ${dsmFqdn} ${dsmConsolePort} ${creds[0]} ${creds[1]} ${keyPair} ${eventName} ${baseDomain} ${baseDomainHostedZoneId} &
    sleep 150
done < "${filename}"
echo "Removing creds file" >> ${logfile} 2>&1
rm "${filename}"