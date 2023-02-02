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
    instance_type = "t2.small"
    vpc_security_group_ids = [aws_security_group.mc_security_group.id]
    associate_public_ip_address = true
    key_name = aws_key_pair.all.key_name
    
    tags = {
      Environment = "Dev"
      Name = "My Minecraft Server"
    }

    connection {
      user = "ubuntu"
      type = "ssh"
      private_key = "${file(var.private_key_path)}"

      provisioner "remote-exec" {
        inline = [
          "sudo apt-get -y update",
          "sudo apt-get -y install openjdk-8-jre-headless",
          "mkdir data",
          "cd data",
          "mkdir inbox",
          "cd .."
        ]
      }
    }
}

output "instance_ip_address" {
  value = aws_instance.minecraft_server.public_ip
}