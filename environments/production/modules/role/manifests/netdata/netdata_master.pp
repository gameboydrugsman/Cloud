# Create Netdata master
class role::netdata::netdata_master {
  if $::kernel == 'linux'{
    include ::profile::netdata::netdata_master
    include ::profile::base::base_linux
  }
}
