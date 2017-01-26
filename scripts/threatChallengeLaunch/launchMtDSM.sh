## aws cloudformation create-stack --stack-name mystackname --template-url https://s3.amazonaws.com/cf-deepsecurity/master/DSM95RH.template --paramters ParameterKey=Parm1, ParameterValue=test1, ParameterKey=Parm2, ParameterValue=test2
#!/bin/bash

dsmT0Password=${1}
activationCode=${2}
keyPair=${3}
vpc=${4}
dsmSubnet=${5}
dbSubnet1=${6}
dbSubnet2=${7}
stackname=${8}






aws cloudformation create-stack --disable-rollback \
--stack-name ${stackname} \
--output text \
--capabilities CAPABILITY_IAM \
--template-url "https://s3.amazonaws.com/trend-micro-quick-start/v-sko/RHEL/MasterRH96.template" \
--parameters \
ParameterKey=AWSIKeyPairName,ParameterValue=${keyPair} \
ParameterKey=AWSIVPC,ParameterValue=${vpc} \
ParameterKey=DBICAdminName,ParameterValue=t0Admin \
ParameterKey=DBICAdminPassword,ParameterValue=${dsmT0Password} \
ParameterKey=DBIRDSInstanceSize,ParameterValue=db.m4.xlarge \
ParameterKey=DBIStorageAllocation,ParameterValue=200 \
ParameterKey=DBISubnet1,ParameterValue=${dbSubnet1} \
ParameterKey=DBISubnet2,ParameterValue=${dbSubnet2} \
ParameterKey=DBPBackupDays,ParameterValue=1 \
ParameterKey=DBPCreateDbInstance,ParameterValue=Yes \
ParameterKey=DBPEngine,ParameterValue=Oracle \
ParameterKey=DBPName,ParameterValue=dsm \
ParameterKey=DSCAdminName,ParameterValue=t0Admin \
ParameterKey=DSCAdminPassword,ParameterValue=${dsmT0Password} \
ParameterKey=DSIMultiNode,ParameterValue=2 \
ParameterKey=DSIPGUIPort,ParameterValue=443 \
ParameterKey=DSIPHeartbeatPort,ParameterValue=4120 \
ParameterKey=DSIPInstanceType,ParameterValue=m4.xlarge \
ParameterKey=DSIPLicenseKey,ParameterValue=${activationCode} \
ParameterKey=DSISubnetID,ParameterValue=${dsmSubnet} \
ParameterKey=DBPMultiAZ,ParameterValue=true \
ParameterKey=CfnUrlPrefix,ParameterValue="https://s3.amazonaws.com/trend-micro-quick-start/v-sko/" \
--tags \
Key=CtfRole,Value=SharedServices
