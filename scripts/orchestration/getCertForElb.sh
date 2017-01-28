#!/bin/bash
dsmFqdn=${1}
curl -O https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto --debug certonly --webroot -w /usr/share/nginx/html/ -d ${dsmFqdn} --non-interactive --agree-tos --email event@trenddemos.com
sudo chown -R ec2-user:ec2-user /etc/letsencrypt
aws iam delete-server-certificate --server-certificate-name ${dsmFqdn}
uploadResponse=$(aws iam upload-server-certificate --server-certificate-name ${dsmFqdn} --certificate-body file:///etc/letsencrypt/archive/${dsmFqdn}/cert1.pem --private-key file:///etc/letsencrypt/archive/${dsmFqdn}/privkey1.pem)
arn=$(echo $uploadResponse | jq -r .ServerCertificateMetadata.Arn)
echo $arn > /home/ec2-user/variables/certArn
sudo cp /etc/letsencrypt/archive/${dsmFqdn}/fullchain1.pem /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust