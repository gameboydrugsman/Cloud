# Add some things for Puppetmaster now only firewall
class profile::puppet::puppetmaster (
  $dir   = '/etc/scripts/deployment/__main__.py',
  $dirsh = '/etc/scripts/deployment/deploy.sh'
){
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
  firewall { '003 Allow Puppet access':
    dport  => 8140,
    proto  => tcp,
    action => accept,
  }
  firewall { '100 allow api access':
    dport  => [8081],
    proto  => tcp,
    action => accept,
    }
  firewall { '200 allow api access':
    dport  => [8081],
    proto  => udp,
    action => accept,
    }
  firewall { '999 drop all other requests':
    action => 'drop',
  }
  file { '/etc/scripts/deployment/':
    ensure => 'directory'
  }
  file { '/etc/systemd/system/deploy.service':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/puppetmaster/deploy.service.erb'),
    }
  file { "${dirsh}":
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/puppetmaster/deploy.sh.erb'),
    }
  file { "${dir}":
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/puppetmaster/deploy.py.erb'),
    }
  exec { 'myservice-systemd-reload':
      command     => 'systemctl daemon-reload',
      path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
      refreshonly => true,
      require     => [ File['/etc/systemd/system/deploy.service'], File['/etc/scripts/deployment/deploy.sh'] , File['/etc/scripts/deployment/__main__.py'] ]
    }
  service { 'deploy':
      ensure  => running,
      require => Exec['myservice-systemd-reload'],
    }
}
