# Class: profile::nginx::nginx_ddns
# This class adds a ddns script for transip
#
class role::nginx::nginx_ddns {
  include profile::base::base_linux
  include profile::nginx::ddns
}
