resource "null_resource" "cluster" {
  count = var.environment == "uat" ? 3 : 1
  provisioner "file" {
    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("devops-prod-key.pem")
      host        = element(aws_instance.public-server.*.public_ip, count.index)
    }
  }
provisioner "remote-exec" { 
    inline = [
      "chmod +x /tmp/user-data.sh",
      "sudo /tmp/user-data.sh",
      "sudo apt-get update",
      "sudo apt-get install jq unzip -y",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("devops-prod-key.pem")
      host        = element(aws_instance.public-server.*.public_ip, count.index)
    }
}
}
