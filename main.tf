
# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-01b8d743224353ffe" #Ubuntu Server, 22.04 LTS
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_http.name]
  associate_public_ip_address = true
  key_name = "myec2key"


  # Install Apache webserver and write "Hello, World"
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo 'Hello, World' > /var/www/html/index.html
  EOF

  tags      = {
    Name    = "Instance_Task3(HelloWorld)"
  }
}
# Expose port 8080
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic Task3"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH access"
    from_port        = 22 
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
}
output "url" {
    value = "http://${aws_instance.web_server.public_ip}:8080"
}
