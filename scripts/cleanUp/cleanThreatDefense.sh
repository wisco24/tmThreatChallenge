#!/bin/bash

allstacks=($(aws cloudformation describe-stacks --query 'Stacks[].StackName' --output text))

deletedstacks=0
deletedusers=0
for stack in "${allstacks[@]}"
do
    role=($(aws cloudformation describe-stacks --stack-name ${stack} --query 'Stacks[].[Tags[?Key==`CtfRole`].Value[]]' --output text))
    if [[ "${role}" = "SkoTeamStack" ]]
        then
        if [[ "${stack}" == *"-TMTC" ]]
            then
            aws cloudformation delete-stack --stack-name ${stack}
            echo -e "Deleting Stack ${stack}\n"
            ((deletedstacks++))
        fi
    fi
done


allusers=($(aws iam list-users --query Users[].UserName --output text))

for user in ${allusers[@]}
do
    if [[ ${user} == *"Table"*"-dsmservice" ]]
    then
        echo "Deleting User ${user}"
        aws iam delete-user-policy --user-name ${user} --policy-name DSMUserRole
        keyIds=($(aws iam list-access-keys --user-name ${user} --query AccessKeyMetadata[].AccessKeyId --output text))
        for key in ${keyIds[@]}
        do
                aws iam delete-access-key --user-name ${user} --access-key-id ${key}
        done
        aws iam delete-user --user-name ${user}
        ((deletedusers++))
    fi
done

echo "Deleting challenge KeyPair"
aws ec2 delete-key-pair --key-name $(cat /home/ec2-user/variables/sshkey)

echo -e "sko mass test cleanup complete. Deleted ${deletedstacks} stacks and ${deletedusers} users"