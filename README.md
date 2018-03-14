# ansible_prometheus_setup
******Setup prometheus server and its clients with node exporter to send metrics to prometheus server using Ansible


*****Pre-requsites:-   <br/>
Create ubuntu instance   <br/>

->cd /home/ubuntu      <br/>
-> git clone https://github.com/pavank1933/ansible_prometheus_setup.git   <br/>
-> git clone https://github.com/pavank1933/prometheus_terraform_aws_test.git   <br/>
-> cd ansible_prometheus_setup        <br/>
-> bash install_ansible.sh	            <br/>
-> bash install_terraform.sh             <br/>
-> cd ..               <br/>
-> cd prometheus_terraform_aws_test            <br/>
-> /usr/local/bin/terraform apply              <br/>
-> press enter        <br/>


***Do the below steps:-                <br/>

****STEP 1*******            <br/>
-> cd /home                  <br/>
-> Create the following required files/directories                <br/>
root@ip-172-30-0-133:/home# ls -ltr                                    <br/>
total 16                    <br/>
-r-------- 1 root   root   1675 Mar 13 15:03 IOT-Pavan-Keypair.pem     # create this         <br/>
drwxr-xr-x 5 ubuntu ubuntu 4096 Mar 13 15:55 ubuntu                    #Default folder            <br/>
-rw-r--r-- 1 root   root    437 Mar 13 17:08 ssh_auto.sh               # create this           <br/>
-rw-r--r-- 1 root   root     43 Mar 13 18:22 iplist                    # create this              <br/>


#Paste your keypair file for eg:`IOT-Pavan-Keypair.pem` in the path /home which is used to login all the instances      <br/>


-> iplist- This file contains contains phpapp1,phpapp2, phpapp3, prometheus_server ip addresses line by line <br/>
-> ssh_auto.sh-> This will automate ssh process <br/>
   #!/bin/bash           <br/>
	input="/home/iplist"        <br/>
	while IFS= read -r var        <br/>
	do            <br/>
	  ssh -o StrictHostKeyChecking=no -i "IOT-Pavan-Keypair.pem" ec2-user@"$var" <<'ENDSSH'        <br/>
	  cp -rpf /home/ec2-user/.ssh/authorized_keys /home/ec2-user/.ssh/authorized_keys-orig         <br/>
	ENDSSH             <br/>

	  mapfile < /root/.ssh/id_rsa.pub          <br/>
	  echo "${MAPFILE[@]}" | ssh -o StrictHostKeyChecking=no -i "IOT-Pavan-Keypair.pem" ec2-user@"$var" "cat >> /home/ec2-user/.ssh/authorized_keys"   <br/>
	done < "$input"
-> Execute the below step to copy ansible server(ubuntu) public key to all three 3 remote servers and prometheus server
-> $ bash ssh_auto.sh              <br/>

****STEP 2*******           <br/>
-> Update /etc/ansible/hosts with the following lines:       <br/>

[prometheus_server]         <br/>
52.90.63.107 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa       <br/>

[prometheus_client_setup]             <br/>
54.210.243.165 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa       <br/>
34.235.120.235 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa           <br/>
34.25.10.25 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/.ssh/id_rsa             <br/>

Note:- Replace above ip addresses            <br/>


****STEP 3*******                      <br/>
Add the prometheus_clients to the following file "/home/ubuntu/roles/prometheus_server/templates/prometheus.yml" in the `targets` section like below:         <br/>
- targets: ['54.210.243.165:9100','34.235.120.235:9100','34.25.10.25:9100']            <br/>
 

*******Step 4***         <br/>
cd /home/ubuntu/ansible_prometheus_setup      <br/>
ansible-playbook -v run.yml        <br/>
