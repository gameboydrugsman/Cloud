resource "openstack_blockstorage_volume_v1" "Mongo" {
  name     = "Mongo"
  size     = 10
  image_id = "Mongo"
}

resource "openstack_compute_instance_v2" "mongo" {
  name            = "mongo"
  flavor_name       = "right"
  key_pair        = "test"
  security_groups = ["default,Mongo"]

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v1.Mongo.id}"
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
  }

  network {
    name = "private"
  }
}

resource "openstack_compute_instance_v2" "backend" {
  name            = "backend"
  image_name        = "Python_web"
  flavor_id      = "1"
  key_pair        = "test"
  security_groups = ["default","HTTP"]

  metadata {
    this = "that"
  }

  network {
    name = "private"
  }
}

resource "openstack_compute_instance_v2" "web" {
  name            = "web"
  image_name        = "Python_web"
  flavor_id       = "1"
  key_pair        = "test"
  security_groups = ["default","HTTP"]

  metadata {
    this = "that"
  }

  network {
    name = "private"
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.web.id}"
}
