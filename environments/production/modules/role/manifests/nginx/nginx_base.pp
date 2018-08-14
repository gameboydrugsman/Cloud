# For adding nginx to home
class role::nginx::nginx_base {
  include profile::base::base_linux
  include profile::nginx::nginx_base
}
