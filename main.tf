# Define the SSH key for connecting to the instance
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/id_rsa"
}

output "ssh_public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

resource "null_resource" "install_docker" {
  connection {
    type        = "ssh"
    host        = "192.168.0.144"
    user        = "deepthi"
    private_key = file("/home/vijeth/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io python3-pip",
      "pip3 install docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -d -p 1030:80 --name weterraform vijeth2001/cafestatic:v1"
    ]
  }
}
