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
  archive { '/tmp/somearchive.tar.gz':
    ensure          => present,
    extract         => true,
    extract_path    => '/opt',
    source          => 'https://github.com/gen2brain/keepalived_exporter/releases/download/0.4.0/keepalived_exporter-0.4.0-amd64.tar.gz',
    checksum_verify => false,
    creates         => '/opt/somearchive',
    cleanup         => false,
  }
}
