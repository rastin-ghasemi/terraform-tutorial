resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                = local.resource_names.vmss
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = local.vm_size
  instances           = var.vm_count
  admin_username      = "adminuser"
  tags                = local.common_tags
  
  # Use filebase64 instead of base64encode for custom data
  custom_data = filebase64("${path.module}/user-data.sh")
  
  # Zonal configuration
  zone_balance = true
  zones        = ["1", "2", "3"]

  # SSH configuration with proper key path
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/azure_vmss_key.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.app.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
    }
  }

  # Upgrade and scaling settings
  overprovision   = false
  upgrade_mode    = "Rolling"
  health_probe_id = azurerm_lb_probe.http.id
  
  # Correct rolling upgrade policy with valid pause time
  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches              = "PT0S"  # Must be 10 minutes or less (PT0S to PT10M)
  }

  # Automatic OS upgrade policy
  automatic_os_upgrade_policy {
    disable_automatic_rollback  = false
    enable_automatic_os_upgrade = true
  }

  # Automatic instance repair policy
  automatic_instance_repair {
    enabled      = true
    grace_period = "PT30M"  # Grace period must be between 10-90 minutes
  }

  # Identity for accessing Key Vault if needed
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vmss.id]
  }

  # Lifecycle policy to ignore changes to instances
  lifecycle {
    ignore_changes = [instances]
  }
}