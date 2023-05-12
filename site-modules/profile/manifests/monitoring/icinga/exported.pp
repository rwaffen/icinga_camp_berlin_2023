# Class: profile::monitoring::icinga::exported
#
# @param address
# @param address6
# @param check_command
# @param endpoint_name
# @param export_endpoint
# @param host_name
# @param host_template
# @param is_main
# @param parent_zone
# @param target_zone
# @param vars
#
class profile::monitoring::icinga::exported (
  Boolean $is_main         = false,
  Boolean $export_endpoint = true,
  String $parent_zone      = 'Main',
  String $target_zone      = 'Main',
  Hash $vars               = {},
  String $address          = fact('networking.ip'),
  String $address6         = fact('networking.ip6'),
  String $host_name        = fact('networking.fqdn'),
  String $endpoint_name    = fact('networking.fqdn'),
  Array $host_template     = ['generic-host'],
  String $check_command    = 'hostalive'
) {
  unless $is_main {
    if $export_endpoint {
      $exported_vars = merge($vars, { 'client_endpoint' => $endpoint_name })
    } else {
      $exported_vars = $vars
    }

    @@icinga2::object::host { $host_name:
      address       => $address,
      address6      => $address6,
      check_command => $check_command,
      host_name     => $host_name,
      import        => $host_template,
      vars          => $exported_vars,
      zone          => $parent_zone,
      target        => "/etc/icinga2/zones.d/${target_zone}/${host_name}.conf",
    }

    if $export_endpoint {
      @@icinga2::object::endpoint { $host_name:
        endpoint_name => $host_name,
        host          => $address,
      }

      @@icinga2::object::zone { $host_name:
        endpoints => [$endpoint_name,],
        parent    => $parent_zone,
      }
    }
  }
}
