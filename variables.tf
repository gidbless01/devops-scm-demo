variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
}

variable "key_name" {
  description = "EC2 Key Pair name"
}

variable "db_password" {
  description = "RDS DB password"
  sensitive   = true
}
