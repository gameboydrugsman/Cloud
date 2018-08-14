# Creating a docker manager
class role::docker::docker_manager {
  include profile::docker::docker_manager
  include role::base::base_linux
}
