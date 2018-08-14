# a comment
class profile::openvpn::openvpn_server {
    firewall { '100 allow openvpn access':
      dport  => [1194],
      proto  => udp,
      action => accept,
    }
    openvpn::server { 'openvpn_server':
      country      => 'NL',
      province     => 'UT',
      city         => 'Utrecht',
      organization => 'joict.nl',
      email        => 'joris@joict.nl',
      server       => '192.168.178.101 255.255.255.0',
    }
  }
}
