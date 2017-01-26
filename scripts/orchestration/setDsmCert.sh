#!/bin/bash
stackname=${1}
certid=${2}


elbname=$(aws cloudformation describe-stacks --stack-name ${stackname} --query 'Stacks[].[Outputs[?OutputKey==`PublicELBDNSName`].OutputValue[]]' --output text)
shortname=${elbname%-*-*-*}

aws elb set-load-balancer-listener-ssl-certificate --load-balancer-name ${shortname} --load-balancer-port 443 --ssl-certificate-id ${certid}