# For adding a pxe servers
class profile::kickstart::pxeserver (
  $package_deb = ['apache2','tftpd-hpa','inetutils-inetd']
){
  if $::osfamily == 'Debian' {
    package { $package_deb:
      ensure   => installed,
      provider => apt
    }
  }
}
