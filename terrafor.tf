provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound and outbound traffic"
  
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Vulnerabilidade: Permitir acesso irrestrito a todas as portas
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Vulnerabilidade: Permitir saída irrestrita para todas as portas
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Vulnerabilidade: usar AMI sem validação de segurança
  instance_type = "t2.micro"

  key_name = "my-key"  # Vulnerabilidade: não usar chave segura

  tags = {
    Name = "VulnerableInstance"
  }

  # Falta de configuração de rede segura
  associate_public_ip_address = true  # Vulnerabilidade: instância com IP público, sem necessidade
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket-terraform"
  acl    = "public-read"  # Vulnerabilidade: bucket S3 público
}
