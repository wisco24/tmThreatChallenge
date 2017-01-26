## launchTmtcTeam.sh ${teamname} ${tenantid} ${tenantpw}
## --debug --disable-rollback \
#!/bin/bash


t0User=${1}
t0Pass=${2}
dsmFqdn=${3}
dsmConsolePort=${4}
teamname=${5}
teamPassword=${6}
iamusername=${teamname}-dsmservice
logfile=${teamname}.log
keyPair=$(cat /home/ec2-user/variables/sshkey)
eventName=$(cat /home/ec2-user/variables/eventName)

echo "t0user: ${t0User}" >> ${logfile}
echo "t0Pass: ${t0Pass}" >> ${logfile}
echo "dsmFqdn: ${dsmFqdn}" >> ${logfile}
echo "dsmConsolePort: ${dsmConsolePort}" >> ${logfile}
echo "teamname: ${teamname}" >> ${logfile}
echo "teamPassword: ${teamPassword}" >> ${logfile}


echo -e "\nCreate Tenant\n"
echo "Create ${teamname} DS Tenant" >> ${logfile} 2>&1
tenantCreds=($(../dsm/ds10-rest-tenantCreate.sh ${t0User} ${t0Pass} ${dsmFqdn} ${dsmConsolePort} ${teamname} ${teamPassword}))

echo -e "\nCreate IAM stuff\n"
echo "Create IAM stuff for ${teamname}" >> ${logfile} 2>&1
aws iam create-user --user-name ${iamusername}
aws iam put-user-policy --user-name ${iamusername} --policy-name DSMUserRole --policy-document '{"Statement" : [{"Effect" : "Allow","Action" : ["ec2:DescribeInstances","ec2:DescribeImages","ec2:DescribeTags","ec2:DescribeRegions","ec2:DescribeVpcs","ec2:DescribeSubnets"],"Resource" : "*"}]}'
AWSKEYS=($(aws iam create-access-key --user-name ${iamusername} --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text))

echo "sleep to let tenant come up"
echo "Sleep 30 to give tenant ${teamname} a head start" >> ${logfile} 2>&1
sleep 30


echo -e "\nCreate Stack\n"
echo "Create ${teamname} cfn stack" >> ${logfile} 2>&1
aws cloudformation create-stack --disable-rollback \
--output text \
--stack-name ${teamname}-${eventName}-TMTC \
--capabilities CAPABILITY_IAM \
--template-url "https://s3.amazonaws.com/trendctf/cfn/threatChallengeTeam.template" \
--parameters \
ParameterKey=TeamName,ParameterValue=${teamname} \
ParameterKey=Build,ParameterValue=MT \
ParameterKey=DSTenantId,ParameterValue=${tenantCreds[1]} \
ParameterKey=DSTenantPassword,ParameterValue=${tenantCreds[0]} \
ParameterKey=DeepSecurityAdminPass,ParameterValue=${teamPassword} \
ParameterKey=TeamPassword,ParameterValue=${teamPassword} \
ParameterKey=MtDsmFqdn,ParameterValue=${dsmFqdn} \
ParameterKey=AWSIKeyPairName,ParameterValue=${keyPair} \
--tags \
Key=TeamName,Value=${teamname} \
Key=CtfRole,Value=SkoTeamStack


echo "Customize tenant" >> ${logfile} 2>&1
../dsm/ds10-customize-teamTenant.sh MasterAdmin ${teamPassword} ${dsmFqdn} ${dsmConsolePort} ${teamname} >> ${logfile} 2>&1



echo "create connector with keys"
echo "Add Cloud Connector for ${teamname}" >> ${logfile} 2>&1
../dsm/ds10-rest-cloudAccountCreateWithKeys.sh MasterAdmin ${teamPassword} ${dsmFqdn} ${dsmConsolePort} ${teamname} ${AWSKEYS[0]} ${AWSKEYS[1]} >> ${logfile} 2>&1







