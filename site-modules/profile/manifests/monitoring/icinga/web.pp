# Class: profile::monitoring::icinga::web
#
#
class profile::monitoring::icinga::web {
  include icinga::repos
  include icingaweb2
  include icingaweb2::module::monitoring
}
