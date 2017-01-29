#!/bin/bash
bucket=${1}
filename=teamcreds
sanitizedFilename=sanitizedTeamCreds

aws s3 cp s3://${bucket}/Passwords.csv ./ > /dev/null
tail -n +2 Passwords.csv | awk -F "," '{print $1 " " $2}' > ${filename}
sed -e "s///" ${filename} > ${sanitizedFilename}
rm ${filename}
echo ${sanitizedFilename}
