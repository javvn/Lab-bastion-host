resource "aws_eip" "bastion" {
  instance = module.bastion.public.id
  vpc      = true
  tags     = local.eip_tags

  depends_on = [
    module.bastion
  ]
}