# Add some things for Puppetmaster now only firewall
class role::puppet::puppetmaster {
  include profile::puppet::puppetmaster
  include profile::base::base_linux
}
