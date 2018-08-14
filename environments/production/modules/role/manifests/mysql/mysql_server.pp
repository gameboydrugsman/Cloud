# Class: role::mysql::mysql_server
#
#
class role::mysql::mysql_server {
  include profile::base::base_linux
  include profile::mysql::mysql_server
}
