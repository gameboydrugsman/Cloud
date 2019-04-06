provider "openstack" {
  user_name = "${var.openstack_user_name}"
  tenant_name = "${var.openstack_tenant_name}"
  password  = "${var.openstack_password}"
  auth_url  = "${var.openstack_auth_url}"
  domain_name = "Default"
  project_domain_name = "demo"
}

# provider "azurerm" {
#   # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
#   version = "~> 1.0"
# }
