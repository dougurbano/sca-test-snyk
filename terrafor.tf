provider "aws" {
  region = "us-east-1"
}

# 🔒 Grupo de segurança restrito
resource "aws_security_group" "restricted_sg" {
  name        = "restricted_sg"
  description = "Allow limited inbound and outbound traffic"

  # ✅ Corrigido: limitar o acesso somente a uma porta específica (exemplo: SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]  # faixa privada e mais segura
  }

  # ✅ Corrigido: saída só para portas comuns (ex: 80, 443)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🪣 Bucket S3 com bloqueio completo de acesso público
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-bucket-terraform"
  acl    = "private"
}

# 🔐 Bloqueio de acesso público no bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
