# For adding a dhcp server
class profile::dhcp::dhcpserver (
  $dnsdomain  = lookup('profile::dhcp::dhcpserver::dnsdomain', {value_type  =>  Tuple,  default_value   =>  ['jojolocal.nl']}),
  ){
  class { 'dhcp':
    service_ensure => running,
    dnsdomain      => $dnsdomain,
    nameservers    => ['192.168.178.100'],
    pxeserver      => 'kickstart.jojo.local',
    pxefilename    => 'pxelinux.0',
  }
}
