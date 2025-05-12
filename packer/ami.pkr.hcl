packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "amazon_linux" {
  ami_name       = "amazon_linux"
  instance_type  = "t2.micro"
  region         = "ap-south-1"
  source_ami     = "ami-062f0cc54dbfd8ef1"
  ssh_username     = "ec2-user"
  ssh_timeout      = "10m"

  #  launch_block_device_mappings {
  #   device_name = "/dev/sda1"
  #   volume_size = 50
  #   volume_type = "gp2"
  #   delete_on_termination = true
  # }
}

build {
  sources = ["source.amazon-ebs.amazon_linux"]
  provisioner "shell" {
    inline = [
       "sudo yum update -y",
      "sudo yum install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }

  # provisioner "powershell" {
  #   inline = [
  #     "Write-Host 'Running Windows provisioning script...'",
  #     "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force",
  #     "Write-Host 'Installing IIS...'",
  #     "Install-WindowsFeature -Name Web-Server -IncludeManagementTools"
  #   ]
  # }
}