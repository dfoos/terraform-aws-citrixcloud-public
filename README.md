# terraform-aws-citrixcloud-public
Terraform module to create Citrix Cloud resources (Cloud Connectors, VDAs, FAS servers and security group rules) for both simple and complex Citrix Cloud deployments in AWS following the the Citrix reference architecture for AWS.

![Diagram 2: 100% Cloud Services on AWS with AWS Managed Services](https://content.invisioncic.com/m329563/monthly_2024_02/reference-architectures_citrix-virtual-apps-and-desktops-on-aws_002.png.3038cc763c962bed5839adbb219857a1.png "100% Cloud Services on AWS with AWS Managed Services")

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.connector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.fas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.virtual_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.virtual_desktop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.connector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.fas](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.virtual_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.virtual_desktop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.connector_connector_egress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_connector_egress_tcp_89](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_connector_egress_tcp_9095](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_connector_ingress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_connector_ingress_tcp_89](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_connector_ingress_tcp_9095](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_fas_egress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_fas_ingress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_app_egress_tcp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_app_egress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_app_egress_udp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_app_ingress_tcp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_app_ingress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_app_ingress_udp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_desktop_egress_tcp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_desktop_egress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_desktop_egress_udp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_desktop_ingress_tcp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_desktop_ingress_tcp_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.connector_virtual_desktop_ingress_udp_1494](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.extra_virtual_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.extra_virtual_desktop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.server_2019](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.server_2022](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_citrix_infra_subnet_ids"></a> [citrix\_infra\_subnet\_ids](#input\_citrix\_infra\_subnet\_ids) | List of subnet ids to deploy citrix infra (connectors & fas) ec2 instances in | `list(string)` | n/a | yes |
| <a name="input_citrix_vda_subnet_ids"></a> [citrix\_vda\_subnet\_ids](#input\_citrix\_vda\_subnet\_ids) | List of subnet ids to deploy vda ec2 instances in | `list(string)` | n/a | yes |
| <a name="input_extra_rules_virtual_app"></a> [extra\_rules\_virtual\_app](#input\_extra\_rules\_virtual\_app) | Extra security group rules for instances where published apps may need other resources such as database connectivity. | <pre>list(object({<br>    type        = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_extra_rules_virtual_desktop"></a> [extra\_rules\_virtual\_desktop](#input\_extra\_rules\_virtual\_desktop) | Extra security group rules for instances where published desktops may need other resources such as database connectivity. | <pre>list(object({<br>    type        = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_extra_security_group_ids"></a> [extra\_security\_group\_ids](#input\_extra\_security\_group\_ids) | List of security group IDs for existing security groups such as base or shared services (active directory, file shares, etc.). | `list(string)` | `[]` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Citrix Instances. | <pre>map(object({<br>    name_prefix      = string<br>    citrix_role      = string<br>    instance_count   = optional(number, 2)<br>    instance_type    = optional(string, "m5.large")<br>    ami              = optional(string, "")<br>    root_volume_size = optional(number, 60)<br>    windows_version  = optional(string, "2019")<br>    starting_number  = optional(number, 1)<br>  }))</pre> | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | Key pair's public key that will be registered with AWS to allow logging-in to EC2 instances. | `string` | `""` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Friendly name of Citrix tenant used if there are multiple tenants in the same environment. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id to deploy to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->


## Common Deployment Scenarios
This section covers how to use the module in different scenarios following the Citrix reference architecture for AWS.

### Simple Virtual Apps (2x Cloud Connectors, 2x App VDAs)

This deployent scenario includes everything needed to deploy a simple virtual apps deployment.

```
  instances = {
    xa-prod = {
      "citrix_role"    = "app"
      "name_prefix"    = "aws-xa-"
      "instance_count" = 2
    }
    cc = {
      "citrix_role"    = "connector"
      "name_prefix"    = "aws-cc-"
      "instance_count" = 2
    }
  }
```

### Virtual Apps and Virtual Desktops (2x Cloud Connectors, 2x App VDAs, 2x Desktop VDAs)

This deployent scenario includes everything needed to deploy a simple virtual apps deployment including virtual desktops.

```
  instances = {
    xa-prod = {
      "citrix_role"    = "app"
      "name_prefix"    = "aws-xa-"
      "instance_count" = 2
    }
    xd-prod = {
      "citrix_role"    = "desktop"
      "name_prefix"    = "aws-xd-"
      "instance_count" = 2
    }
    cc = {
      "citrix_role"    = "connector"
      "name_prefix"    = "aws-cc-"
      "instance_count" = 2
    }
  }
```

### Virtual Apps (Prod and UT) (2x Cloud Connectors, 2x App VDAs (Prod), 2x App VDAs (UT))

This deployent scenario includes everything needed to deploy a 2 App VDAs (Prod) on Windows Server 2019 and 2 App VDAs (UT) on Windows Server 2022.

```
  instances = {
    xa-prod = {
      "citrix_role"    = "app"
      "name_prefix"    = "aws-xaprod-"
      "instance_count" = 2
      "ami"            = "2019"
    }
    xa-ut = {
      "citrix_role"    = "app"
      "name_prefix"    = "aws-xaut-"
      "instance_count" = 2
      "ami"            = "2022"
    }
    cc = {
      "citrix_role"    = "connector"
      "name_prefix"    = "aws-cc-"
      "instance_count" = 2
    }
  }
```

### Simple Virtual Apps with FAS (2x Cloud Connectors, 2x App VDAs, 2x FAS)

This deployent scenario includes everything needed to deploy a simple virtual apps deployment with FAS.

```
  instances = {
    xa-prod = {
      "citrix_role"    = "app"
      "name_prefix"    = "aws-xa-"
      "instance_count" = 2
    }
    cc = {
      "citrix_role"    = "connector"
      "name_prefix"    = "aws-cc-"
      "instance_count" = 2
    }
    fas = {
      "citrix_role"    = "fas"
      "name_prefix"    = "aws-fas-"
      "instance_count" = 2
    }
  }
```
### Simple Virtual Apps and Virtual Desktops with Extra Security Group Rules(2x Cloud Connectors, 2x App VDAs, 2x Desktop VDAs)

This deployent scenario includes everything needed to deploy a simple virtual apps deployment including virtual desktops including additional security group rules.

```
  instances = {
    xa-prod = {
      "citrix_role"    = "app"
      "name_prefix"    = "aws-xa-"
      "instance_count" = 2
    }
    xd-prod = {
      "citrix_role"    = "desktop"
      "name_prefix"    = "aws-xd"
      "instance_count" = 2
    }
    cc = {
      "citrix_role"    = "connector"
      "name_prefix"    = "aws-cc-"
      "instance_count" = 2
    }
  }

  extra_rules_virtual_app = [
    {
      "type"        = "egress"
      "from_port"   = 1433
      "to_port"     = 1433
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.70.1.3/32"]
      "description" = "TCP/1433 to database server"
    },
    {
      "type"        = "egress"
      "from_port"   = 445
      "to_port"     = 445
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.70.1.4/32"]
      "description" = "TCP/445 to file server"
    },
    {
      "type"        = "ingress"
      "from_port"   = 443
      "to_port"     = 443
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.70.1.5/32"]
      "description" = "TCP/443 from monitor server"
    }
]

  extra_rules_virtual_desktop = [
    {
      "type"        = "egress"
      "from_port"   = 445
      "to_port"     = 445
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.70.1.4/32"]
      "description" = "TCP/445 to file server"
    },
    {
      "type"        = "ingress"
      "from_port"   = 443
      "to_port"     = 443
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.70.1.5/32"]
      "description" = "TCP/443 from monitor server"
    }
]
```

### Multi-Tenant Setup

Some Citrix Cloud deployments may require multiple Citrix Cloud tenants based off of URL or authentication type. This can be handled by using the tenant varibale and calling the module multiple times.

