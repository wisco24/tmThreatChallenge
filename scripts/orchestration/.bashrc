# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
teamPrivateKey="/home/ec2-user/teamKey.private"
eventName=$(cat /home/ec2-user/variables/eventName)

alias reloadshell="exec $SHELL -l"

ssh-ctf() {
	ssh -v -i ${ctfPrivateKey} ubuntu@ec2-52-44-201-141.compute-1.amazonaws.com
}

jump-team() {
	ssh -v -i ${teamPrivateKey} ubuntu@${1}.${eventName}.jump.trenddemos.com
}

atk-team() {
	ssh -v -i ${teamPrivateKey} ubuntu@${1}.${eventName}.atk.trenddemos.com
}

launch-event() {
    cd /home/ec2-user/tmThreatChallenge/scripts/threatChallenge/
    ./launchMultiTenantTeamsFromCreds.sh
}

delete-event() {
    cd /home/ec2-user/tmThreatChallenge/cleanup/
    ./cleanThreatDefense.sh
}