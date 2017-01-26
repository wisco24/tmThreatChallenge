## aws cloudformation create-stack --stack-name mystackname --template-url https://s3.amazonaws.com/cf-deepsecurity/master/DSM95RH.template --paramters ParameterKey=Parm1, ParameterValue=test1, ParameterKey=Parm2, ParameterValue=test2
## --debug --disable-rollback \
#!/bin/bash

aws cloudformation create-stack --debug --disable-rollback \
--output text \
--stack-name ${1}-SkoRoot \
--capabilities CAPABILITY_IAM \
--template-url "https://s3.amazonaws.com/trendctf/cfn/threatChallengeTeam.template" \
--parameters \
ParameterKey=TeamName,ParameterValue=${1} \
ParameterKey=DeepSecurityAdminName,ParameterValue=${2} \
ParameterKey=DeepSecurityAdminPass,ParameterValue=${3} \
--tags \
Key=TeamName,Value=${1} \
Key=CtfRole,Value=SkoTeamStack








