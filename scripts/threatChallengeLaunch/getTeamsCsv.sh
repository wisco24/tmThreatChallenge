#!/bin/bash
filename=teamcreds
sanitizedFilename=sanitizedTeamCreds

aws s3 cp s3://osce-installer/Passwords.csv ./ > /dev/null
tail -n +2 Passwords.csv | awk -F "," '{print $1 " " $2}' > ${filename}
sed -e "s///" ${filename} > ${sanitizedFilename}
rm ${filename}
echo ${sanitizedFilename}
