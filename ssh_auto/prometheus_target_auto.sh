#!/bin/bash 

aws_region="us-east-2"
phpapp1=`aws ec2 describe-instances --region $aws_region --filters "Name=tag:Name,Values=prometheus_client" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text`
sed -e "s/\${promc1}/$phpapp1/"  ../prometheus_server/templates/prometheus.yml >> ../prometheus_server/templates/test.yml
rm -rf ../prometheus_server/templates/prometheus.yml
mv ../prometheus_server/templates/test.yml ../prometheus_server/templates/prometheus.yml
