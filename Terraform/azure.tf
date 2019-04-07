# resource "azurerm_resource_group" "myterraformgroup" {
#     name     = "myResourceGroup"
#     location = "North Europe"

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_virtual_network" "myterraformnetwork" {
#     name                = "myVnet"
#     address_space       = ["10.0.0.0/16"]
#     location            = "North Europe"
#     resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_subnet" "myterraformsubnet" {
#     name                 = "mySubnet"
#     resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
#     virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
#     address_prefix       = "10.0.2.0/24"
# }

# resource "azurerm_network_security_group" "myterraformnsg" {
#     name                = "myNetworkSecurityGroup"
#     location            = "North Europe"
#     resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    
#     security_rule {
#         name                       = "SSH"
#         priority                   = 1001
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "22"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#     }

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_public_ip" "saltmaster" {
#     name                         = "saltmaster"
#     location                     = "North Europe"
#     resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
#     allocation_method            = "Dynamic"

#     tags {
#         environment = "Terraform Demo"
#     }
# }
# resource "azurerm_network_interface" "saltmaster" {
#     name                = "saltmaster"
#     location            = "North Europe"
#     resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
#     network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

#     ip_configuration {
#         name                          = "myNicConfiguration"
#         subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
#         private_ip_address_allocation = "Dynamic"
#         public_ip_address_id          = "${azurerm_public_ip.saltmaster.id}"
#     }

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_public_ip" "docker-master01" {
#     name                         = "docker-master01"
#     location                     = "North Europe"
#     resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
#     allocation_method            = "Dynamic"

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_network_interface" "docker-master01" {
#     name                = "docker-master01"
#     location            = "North Europe"
#     resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
#     network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

#     ip_configuration {
#         name                          = "myNicConfiguration"
#         subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
#         private_ip_address_allocation = "Dynamic"
#         public_ip_address_id          = "${azurerm_public_ip.docker-master01.id}"
#     }

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_public_ip" "docker-slave01" {
#     name                         = "docker-slave01"
#     location                     = "North Europe"
#     resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
#     allocation_method            = "Dynamic"

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_network_interface" "docker-slave01" {
#     name                = "docker-slave01"
#     location            = "North Europe"
#     resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
#     network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

#     ip_configuration {
#         name                          = "myNicConfiguration"
#         subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
#         private_ip_address_allocation = "Dynamic"
#         public_ip_address_id          = "${azurerm_public_ip.docker-slave01.id}"
#     }

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "random_id" "randomId" {
#     keepers = {
#         # Generate a new ID only when a new resource group is defined
#         resource_group = "${azurerm_resource_group.myterraformgroup.name}"
#     }
    
#     byte_length = 8
# }

# resource "azurerm_storage_account" "mystorageaccount" {
#     name                = "diag${random_id.randomId.hex}"
#     resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
#     location            = "North Europe"
#     account_replication_type = "LRS"
#     account_tier = "Standard"

#     tags {
#         environment = "Terraform Demo"
#     }
# }

# resource "azurerm_virtual_machine" "saltmaster" {
#     name                  = "saltmaster"
#     location              = "North Europe"
#     resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
#     network_interface_ids = ["${azurerm_network_interface.saltmaster.id}"]
#     vm_size               = "Standard_DS1_v2"

#     storage_os_disk {
#         name              = "saltmaster"
#         caching           = "ReadWrite"
#         create_option     = "FromImage"
#         managed_disk_type = "Premium_LRS"
#     }

#     storage_image_reference {
#         publisher = "OpenLogic"
#         offer     = "CentOS"
#         sku       = "7.5"
#         version   = "latest"
#     }

#     os_profile {
#         computer_name  = "saltmaster"
#         admin_username = "azureuser"
# 		admin_password = "Password1234!"
# 	}

# 	os_profile_linux_config {
# 		disable_password_authentication = false
#     }
# #
# #	os_profile_linux_config {
# #    disable_password_authentication = true
# #    ssh_keys {
# #      path     = "/home/azureuser/.ssh/authorized_keys"
# #      key_data = "${file("/AZURE/public key")}"
# #    }
# #  }

#     boot_diagnostics {
#         enabled     = "true"
#         storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
#     }
	
#     tags {
#         environment = "Terraform Demo"
# 	}
	
# }

# resource "azurerm_virtual_machine_extension" "saltmaster" {
#   name                 = "saltmaster"
#   location             = "North Europe"
#   resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.saltmaster.name}"
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "sudo yum install -y git && sudo git clone https://github.com/jorisdejosselin/salt_cloud.git /srv/salt/  && sudo curl -L https://bootstrap.saltstack.com -o install_salt.sh && sudo sh install_salt.sh -P -M -L"
#     }
# SETTINGS

#   tags = {
#     environment = "Terraform Demo"
#   }
# }

# resource "azurerm_virtual_machine" "docker-master01" {
#     name                  = "docker-master01"
#     location              = "North Europe"
#     resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
#     network_interface_ids = ["${azurerm_network_interface.docker-master01.id}"]
#     vm_size               = "Standard_DS1_v2"

#     storage_os_disk {
#         name              = "docker-master01"
#         caching           = "ReadWrite"
#         create_option     = "FromImage"
#         managed_disk_type = "Premium_LRS"
#     }

#     storage_image_reference {
#         publisher = "OpenLogic"
#         offer     = "CentOS"
#         sku       = "7.5"
#         version   = "latest"
#     }

#     os_profile {
#         computer_name  = "docker-master01"
#         admin_username = "azureuser"
# 		admin_password = "Password1234!"
# 	}

# 	os_profile_linux_config {
# 		disable_password_authentication = false
#     }

#     boot_diagnostics {
#         enabled     = "true"
#         storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
#     }
	
#     tags {
#         environment = "Terraform Demo"
# 	}
	
# }

# resource "azurerm_virtual_machine_extension" "docker-master01" {
#   name                 = "docker-master01"
#   location             = "North Europe"
#   resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.docker-master01.name}"
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "sudo yum install -y git && curl -L https://bootstrap.saltstack.com -o install_salt.sh && sudo sh install_salt.sh -P -A saltmaster"
#     }
# SETTINGS

#   tags = {
#     environment = "Terraform Demo"
#   }
# }

# resource "azurerm_virtual_machine" "docker-slave01" {
#     name                  = "docker-slave01"
#     location              = "North Europe"
#     resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
#     network_interface_ids = ["${azurerm_network_interface.docker-slave01.id}"]
#     vm_size               = "Standard_DS1_v2"

#     storage_os_disk {
#         name              = "docker-slave01"
#         caching           = "ReadWrite"
#         create_option     = "FromImage"
#         managed_disk_type = "Premium_LRS"
#     }

#     storage_image_reference {
#         publisher = "OpenLogic"
#         offer     = "CentOS"
#         sku       = "7.5"
#         version   = "latest"
#     }

#     os_profile {
#         computer_name  = "docker-slave01"
#         admin_username = "azureuser"
# 		admin_password = "Password1234!"
# 	}

# 	os_profile_linux_config {
# 		disable_password_authentication = false
#     }

#     boot_diagnostics {
#         enabled     = "true"
#         storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
#     }
	
#     tags {
#         environment = "Terraform Demo"
# 	}
	
# }

# resource "azurerm_virtual_machine_extension" "docker-slave01" {
#   name                 = "docker-slave01"
#   location             = "North Europe"
#   resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.docker-slave01.name}"
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "sudo yum install -y git && curl -L https://bootstrap.saltstack.com -o install_salt.sh && sudo sh install_salt.sh -P -A saltmaster"
#     }
# SETTINGS

#   tags = {
#     environment = "Terraform Demo"
#   }
# }
