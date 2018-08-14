# a comment
class profile::home (
  $pack_windows      =  lookup('profile::base::base_windows::pack_windows', {value_type  =>  Tuple,  default_value  =>  ['notepadplusplus','puppet-agent','qbittorrent','winscp','chocolatey','putty','superputty','git','filezilla','teamviewer','windirstat','sysinternals','cpu-z','GoogleChrome','firefox','virtualbox']}),
  ){
  class {'chocolatey':
  }
  -> package { $pack_windows:
    ensure   => latest,
    provider => chocolatey
  }
}
