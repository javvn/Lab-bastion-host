module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  for_each = local.security_groups_context

  vpc_id      = module.vpc.vpc_id
  name        = each.value.name
  description = each.value.description

  ingress_with_cidr_blocks = each.value.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = each.value.egress_with_cidr_blocks

  tags = merge(local.common_tags, {
    Name = each.value.name
  })

  depends_on = [
    module.vpc
  ]
}