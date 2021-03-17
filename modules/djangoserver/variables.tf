variable "vpc_cidr_block" {
  type        = string
  description = "VPC cider block"
  default     = "10.0.0.0/16"
}

variable "vpc_dns_support" {
  type        = bool
  description = "VPC DNS support"
  default     = true
}

variable "vpc_dns_hostnames" {
  type        = bool
  description = "VPC DNS hostnames"
  default     = true
}

variable "vpc_azs" {
  type        = list(string)
  description = "Availability zones for VPC"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets"
  default     = 2
}

variable "vpc_subnets" {
  type        = list(string)
  description = "subnets for VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "server_name" {
  type        = string
  description = "Name of the django server"
  default     = "django-server"
}

variable "instance_count" {
  type        = number
  description = "Number of instances"
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t3a.small"
}

variable "ssh_pubkey_file" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to an SSH public key"
}

variable "ssh_pvtkey_file" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "/Path to an SSH private key"
}

variable "dcompose_files" {
  type        = list(string)
  description = "subnets for VPC"
  default     = ["/home/ubuntu/devopstest2/dcompose-app1-db.yml", "/home/ubuntu/devopstest2/dcompose-app2.yml"]
}