locals {
  common_tags = {
    Environment = var.environment
    Project    = "WebApp"
    ManagedBy  = "Terraform"
  }

  resource_names = {
    vnet         = "${var.resource_prefix}-vnet"
    app_subnet   = "${var.resource_prefix}-app-subnet"
    mgmt_subnet  = "${var.resource_prefix}-mgmt-subnet"
    nsg          = "${var.resource_prefix}-nsg"
    vmss         = "${var.resource_prefix}-vmss"
    lb           = "${var.resource_prefix}-lb"
    public_ip    = "${var.resource_prefix}-pip"
    ssl_cert     = "${var.resource_prefix}-ssl-cert"
  }

  vm_size = lookup({
    dev   = "Standard_B1s"
    stage = "Standard_B2s"
    prod  = "Standard_B2ms"
  }, var.environment, "Standard_B1s")

  scaling = {
    min = 2
    max = 5
    scale_out = 80  # Scale out when CPU > 80%
    scale_in  = 10  # Scale in when CPU < 10%
  }
}