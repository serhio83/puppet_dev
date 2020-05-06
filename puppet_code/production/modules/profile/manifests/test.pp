# profile::test
class profile::test (
  Hash $somehash = {}
) {

  $somehash.each |$key, $value| {
    file { "/tmp/tmp_${key}":
      content => "${key}: ${value}\n",
      owner   => 'root',
      group   => 'root',
      mode    => '0644'
    }
  }

  file { '/tmp/tmp_Z':
    content => "${somehash}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }
}
