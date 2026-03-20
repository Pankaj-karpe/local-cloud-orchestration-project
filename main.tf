#HCl code for S3 bucket
resource "aws_s3_bucket" "local_S3_name" {
  bucket = var.bucket_name

  tags = {
    Name        = "my_S3_bucket_unique"
    Environment = "Dev"
  }
}


#HCl code for DynamoDb 
resource "aws_dynamodb_table" "local_dynamodb_name" {
  name         = var.dynamodb_name
  billing_mode = var.dynamodb_billing_mode
  hash_key     = var.dynamodb_hashKey

  attribute {
    name = "TeamId"
    type = "S"
  }
}

#HCl code for IAM role
resource "aws_iam_role" "sre_app_role" {
  name = "sre-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

#HCl code for IAM role policy permision
resource "aws_iam_policy" "dynamodb_read_write" {
  name        = "DynamoDBAccessPolicy"
  description = "Allows Put, Get, and Scan on IPL_Teams table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Scan"
      ]
      Effect   = "Allow"
      Resource = aws_dynamodb_table.local_dynamodb_name.arn
    }]
  })
}

#HCl code for role attachment
resource "aws_iam_role_policy_attachment" "sre_attach" {
  role       = aws_iam_role.sre_app_role.name
  policy_arn = aws_iam_policy.dynamodb_read_write.arn
}

#HCL code for VPC usage
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

#HCL code for subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

#HCL code for internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#HCL code for sequrity group 
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id # Ensure this matches your VPC resource name

  # Inbound Rules (Ingress)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows access from anywhere
  }

  # Outbound Rules (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# This is the "bridge" between the Role and the EC2 Instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "sre-app-profile-v1"
  role = aws_iam_role.sre_app_role.name
}

#HCL code for ec2 instance with attachment to  subnet, sg, iam role
resource "aws_instance" "app_server" {
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Pankaj-SRE-Server"
  }
}
