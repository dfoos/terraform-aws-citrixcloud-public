#######################################################################################
#     EC2 INSTANCES
#######################################################################################

resource "aws_instance" "virtual_app" {
  for_each = local.instance_map_virtual_app

  ami                    = each.value.ami == "" ? lookup(local.distro, each.value.windows_version, local.distro[2019]) : each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = element(var.citrix_vda_subnet_ids, index(keys(local.instance_map_virtual_app), each.key))
  vpc_security_group_ids = concat([aws_security_group.virtual_app[0].id], var.extra_security_group_ids)
  key_name               = var.public_key == "" ? null : aws_key_pair.deployer[0].key_name

  root_block_device {
    volume_size           = each.value.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name       = format("%s%d", each.value.name_prefix, (split("_", each.key))[1])
    Tenant     = var.tenant
    CitrixType = "virtual_app"
  }
}

resource "aws_instance" "virtual_desktop" {
  for_each = local.instance_map_virtual_desktop

  ami                    = each.value.ami == "" ? lookup(local.distro, each.value.windows_version, local.distro[2019]) : each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = element(var.citrix_vda_subnet_ids, index(keys(local.instance_map_virtual_desktop), each.key))
  vpc_security_group_ids = concat([aws_security_group.virtual_desktop[0].id], var.extra_security_group_ids)
  key_name               = var.public_key == "" ? null : aws_key_pair.deployer[0].key_name

  root_block_device {
    volume_size           = each.value.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name       = format("%s%d", each.value.name_prefix, (split("_", each.key))[1])
    Tenant     = var.tenant
    CitrixType = "virtual_desktop"
  }
}

resource "aws_instance" "connector" {
  for_each = local.instance_map_connector

  ami                    = each.value.ami == "" ? lookup(local.distro, each.value.windows_version, local.distro[2019]) : each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = element(var.citrix_infra_subnet_ids, index(keys(local.instance_map_connector), each.key))
  vpc_security_group_ids = concat([aws_security_group.connector[0].id], var.extra_security_group_ids)
  key_name               = var.public_key == "" ? null : aws_key_pair.deployer[0].key_name

  root_block_device {
    volume_size           = each.value.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name       = format("%s%d", each.value.name_prefix, (split("_", each.key))[1])
    Tenant     = var.tenant
    CitrixType = "connector"
  }
}

resource "aws_instance" "fas" {
  for_each = local.instance_map_fas

  ami                    = each.value.ami == "" ? lookup(local.distro, each.value.windows_version, local.distro[2019]) : each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = element(var.citrix_infra_subnet_ids, index(keys(local.instance_map_fas), each.key))
  vpc_security_group_ids = concat([aws_security_group.fas[0].id], var.extra_security_group_ids)
  key_name               = var.public_key == "" ? null : aws_key_pair.deployer[0].key_name

  root_block_device {
    volume_size           = each.value.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name       = format("%s%d", each.value.name_prefix, (split("_", each.key))[1])
    Tenant     = var.tenant
    CitrixType = "fas"
  }
}

#######################################################################################
#     IAM
#######################################################################################

resource "aws_key_pair" "deployer" {
  count      = var.public_key == "" ? 0 : 1
  key_name   = format("citrix-%s-key", var.tenant)
  public_key = var.public_key
}

#######################################################################################
#     EXTRA SECURITY GROUP RULES
#######################################################################################

# virtual_app
resource "aws_security_group_rule" "extra_virtual_app" {
  for_each = var.extra_rules_virtual_app != {} ? { for rule in var.extra_rules_virtual_app : format("%s_%s_%s_%s_%s", rule.type, rule.protocol, rule.to_port, rule.from_port, replace(replace(rule.description, " ", "_"), " ", "_")) => rule } : {}

  type              = each.value.type
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  self              = true
  security_group_id = aws_security_group.virtual_app[0].id
  description       = each.value.description
}

# virtual_desktop
resource "aws_security_group_rule" "extra_virtual_desktop" {
  for_each = var.extra_rules_virtual_desktop != {} ? { for rule in var.extra_rules_virtual_desktop : format("%s_%s_%s_%s_%s", rule.type, rule.protocol, rule.to_port, rule.from_port, replace(replace(rule.description, " ", "_"), " ", "_")) => rule } : {}

  type              = each.value.type
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  self              = true
  security_group_id = aws_security_group.virtual_desktop[0].id
  description       = each.value.description
}

#######################################################################################
#     PRODUCT SECURITY GROUPS
# https://community.citrix.com/tech-zone/build/tech-papers/citrix-communication-ports
#######################################################################################

# virtual_app
resource "aws_security_group" "virtual_app" {
  count = length(local.instance_map_virtual_app) > 0 ? 1 : 0

  name        = var.tenant == "" ? "virtual_app-sg" : format("%s-virtual_app-sg", var.tenant)
  description = "virtual_app security group"
  vpc_id      = var.vpc_id

  tags = {
    Name       = var.tenant == "" ? "virtual_app-sg" : format("%s-virtual_app-sg", var.tenant)
    Tenant     = var.tenant
    CitrixType = "virtual_app"
  }
}

# virtual_desktop
resource "aws_security_group" "virtual_desktop" {
  count = length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  name        = var.tenant == "" ? "virtual_desktop-sg" : format("%s-virtual_desktop-sg", var.tenant)
  description = "virtual_desktop security group"
  vpc_id      = var.vpc_id

  tags = {
    Name       = var.tenant == "" ? "virtual_desktop-sg" : format("%s-virtual_desktop-sg", var.tenant)
    Tenant     = var.tenant
    CitrixType = "virtual_desktop"
  }
}

# connector
resource "aws_security_group" "connector" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  name        = var.tenant == "" ? "connector-sg" : format("%s-connector-sg", var.tenant)
  description = "connector security group"
  vpc_id      = var.vpc_id

  tags = {
    Name       = format("%s-connector-sg", var.tenant)
    Tenant     = var.tenant
    CitrixType = "connector"
  }
}

# fas
resource "aws_security_group" "fas" {
  count = length(local.instance_map_fas) > 0 ? 1 : 0

  name        = var.tenant == "" ? "fas-sg" : format("%s-fas-sg", var.tenant)
  description = "fas security group"
  vpc_id      = var.vpc_id

  tags = {
    Name       = var.tenant == "" ? "fas-sg" : format("%s-fas-sg", var.tenant)
    Tenant     = var.tenant
    CitrixType = "fas"
  }
}

#######################################################################################
#     SECURITY GROUP RULES
#######################################################################################

###### Cloud Connector <> Cloud Connector [TCP/80,89,9095]
resource "aws_security_group_rule" "connector_connector_egress_tcp_80" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/80 to connector"
}

resource "aws_security_group_rule" "connector_connector_egress_tcp_89" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 89
  protocol          = "tcp"
  from_port         = 89
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/89 to connector"
}

resource "aws_security_group_rule" "connector_connector_egress_tcp_9095" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 9095
  protocol          = "tcp"
  from_port         = 905
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/9095 to connector"
}

resource "aws_security_group_rule" "connector_connector_ingress_tcp_80" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/80 from connector"
}

resource "aws_security_group_rule" "connector_connector_ingress_tcp_89" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 89
  protocol          = "tcp"
  from_port         = 89
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/89 from connector"
}

resource "aws_security_group_rule" "connector_connector_ingress_tcp_9095" {
  count = length(local.instance_map_connector) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 9095
  protocol          = "tcp"
  from_port         = 905
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/9095 from connector"
}

###### Cloud Connector -> FAS [TCP/80]
resource "aws_security_group_rule" "connector_fas_egress_tcp_80" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_fas) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/80 to fas"
}

resource "aws_security_group_rule" "connector_fas_ingress_tcp_80" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_fas) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.fas[0].id
  description       = "TCP/80 from connector"
}

###### Cloud Connector -> virtual_app VDA [TCP/80,TCP/UDP/1494,TCP/UDP/2598]
resource "aws_security_group_rule" "connector_virtual_app_egress_tcp_80" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_app) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/80 to virtual_app"
}

resource "aws_security_group_rule" "connector_virtual_app_egress_tcp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_app) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 1494
  protocol          = "tcp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/1494 to virtual_app"
}

resource "aws_security_group_rule" "connector_virtual_app_egress_udp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_app) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 1494
  protocol          = "udp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "UDP/1494 to virtual_app"
}

resource "aws_security_group_rule" "connector_virtual_app_ingress_tcp_80" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_app) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.virtual_app[0].id
  description       = "TCP/80 from connector"
}

resource "aws_security_group_rule" "connector_virtual_app_ingress_tcp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_app) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 1494
  protocol          = "tcp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.virtual_app[0].id
  description       = "TCP/1494 from connector"
}

resource "aws_security_group_rule" "connector_virtual_app_ingress_udp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_app) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 1494
  protocol          = "udp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.virtual_app[0].id
  description       = "UDP/1494 from connector"
}

###### Cloud Connector -> virtual_app VDA [TCP/80,TCP/UDP/1494,TCP/UDP/2598]
resource "aws_security_group_rule" "connector_virtual_desktop_egress_tcp_80" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/80 to virtual_desktop"
}

resource "aws_security_group_rule" "connector_virtual_desktop_egress_tcp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 1494
  protocol          = "tcp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "TCP/1494 to virtual_desktop"
}

resource "aws_security_group_rule" "connector_virtual_desktop_egress_udp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  type              = "egress"
  to_port           = 1494
  protocol          = "udp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.connector[0].id
  description       = "UDP/1494 to virtual_desktop"
}

resource "aws_security_group_rule" "connector_virtual_desktop_ingress_tcp_80" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  self              = true
  security_group_id = aws_security_group.virtual_desktop[0].id
  description       = "TCP/80 from connector"
}

resource "aws_security_group_rule" "connector_virtual_desktop_ingress_tcp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 1494
  protocol          = "tcp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.virtual_desktop[0].id
  description       = "TCP/1494 from connector"
}

resource "aws_security_group_rule" "connector_virtual_desktop_ingress_udp_1494" {
  count = length(local.instance_map_connector) > 0 && length(local.instance_map_virtual_desktop) > 0 ? 1 : 0

  type              = "ingress"
  to_port           = 1494
  protocol          = "udp"
  from_port         = 1494
  self              = true
  security_group_id = aws_security_group.virtual_desktop[0].id
  description       = "UDP/1494 from connector"
}
