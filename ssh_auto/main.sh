#!/bin/bash 
#Before executing main.sh script, execute terraform template to create infra first to automate this script

keypair="elkprometheuskey.pem"
aws_region="us-east-2"

>iplist
>../hosts

cp -rpf /home/$keypair .

#comment this
sh prometheus_target_auto.sh
#comment this
sh hosts_auto.sh
#comment this
sh iplist_auto.sh

input="iplist"
while IFS= read -r var 
do
cp -rpf /root/.ssh/id_rsa.pub .
rsync -rave "ssh -o StrictHostKeyChecking=no -i $keypair" * ec2-user@"$var":/home/ec2-user
ssh -n -o StrictHostKeyChecking=no -i "$keypair" ec2-user@"$var" "chmod a+x /home/ec2-user/ssh_auto.sh"
ssh -n -o StrictHostKeyChecking=no -i "$keypair" ec2-user@"$var" '/home/ec2-user/ssh_auto.sh'
done < "$input"

rm -rf id_rsa.pub $keypair

cd ..

ansible-playbook -i hosts run.yml

#Comment till the above line
#rm -rf $keypair