#!/bin/bash
curl -O https://releases.hashicorp.com/terraform/0.8.2/terraform_0.8.2_linux_amd64.zip
sudo apt-get unzip -y
unzip terraform*
mv terraform /usr/local/bin/
rm -rf terraform*