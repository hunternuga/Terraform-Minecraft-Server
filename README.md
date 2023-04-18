# Terraform Minecraft Configuration Files

**These configuration files are written to create an EC2 instance, with an associated security group to ssh into the instance. In order to SSH into the instance the following items are needed.**
- SSH Key files (ssh key and .pub file)
- AWS Account with Access and Private Keys (Utilizing the AWS CLI is necessary as well)

Ensure that the SSH Key files are setup in the working directory of your .tf configuration files.
Once the configuration has been applied to your AWS Environment, connect to the Instance via SSH to install:
- Java dependecies for Minecraft Server
- Minecraft Server Version: https://www.minecraft.net/en-us/download/server

Have fun with Minecraft, fully built by Terraform in AWS!
[This project is currently a work in progress and does not result in a fully fuctioning MC server, yet.]
