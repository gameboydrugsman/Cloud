# Class: profile::nginx::nginx_base
#
#
class profile::nginx::ddns {
    file { '/home/scripts/transip/lib':
      ensure  => 'directory',
      recurse => true,
      source  => '/mnt/data/scripts/transip/lib/',
    }
    file { '/lib/systemd/system/phpscript.service':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/nginx/updateip.erb'),
    }
    file { '/home/scripts/transip':
      ensure => 'directory'
    }
    file { '/home/scripts/transip/CheckWAN.php':
      ensure  => 'present',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/scripts/phpddns.erb'),
      require => File['/home/scripts/transip'],
    }
    exec { 'myservice-systemd-reload':
      command     => 'systemctl daemon-reload',
      path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
      refreshonly => true,
      require     => File['/lib/systemd/system/phpscript.service'],
    }
    service { 'phpscript':
      ensure  => running,
      require => Exec['myservice-systemd-reload'],
    }
}
