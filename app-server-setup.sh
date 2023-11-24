#!/bin/bash
# Author: Yashraj Jaiswal
# Date: 17-11-2023
# Description: Congigure ec2 to run three_tier_application node js backend
# -------------
# install node js
sudo apt update
curl -sL https://rpm.nodesource.com/setup_16.x | bash -
sudo apt install -y nodejs

# install pm2
npm i -g pm2
# configure pm2 to run on startup
pm2 startup systemd
sudo env PATH=$PATH:/home/ubuntu/.local/share/nvm/v20.5.0/bin /home/ubuntu/.local/share/nvm/v20.5.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

# install unzip package
sudo apt install unzip
# install aws cli
cd /home/ubuntu
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# get backend zip file from s3 bucket
aws s3 cp s3://three-tier-application/server.tar.gz /home/ubuntu/
# extract source code
tar -xzf server.tar.gz

cd server
# start backend
pm2 start --name "node_backend" index.js
# save for startup
pm2 save
# ------------

#  script to run on build
tar -czf server.tar.gz --directory ./three_tier_application server/
