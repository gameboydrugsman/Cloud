# Class: profile::mysql::server
#
#
class profile::mysql::mysql_server {
  class { '::mysql::server':
    root_password           => '0b5c29832d4a421fe29295bd99ff1379 ',
    remove_default_accounts => true,
  }
  mysql::db { 'foremandb':
    user     => 'foreman',
    password => '0b5c29832d4a421fe29295bd99ff1379',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
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
  firewall { '003 Allow inbound mysql':
    dport  => 3306,
    proto  => tcp,
    action => accept,
  }
  firewall { '004 Allow inbound mysql':
    dport  => 3306,
    proto  => udp,
    action => accept,
  }
  firewall { '999 drop all other requests':
    action => 'drop',
  }
}
