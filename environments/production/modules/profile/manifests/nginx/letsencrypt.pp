# Class: profile::nginx::letsencrypt
#
#
class profile::nginx::letsencrypt {
  # file {'/mnt/nginx':
  #   ensure => 'directory',
  # }
  # file { '/securedir/.sambacredentialsfilenginx':
  #   ensure  => present,
  #   owner   => root,
  #   group   => root,
  #   mode    => '0644',
  #   content => 'username=certbot\npassword=Test2018!\ndomain=WORKGROUP',
  # }
  # mount {'/mnt/nginx':
  #   ensure  => 'mounted',
  #   device  => '//192.168.178.1/nginx',
  #   atboot  => true,
  #   fstype  => 'cifs',
  #   options => 'auto,credentials=/securedir/.sambacredentialsfilenginx',
  #   require => [File['/securedir/.sambacredentialsfilenginx'],File['/mnt/nginx']]
  # }
  letsencrypt::certonly{ 'domains':
    domains              => ['router.joict.nl', 'mail.jorisdejosselindejong.nl'],
    manage_cron          => false,
    cron_before_command  => 'sshpass -p "Test2018!" ssh root@192.168.178.1 && service nginx stop',
    cron_success_command => 'sshpass -p "Test2018!" ssh root@192.168.178.1 && /bin/systemctl reload nginx.service',
    suppress_cron_output => true,
    # require              => Mount['/mnt/nginx'],
  }
}
