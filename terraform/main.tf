data "aws_ami" "latest_packer_ami" {
  depends_on  = [null_resource.build_ami]
  most_recent = true

  filter {
    name   = "name"
    values = ["my-custom-ami-*"] # match your AMI name pattern
  }

  owners = ["self"] # only your account's AMIs
}

resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.latest_packer_ami.id
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-02f995dae74f270c8"
  associate_public_ip_address = true
  depends_on                  = [null_resource.build_ami]
  tags = {
    "name" = "nginx_server"
  }
}
resource "null_resource" "build_ami" {
  provisioner "local-exec" {
    command = "packer build ..\\packer\\"
  }
}