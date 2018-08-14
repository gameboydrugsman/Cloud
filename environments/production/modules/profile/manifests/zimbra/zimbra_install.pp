class profile::zimbra::zimbra_install (
  $domain = 'jorisdejosselindejong.nl'
  ){
  file { '/home/joris/Downloads/zimbra_install.tgz':
    ensure =>  present,
    owner  =>  'joris',
    group  =>  'joris',
    source =>  'puppet:///modules/zimbra/zcs-8.8.8_GA_2009.UBUNTU16_64.20180322150747.tgz',
    }
  archive { '/home/joris/Downloads/zimbra_installed':
    ensure        => present,
    extract       => true,
    extract_path  => '/tmp',
    source        => 'puppet:///modules/zimbra/zcs-8.8.8_GA_2009.UBUNTU16_64.20180322150747.tgz',
    checksum      => '2ca09f0b36ca7d71b762e14ea2ff09d5eac57558',
    checksum_type => 'sha1',
    creates       => '/tmp/zimbra',
    cleanup       => true,
  }
}