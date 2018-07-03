#!/bin/bash 

aws_region="us-east-2"
phpapp1=`aws ec2 describe-instances --region $aws_region --filters "Name=tag:Name,Values=prometheus_client" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text`
sed -e "s/\${promc1}/$phpapp1/"  prometheus.yml >> test.yml
rm -rf prometheus.yml
mv test.yml prometheus.yml