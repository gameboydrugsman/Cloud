#documented
class profile::base::base_windows (
  $pack_windows      =  lookup('profile::base::base_windows::pack_windows', {value_type  =>  Tuple,  default_value  =>  ['notepadplusplus','puppet-agent','qbittorrent','winscp','chocolatey','putty','curl']}),
  ){
  class {'chocolatey':
  }
  -> package { $pack_windows:
    ensure   => latest,
    provider => chocolatey
  }
}
