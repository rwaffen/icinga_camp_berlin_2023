# Class: profile::monitoring::icinga::agent
#
#
class profile::monitoring::icinga::agent {
  include icinga2
  include icinga2::feature::api
  include icinga2::feature::checker
  include icinga2::feature::mainlog
}
