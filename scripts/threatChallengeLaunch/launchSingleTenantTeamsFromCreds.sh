#!/bin/bash

./getTeamsCsv.sh

filename="teamcreds"

while read line
do
    creds=(${line})
    ./launchTeamSko2017.sh ${creds[0]} "MasterAdmin" ${creds[1]}
done < $filename

rm $filename