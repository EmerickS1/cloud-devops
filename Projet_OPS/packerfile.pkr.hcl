variable "project_id" {
  type    = string
  default = "cloud-devops-447407"
}

variable "region" {
  type    = string
  default = "europe-west9"
}

# Configure Packer builder for Google Cloud
source "googlecompute" "ubuntu-lamp" {
  project_id        = "cloud-devops-447407"
  zone              = "europe-west9-b"
  machine_type      = "e2-medium"
  source_image_family = "ubuntu-2004-lts"
  image_name        = "ubuntu-lamp-{{timestamp}}"
  image_family      = "lamp-stack"
  ssh_username      = "root"
}

# Provisioner for using Ansible
build {
  sources = ["source.googlecompute.ubuntu-lamp"]

  provisioner "ansible" {
    playbook_file = "playbook.yml"
    extra_arguments = ["-vvvv"]
  }
}

packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}
