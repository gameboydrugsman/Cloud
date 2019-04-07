resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public"
  address = "192.168.178.15"
}

resource "openstack_compute_floatingip_associate_v2" "floatip_2" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_2.address}"
  instance_id = "${openstack_compute_instance_v2.docker-master.id}"
}

resource "openstack_compute_instance_v2" "docker-master" {
  name            = "docker-master"
  image_name        = "centos"
  flavor_name       = "ds1G"
  key_pair        = "linius-openstack"
  security_groups = ["default"]

  network {
    name = "private"
  }
}

resource "null_resource" "provision_docker-master" {
  depends_on = ["openstack_compute_floatingip_associate_v2.floatip_2"]
  connection {
    user        = "centos"
    timeout = "1m"
    host        = "${openstack_networking_floatingip_v2.floatip_2.address}"
    private_key = "${file("/home/joris/openstack_keys/id_rsa-openstack")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -L https://bootstrap.saltstack.com -o install_salt.sh && sudo sh install_salt.sh -P -A 192.168.178.100",
    ]
  }
}

variable "count" {
  default = 3
}

resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "public"
}

resource "openstack_compute_instance_v2" "docker-slave01" {
  name            = "docker-slave01"
  image_name        = "centos"
  flavor_name       = "ds1G"
  key_pair        = "linius-openstack"
  security_groups = ["default"]

  network {
    name = "private"
  }
}
resource "openstack_compute_floatingip_associate_v2" "floatip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  instance_id = "${openstack_compute_instance_v2.docker-slave01.id}"
}

resource "null_resource" "provision_docker-slave01" {
  #depends_on = ["openstack_compute_floatingip_associate_v2.floatip_1"]
  connection {
    user        = "centos"
    timeout = "1m"
    host        = "${openstack_networking_floatingip_v2.floatip_1.address}"
    private_key = "${file("/home/joris/openstack_keys/id_rsa-openstack")}"
    agent = "false"
  }
    provisioner "remote-exec" {
    inline = [
      "curl -L https://bootstrap.saltstack.com -o install_salt.sh && sudo sh install_salt.sh -P -A 192.168.178.100",
    ]
  }
}
# resource "openstack_networking_floatingip_v2" "floatip_3" {
#   pool = "public"
# }

# resource "openstack_compute_instance_v2" "docker-slave02" {
#   name            = "docker-slave02"
#   image_name        = "centos"
#   flavor_name       = "ds1G"
#   key_pair        = "linius-openstack"
#   security_groups = ["default"]

#   network {
#     name = "private"
#   }
# }
# resource "openstack_compute_floatingip_associate_v2" "floatip_3" {
#   floating_ip = "${openstack_networking_floatingip_v2.floatip_3.address}"
#   instance_id = "${openstack_compute_instance_v2.docker-slave02.id}"
# }

# resource "null_resource" "provision_docker-slave02" {
#   #depends_on = ["openstack_compute_floatingip_associate_v2.floatip_1"]
#   connection {
#     user        = "centos"
#     timeout = "1m"
#     host        = "${openstack_networking_floatingip_v2.floatip_3.address}"
#     private_key = "${file("/home/joris/openstack_keys/id_rsa-openstack")}"
#     agent = "false"
#   }
#     provisioner "remote-exec" {
#     inline = [
#       "curl -L https://bootstrap.saltstack.com -o install_salt.sh && sudo sh install_salt.sh -P -A 192.168.178.100",
#     ]
#   }
# }
