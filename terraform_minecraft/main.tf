terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true

        filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]

        #Filter to pull only latest Ubuntu images.
    }

    owners = ["099720109477"]
}

resource "aws_security_group" "mc_security_group" {
  ingress {
    description = "Public MC Access"
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  
  from_port = 22
    to_port = 22
    protocol = "tcp"
  
  }

  egress {
    description = "Public outbound MC Acces"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Minecraft Server"
  }
}

resource "aws_key_pair" "all" {
  key_name = "aws_key"
  public_key = "${var.public_key}"
}

resource "aws_instance" "minecraft_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mc_security_group.id]
    associate_public_ip_address = true
    key_name = aws_key_pair.all.key_name
    user_data = <<-EOF
      #!/bin/bash
      sudo apt-get -y update
      sudo apt-get -y install openjdk-8-jre-headless

      wget -O server.jar https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar

      java -Xmx1024< -Xms1024M -jar server.jar nogui
      sed -i 's/eula=false/eula=true/' eula.txt
      java -Xmx1024M -Xms1024M -jar server.jar nogui
      
      EOF
    tags = {
      Name = "My Minecraft Server"
    }
}
