resource "azurerm_virtual_network" "dev-demo-vnet" {
  name                = "dev-demo-vnet"
  location            = azurerm_resource_group.dev-demo-resource-group.location
  resource_group_name = azurerm_resource_group.dev-demo-resource-group.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "dev-demo-subnet" {
  name                 = "dev-demo-subnet"
  resource_group_name  = azurerm_resource_group.dev-demo-resource-group.name
  virtual_network_name = azurerm_virtual_network.dev-demo-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "dev-demo-private-ip" {
  name                 = "dev-demo-private-ip"
  resource_group_name  = azurerm_resource_group.dev-demo-resource-group.name
  virtual_network_name = azurerm_virtual_network.dev-demo-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_route_table" "dev-demo-route-table" {
  name                = "dev-demo-route-table"
  location            = azurerm_resource_group.dev-demo-resource-group.location
  resource_group_name = azurerm_resource_group.dev-demo-resource-group.name
  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "dev-demo-route-table-association" {
  subnet_id      = azurerm_subnet.dev-demo-subnet.id
  route_table_id = azurerm_route_table.dev-demo-route-table.id
}
