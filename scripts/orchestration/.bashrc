# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
teamPrivateKey="/home/ec2-user/teamKey.private"
eventName=$(cat /home/ec2-user/variables/eventName)

alias reloadshell="exec $SHELL -l"

jump-team() {
	ssh -v -i ${teamPrivateKey} ubuntu@${1}.${eventName}.jump.trenddemos.com
}

atk-team() {
	ssh -v -i ${teamPrivateKey} ubuntu@${1}.${eventName}.atk.trenddemos.com
}

launch-event() {
    cd /home/ec2-user/tmThreatChallenge/scripts/threatChallengeLaunch/
    ./launchMultiTenantTeamsFromCreds.sh
}

delete-event() {
    cd /home/ec2-user/tmThreatChallenge/scripts/cleanUp/
    ./cleanThreatDefense.sh
}

rebuild-team() {
    cd /home/ec2-user/tmThreatChallenge/scripts/threatChallengeLaunch/
    teamToRebuild=${1}
    dsmT0Password=$(cat /home/ec2-user/variables/t0AdminPassword)
    eventName=$(cat /home/ec2-user/variables/eventName)
    keyPair=$(cat /home/ec2-user/variables/sshkey)
    dsmFqdn="dsm.${eventName}.trenddemos.com"
    dsmT0Admin='t0Admin'
    dsmConsolePort='443'
    while read line
    do
        creds=(${line})
        if [[ ${creds[0]} != ${teamToRebuild} ]]
        then
            continue
        fi
        nohup ./launchTmtcTeam.sh ${dsmT0Admin} "${dsmT0Password}" ${dsmFqdn} ${dsmConsolePort} ${creds[0]}-rebuild ${creds[1]} ${keyPair} ${eventName} &
        break
    done < sanitizedTeamCreds
}