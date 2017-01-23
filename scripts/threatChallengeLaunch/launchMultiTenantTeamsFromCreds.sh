#!/bin/bash


dsmT0Admin='t0Admin'
dsmConsolePort='443'
dsStackname="sharedDsStack"

dsmT0Password=$(cat ../../variables/t0AdminPassword)
eventName=$(cat ../../variables/eventName)
keyPair=threatChallengeKeyPair
activationCode=$(cat ../../variables/featureAC)
mtActivationCode=$(cat ../../variables/multiTenantAC)
vpc=$(cat ../../variables/vpcid)
dsmSubnet=$(cat ../../variables/dsmSubnet)
dbSubnet1=$(cat ../../variables/dbSubnet1)
dbSubnet2=$(cat ../../variables/dbSubnet2)



dsmFqdn="dsm.${eventName}.trenddemos.com"


logfile=launchMultiLog

echo "Launch MT DSM" >> ${logfile} 2>&1
./launchMtDSM.sh "${dsmT0Password}" ${activationCode} ${keyPair} ${vpc} ${dsmSubnet} ${dbSubnet1} ${dbSubnet2} ${dsStackName}
echo "Running configMtDsm.sh" >> ${logfile} 2>&1
configMtDsm.sh "${dsmT0Password}" ${mtActivationCode} ${dsmFqdn} ${dsStackName}
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
    nohup ./launchTeamSko2017mt.sh ${dsmT0Admin} "${dsmT0Password}" ${dsmFqdn} ${dsmConsolePort} ${creds[0]} ${creds[1]} &
    sleep 150
done < "${filename}"
echo "Removing creds file" >> ${logfile} 2>&1
rm "${filename}"