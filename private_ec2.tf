
# resource "aws_instance" "private-server" {
#   count                       = length(var.private_cidr_block)
#   ami                         = lookup(var.amis, var.region_name)
#   instance_type               = "t2.micro"
#   key_name                    = var.key_name
#   subnet_id                   = element(aws_subnet.private-subnet-terraform.*.id, count.index + 1)
#   vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
#   associate_public_ip_address = false
#   tags = {
#     Name        = "${var.vpc_tag_name}-private-server-${count.index + 1}"
#     service     = local.service
#     owner       = local.owner
#     costcenter  = local.costcenter
#     TeamDL      = local.TeamDL
#     environment = var.environment
#   }
#   user_data = <<-EOF
# #!/bin/bash
# sudo apt-get update
# sudo apt-get install -y nginx
# sudo apt install git -y
# sudo git clone https://github.com/saikiranpi/SecOps-game.git
# sudo rm -rf /var/www/html/*
# sudo cp -r SecOps-game/index.html /var/www/html/index.html
# echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
# sudo systemctl start nginx
# sudo systemctl enable nginx
# EOF
# }
