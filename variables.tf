#######################################################################################
#     Required Variables
#######################################################################################

variable "citrix_infra_subnet_ids" {
  description = "List of subnet ids to deploy citrix infra (connectors & fas) ec2 instances in"
  type        = list(string)
}

variable "citrix_vda_subnet_ids" {
  description = "List of subnet ids to deploy vda ec2 instances in"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id to deploy to"
  type        = string
}

variable "instances" {
  description = "Citrix Instances."
  type = map(object({
    name_prefix      = string
    citrix_role      = string
    instance_count   = optional(number, 2)
    instance_type    = optional(string, "m5.large")
    ami              = optional(string, "")
    root_volume_size = optional(number, 60)
    windows_version  = optional(string, "2019")
    starting_number  = optional(number, 1)
  }))
}

#######################################################################################
#     Optional Variables
#######################################################################################

variable "extra_rules_virtual_app" {
  description = "Extra security group rules for instances where published apps may need other resources such as database connectivity."
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "extra_rules_virtual_desktop" {
  description = "Extra security group rules for instances where published desktops may need other resources such as database connectivity."
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "extra_security_group_ids" {
  description = "List of security group IDs for existing security groups such as base or shared services (active directory, file shares, etc.)."
  type        = list(string)
  default     = []
}

variable "public_key" {
  description = "Key pair's public key that will be registered with AWS to allow logging-in to EC2 instances."
  type        = string
  default     = ""
}

variable "tenant" {
  description = "Friendly name of Citrix tenant used if there are multiple tenants in the same environment."
  type        = string
  default     = ""
}
