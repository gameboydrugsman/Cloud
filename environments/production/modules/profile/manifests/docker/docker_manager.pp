#
class profile::docker::docker_manager (
    $ipaddress    = $::ipaddress,
    $imgfront     = 'pythonwebserv_front',
    $imgback      = 'pythonwebserv_back'
  ){
  require profile::base::base_linux
  firewall { '100 allow docker worker access':
    dport  => [2377],
    proto  => tcp,
    action => accept,
    }
  firewall { '999 drop all other requests':
    action => 'drop',
  }
  file {'/mnt/data/docker_managerip.txt':
    content  =>  $ipaddress,
  }
  file {'/mnt/data/docker_token.txt':
    content  =>  $::facts['docker_token']
  }
  file {'/mnt/data/basehiera.yaml':
    content  =>  "---
classes:
 - profile::base::base_linux"
  }
  file {'/mnt/data/makehieranode.sh':
    ensure  =>  'present',
    content =>  "sshpass -p 'Test2018!' scp -r /home/joris/scripts/basehiera.yaml root@puppet:/etc/puppetlabs/code/environments/production/data/nodes/$(hostname).yaml
    ",
    mode    =>  '0700',
  }

  include 'docker'
  docker::swarm {'cluster_manager':
    init           => true,
    advertise_addr => $ipaddress,
    listen_addr    => $ipaddress,
  }
  file { '/mnt/data/dockerfiles/pythonwebserv_front/Dockerfile':
    ensure  => 'present',
    content => template('profile/docker/docker_file/pythonwebserv_front.erb')
  }
  file { '/mnt/data/dockerfiles/pythonwebserv_back/Dockerfile':
    ensure  => 'present',
    content => template('profile/docker/docker_file/pythonwebserv_back.erb')
  }
  docker::image { $imgfront:
    ensure      =>  'latest',
    docker_file =>  '/mnt/data/dockerfiles/pythonwebserv_front/Dockerfile',
  }
  docker::image { $imgback:
    ensure      =>  'latest',
    docker_file =>  '/mnt/data/dockerfiles/pythonwebserv_back/Dockerfile',
  }
  file { '/mnt/data/compose/docker-compose.yaml':
    ensure  => 'present',
    content => template('profile/docker/docker-compose.yml.erb'),
  }
  class {'docker::compose':
    ensure  => present,
    version => '1.9.0',
  }
  docker::stack { 'web':
    ensure       => present,
    stack_name   => 'web',
    compose_file => '/mnt/data/compose/docker-compose.yaml',
    require      => [Class['docker'], File['/mnt/data/compose/docker-compose.yaml']],
  }
}
