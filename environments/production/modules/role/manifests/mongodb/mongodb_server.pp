class role::mongodb::mongodb_server {
  if $::facts[kernel] == windows {
    include  profile::base::base_windows
    }
  if $::facts[kernel] == linux {
    include profile::netdata::netdata_slave
    include profile::base::base_linux
    }
  include profile::mongodb::mongodb_server
}
