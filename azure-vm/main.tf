resource "azurerm_linux_virtual_machine" "dev-demo-linux-vm" {
  name                            = "dev-demo-linux-vm"
  resource_group_name             = azurerm_resource_group.dev-demo-resource-group.name
  location                        = azurerm_resource_group.dev-demo-resource-group.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/azure_vm_key.pub")
  }
  network_interface_ids = [azurerm_network_interface.dev-demo-nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "dev-demo-nic" {
  name                = "dev-demo-nic"
  location            = azurerm_resource_group.dev-demo-resource-group.location
  resource_group_name = azurerm_resource_group.dev-demo-resource-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev-demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev-demo-public-ip.id
  }
  depends_on = [azurerm_network_security_group.dev-demo-nsg, azurerm_public_ip.dev-demo-public-ip]
}


resource "azurerm_public_ip" "dev-demo-public-ip" {
  name                = "dev-demo-public-ip"
  location            = azurerm_resource_group.dev-demo-resource-group.location
  resource_group_name = azurerm_resource_group.dev-demo-resource-group.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "dev-demo-nsg" {
  name                = "dev-demo-nsg"
  location            = azurerm_resource_group.dev-demo-resource-group.location
  resource_group_name = azurerm_resource_group.dev-demo-resource-group.name
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "Terraform Demo"
  }
}
resource "azurerm_network_interface_security_group_association" "dev-demo-nsg-association" {
  network_interface_id      = azurerm_network_interface.dev-demo-nic.id
  network_security_group_id = azurerm_network_security_group.dev-demo-nsg.id
  depends_on                = [azurerm_network_interface.dev-demo-nic, azurerm_network_security_group.dev-demo-nsg]
}


