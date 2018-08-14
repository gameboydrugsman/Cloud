# documented
class profile::mongodb::mongodb_server (
  ){
  class {'mongodb::client':} -> class {'mongodb::server':
    port    => 27018,
    verbose => true,
  } ~> mongodb::db { 'keystone':
      user          => 'joris',
      password_hash => '0b5c29832d4a421fe29295bd99ff1379',
    }
  firewall { '001 Allow inbound SSH':
    dport  => 22,
    proto  => tcp,
    action => accept,
  }
  firewall { '002 Allow inbound SSH':
    dport  => 22,
    proto  => udp,
    action => accept,
  }
  firewall { '003 Allow inbound Mongo':
    dport  => 27018,
    proto  => tcp,
    action => accept,
  }
  firewall { '004 Allow inbound Mongo':
    dport  => 27018,
    proto  => udp,
    action => accept,
  }
  firewall { '999 drop all other requests':
    action => 'drop',
  }
}
