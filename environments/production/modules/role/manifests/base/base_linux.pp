# Adding Linux base with monitoring, shares and firewall rules
class role::base::base_linux {
  include profile::base::base_linux
  include profile::netdata::netdata_slave
}
