# ansible_prometheus_setup
Setup prometheus server and its clients with node exporter to send metrics to prometheus server using Ansible


Pre-requsites:-
->Install ansible in ubuntu
#!/bin/bash
sudo su
apt-get update -y
apt-get install ansible -y
mkdir -p playbooks
cd playbooks
export ANSIBLE_HOST_KEY_CHECKING=False

->cd /home/ubuntu
-> mkdir -p roles
-> cd roles
-> git clone https://github.com/pavank1933/ansible_prometheus_setup.git

Do the below steps:-

****STEP 1*******
-> Create the following required files/directories
root@ip-172-30-0-133:/home# ls -ltr
total 16
-r-------- 1 root   root   1675 Mar 13 15:03 IOT-Pavan-Keypair.pem
drwxr-xr-x 5 ubuntu ubuntu 4096 Mar 13 15:55 ubuntu
-rw-r--r-- 1 root   root    437 Mar 13 17:08 ssh_auto.sh
-rw-r--r-- 1 root   root     43 Mar 13 18:22 iplist

-> iplist- This file contains contains phpapp1,phpapp2, phpapp3, prometheus_server ip addresses line by line
-> ssh_auto.sh-> This will automate ssh process
   #!/bin/bash
	input="/home/iplist"
	while IFS= read -r var
	do
	  ssh -o StrictHostKeyChecking=no -i "IOT-Pavan-Keypair.pem" ec2-user@"$var" <<'ENDSSH'
	  cp -rpf /home/ec2-user/.ssh/authorized_keys /home/ec2-user/.ssh/authorized_keys-orig
	ENDSSH

	  mapfile < /root/.ssh/id_rsa.pub
	  echo "${MAPFILE[@]}" | ssh -o StrictHostKeyChecking=no -i "IOT-Pavan-Keypair.pem" ec2-user@"$var" "cat >> /home/ec2-user/.ssh/authorized_keys"
	done < "$input"
-> Execute the below step to copy ansible server(ubuntu) public key to all three 3 remote servers and prometheus server
-> $ bash ssh_auto.sh

****STEP 2*******
-> Update /etc/ansible/hosts with the following lines:

[prometheus_server]
52.90.63.107 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa

[prometheus_client_setup]
54.210.243.165 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa
34.235.120.235 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa
34.25.10.25 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa

Note:- Replace above ip addresses


****STEP 3*******
Add the prometheus_clients to the following file "/home/ubuntu/roles/prometheus_server/templates/prometheus.yml" in the `targets` section

