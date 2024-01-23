provider "aws" {
    region = "us-east-1"
  }

resource "aws_security_group" "websg" {
  name = "websg"
  vpc_id = var.websg_vpc_id
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "custom port"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
  
}

resource "aws_key_pair" "keyexample" {
  key_name = "terraform-demo-key"
  public_key = file("/home/helly-gtcsys/.ssh/id_rsa.pub")
  
}


resource "aws_instance" "server" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.keyexample.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id = var.subnet_id

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/home/helly-gtcsys/.ssh/id_rsa")
    host = self.public_ip
    timeout = "15m"
  }
  # provisioner "remote-exec" {
  #   inline = [ 
  #   "sudo apt-get update -y", 
  #   "sudo apt-get install -y git curl",
  #   "git clone https://github.com/helly2910/React.git",
  #   "cd React",  # Change to the directory where package.json is located
  #   "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -",
  #   "sudo apt-get install -y nodejs",
  #   "npm install",
  #   "npm run start"
  #  ]
    
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y git curl",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/helly2910/React.git",
       "cd React",  # Change to the directory where package.json is located
       "pwd"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "npm install",
      "npm run start",
    ]
  }
}





