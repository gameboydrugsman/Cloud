variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "admin"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "admin"
}

variable "openstack_password" {
    description = "The password for the Tenant."
    default  = "Test2018!"
}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "http://192.168.178.151/identity/v3"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "linius"
}

variable "tenant_network" {
    description = "The network to be used."
    default  = "private"
}
