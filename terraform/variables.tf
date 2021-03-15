variable "profile" {
  type    = string
  default = "default"
}

variable "region-devopstest" {
  type    = string
  default = "us-east-1"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "Availability zones"
}

variable "public_subnet_1_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR Block for Public Subnet 1"
}

variable "public_subnet_2_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR Block for Public Subnet 1"
}

variable "instance-type" {
  type    = string
  default = "t3a.small"
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
