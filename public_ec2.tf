
resource "aws_instance" "public-server" {
  count = var.environment == "uat" ? 3 : 1
  #count                       = length(var.public_cidr_block)
  ami                         = lookup(var.amis, var.region_name)
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name        = "${var.vpc_tag_name}-publib-server-${count.index + 1}"
    service     = local.service
    owner       = local.owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }

}
