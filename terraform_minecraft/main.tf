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
    }

    owners = ["099720109477"] # Canonical
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
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(var.private_key_path)}"
      host = self.public_ip
    }

    provisioner "remote-exec" {
      inline = [
        "sudo apt-get -y update",
        "sudo apt-get -y install openjdk-8-jre-headless",
    ]
  }
}

output "instance_ip_address" {
  value = aws_instance.minecraft_server.public_ip
}
