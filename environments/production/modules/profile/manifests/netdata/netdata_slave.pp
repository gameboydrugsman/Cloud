# Configure slave
class profile::netdata::netdata_slave {
  if $::kernel == 'linux' {
    class {'::netdata':
      remote_master        => '192.168.178.101',
      remote_master_apikey => '66f2bdc5-58b2-4812-b485-9d3f47f08109',
    }
  }
  if $::kernel != 'linux'{
    notice("netdata on ${::osfamily} is not supported")
  }
}
