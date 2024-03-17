locals {

  instance_list_virtual_app     = flatten([for k, v in var.instances : v.starting_number == 1 ? [for i in range(v.instance_count) : format("%s_%d", k, i + 1)] : [for i in range(v.instance_count) : format("%s_%d", k, i + v.starting_number)] if v.citrix_role == "app"])
  instance_list_virtual_desktop = flatten([for k, v in var.instances : v.starting_number == 1 ? [for i in range(v.instance_count) : format("%s_%d", k, i + 1)] : [for i in range(v.instance_count) : format("%s_%d", k, i + v.starting_number)] if v.citrix_role == "desktop"])
  instance_list_connector       = flatten([for k, v in var.instances : v.starting_number == 1 ? [for i in range(v.instance_count) : format("%s_%d", k, i + 1)] : [for i in range(v.instance_count) : format("%s_%d", k, i + v.starting_number)] if v.citrix_role == "connector"])
  instance_list_fas             = flatten([for k, v in var.instances : v.starting_number == 1 ? [for i in range(v.instance_count) : format("%s_%d", k, i + 1)] : [for i in range(v.instance_count) : format("%s_%d", k, i + v.starting_number)] if v.citrix_role == "fas"])

  instance_map_virtual_app     = { for i in local.instance_list_virtual_app : i => var.instances[split("_", i)[0]] }
  instance_map_virtual_desktop = { for i in local.instance_list_virtual_desktop : i => var.instances[split("_", i)[0]] }
  instance_map_connector       = { for i in local.instance_list_connector : i => var.instances[split("_", i)[0]] }
  instance_map_fas             = { for i in local.instance_list_fas : i => var.instances[split("_", i)[0]] }

  distro = {
    "2019" = data.aws_ami.server_2019.id
    "2022" = data.aws_ami.server_2022.id
  }

}

