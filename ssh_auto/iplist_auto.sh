#!/bin/bash

aws_region="us-east-2"

echo `aws ec2 describe-instances --region $aws_region --filters "Name=tag:Name,Values=prometheus_server" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text` >> iplist
echo `aws ec2 describe-instances --region $aws_region --filters "Name=tag:Name,Values=phpapp1" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text` >> iplist
