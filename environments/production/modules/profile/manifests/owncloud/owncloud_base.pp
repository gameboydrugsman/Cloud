# Voor mij owncloud server
class profile::owncloud::owncloud_base {
    firewall { '100 allow http and https access':
      dport  => [80, 443],
      proto  => tcp,
      action => accept,
        }
}
