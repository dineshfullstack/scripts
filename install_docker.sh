#!/bin/bash

# Update your existing list of packages
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y

# Start the Docker service
sudo service docker start

# Add the ec2-user to the docker group 
# This is to avoid typing sudo whenever you run the docker command. 
sudo usermod -a -G docker ec2-user

# Make docker auto-start
sudo chkconfig docker on

# Reboot for the changes to take effect
sudo reboot
