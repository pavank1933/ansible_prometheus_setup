#!/bin/bash

aws_region="us-east-2"

echo "[prometheus_server]" >>../hosts

elk=`aws ec2 describe-instances --region $aws_region --filters "Name=tag:Name,Values=prometheus_server" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text`

echo "$elk ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/ec2-user/.ssh/id_rsa" >> ../hosts


echo "[prometheus_client]" >> ../hosts

elk_client=`aws ec2 describe-instances --region $aws_region --filters "Name=tag:Name,Values=phpapp1" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text`

echo "$elk_client ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/ec2-user/.ssh/id_rsa" >> ../hosts
