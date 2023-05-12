# Class: profile::monitoring::icinga::server
#
# @param defaults
# @param objects
# @param zones_d
#
class profile::monitoring::icinga::server (
  Hash $defaults = {},
  Hash $objects  = {},
  Hash $zones_d  = {},
) {
  include icinga::repos
  include mysql::server
  include icinga2

  case fact('os.family') {
    'Debian': {
      $package_name = 'monitoring-plugins'
      $icinga_user  = 'nagios'
    }
    'RedHat': {
      package { 'epel-release':
        ensure => 'installed',
        notify => Exec['makecache'],
      }

      exec { 'makecache':
        command     => '/bin/dnf makecache',
        refreshonly => true,
      }

      $package_name = 'nagios-plugins-all'
      $icinga_user  = 'icinga'
    }
    default: {}
  }

  ensure_packages([$package_name], { ensure => 'latest' })

  file { '/etc/icinga2/zones.d':
    ensure  => directory,
    mode    => '0750',
    owner   => $icinga_user,
    group   => $icinga_user,
    recurse => true,
    purge   => true,
    force   => true,
  }

  $zones_d.each |$zone, $settings| {
    file { $zone:
      *       => $settings,
      owner   => $icinga_user,
      group   => $icinga_user,
      require => File['/etc/icinga2/zones.d',],
    }
  }

  $objects.each |String $object_type, Hash $content| {
    $content.each |String $object_name, Hash $object_config| {
      ensure_resource(
        $object_type,
        $object_name,
        deep_merge($defaults[$object_type], $object_config)
      )
    }
  }

  Icinga2::Object::Endpoint <<| |>> {}
  Icinga2::Object::Host     <<| |>> {}
  Icinga2::Object::Zone     <<| |>> {}
}
