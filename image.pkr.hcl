packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = env("AZURE_SUBSCRIPTION_ID")
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  sensitive   = true
  type        = string
  default     = env("AZURE_TENANT_ID")
}

variable "client_id" {
  description = "Azure Client ID"
  sensitive   = true
  type        = string
  default     = env("AZURE_CLIENT_ID")
}

variable "client_secret" {
  description = "Azure Client Secret"
  sensitive   = true
  type        = string
  default     = env("AZURE_CLIENT_SECRET")
}

variable "dry_run" {
  description = "Dry Run"
  type        = bool
  default     = false
}

variable "version" {
  description = "Version"
  type        = string
}

source "azure-arm" "image" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"

  location                          = "germanywestcentral"
  managed_image_name                = "fastify-hello-world-${var.version}"
  managed_image_resource_group_name = "fastify-hello-world"
  os_type                           = "Linux"
  vm_size                           = "Standard_B2ats_v2"
  skip_create_image                 = var.dry_run

  azure_tags = {
    application = "fastify-hello-world"
    version     = var.version
  }
}

build {
  sources = ["source.azure-arm.image"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"

    inline = [
      "apt-get update -y",
      "apt-get install -y curl",
      "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -",
      "apt-get install -y nodejs",
      "which node npm",
      "mkdir /tmp/fastify-hello-world",
      "chmod 777 /tmp/fastify-hello-world",
    ]

    inline_shebang = "/bin/sh -x"
  }

  provisioner "file" {
    source      = "src"
    destination = "/tmp/fastify-hello-world"
  }

  provisioner "file" {
    source      = "package.json"
    destination = "/tmp/fastify-hello-world/package.json"
  }

  provisioner "file" {
    source      = "package-lock.json"
    destination = "/tmp/fastify-hello-world/package-lock.json"
  }

  provisioner "file" {
    source      = "systemd/fastify-hello-world.service"
    destination = "/tmp/fastify-hello-world.service"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"

    inline = [
      "cp -r /tmp/fastify-hello-world /opt",
      "cd /opt/fastify-hello-world",
      "ls -al",
      "npm ci --omit=dev",
      "useradd webapp",
      "chown -R webapp:webapp /opt/fastify-hello-world",
      "cp /tmp/fastify-hello-world.service /etc/systemd/system",
      "systemctl daemon-reload",
      "systemctl enable fastify-hello-world",
      "systemctl start fastify-hello-world",
      "systemctl status fastify-hello-world",
      "systemctl stop fastify-hello-world",
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]

    inline_shebang = "/bin/sh -x"
  }
}
