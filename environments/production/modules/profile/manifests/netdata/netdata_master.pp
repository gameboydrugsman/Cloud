# Install the netdata master
class profile::netdata::netdata_master {
  if $::kernel == 'linux' {
    class {'::netdata':
      master               => true,
      remote_master_apikey => '66f2bdc5-58b2-4812-b485-9d3f47f08109',
    }
    netdata::stream {'66f2bdc5-58b2-4812-b485-9d3f47f08109': }
  }
  if $::kernel != 'linux'{
    notice("netdata on ${::osfamily} is not supported")
  }
}
