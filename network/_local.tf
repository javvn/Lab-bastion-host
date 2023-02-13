locals {
  context = yamldecode(file(var.config_file)).context

  common_tags = {
    Project   = local.context.project
    Terraform = local.context.terraform
    Owner     = local.context.owner
    Env       = local.context.env
  }

  vpc_context             = yamldecode(templatefile(var.config_file, local.context)).network.vpc
  subnet_groups_context   = yamldecode(templatefile(var.config_file, local.context)).network.subnet_groups
  security_groups_context = yamldecode(templatefile(var.config_file, local.context)).network.security_groups

  vpc_tags = merge(local.common_tags, {
    Name = local.vpc_context.name
  })
  igw_tags = merge(local.common_tags, {
    Name = "${local.context.name}-igw"
  })
  public_subnet_tags = merge(local.common_tags, {
    Name = local.subnet_groups_context["public"].name
  })
  private_subnet_tags = merge(local.common_tags, {
    Name = local.subnet_groups_context["private"].name
  })
  public_route_table_tags = merge(local.common_tags, {
    Name = "${local.context.name}-public-rt"
  })
  private_route_table_tags = merge(local.common_tags, {
    Name = "${local.context.name}-private-rt"
  })


}