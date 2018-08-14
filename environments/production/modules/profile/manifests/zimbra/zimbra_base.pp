class profile::zimbra::zimbra_base {
      firewall { '100 allow http and https access':
         dport  => [80, 443],
         proto  => tcp,
         action => accept,
        }
      firewall { '100 accept smtp access':
         dport  => [25],
         proto  => tcp,
         action => accept,
        }
      firewall { '100 accept admin console access':
         dport  => [7071],
         proto  => tcp,
         action => accept,
    }
}
