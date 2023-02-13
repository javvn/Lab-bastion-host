output "context" {
  value = local.context
}

output "common_tags" {
  value = local.common_tags
}

output "network" {
  value = {
    vpc = {
      id = module.vpc.vpc_id
      name = module.vpc.name
      cidr_block = module.vpc.vpc_cidr_block
      subnet_groups = {
        public = {
          id = module.vpc.public_subnets
          arn = module.vpc.public_subnet_arns
          cidr_blocks = module.vpc.public_subnets_cidr_blocks
        }
        private = {
          id = module.vpc.private_subnets
          arn = module.vpc.private_subnet_arns
          cidr_blocks = module.vpc.private_subnets_cidr_blocks
        }
      }
    }
    security_groups = module.sg
  }
}
