#
class role::docker::docker_worker {
  if $::facts['kernel'] == 'linux' {
    include profile::base::base_linux
    include profile::docker::docker_worker
    }
  else {
    warning("This role is not supported for ${::facts[kernel]}")
  }
}
