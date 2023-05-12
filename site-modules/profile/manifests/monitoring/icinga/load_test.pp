# Class: profile::monitoring::icinga::load_test
#
#
# do not include on icinga main server itself because it causes some cycles
#
class profile::monitoring::icinga::load_test {
  # Integer[0, 900].each |$x| {
  Integer[0, 10].each |$x| {
    $host_name = "host_${x}.dummy.local"

    @@icinga2::object::host { $host_name:
      address       => '127.0.0.1',
      check_command => 'hostalive',
      host_name     => $host_name,
      import        => ['generic-host'],
      zone          => 'Main',
      target        => "/etc/icinga2/zones.d/Main/${host_name}.conf",
    }
  }
}
