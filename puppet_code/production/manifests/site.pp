# Global Defaults
Exec { path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }

include classifier

# classifier returns $classifier::data hash
$role_config = lookup( { 'name' => 'role', 'default_value' => 'stale' } )

$project_config =
pick_default($::classifier::data['project_config'],'unknown')

$dc_config =
pick_default($::classifier::data['dc_config'],'unknown')

# map organization/location into foreman properties
$discovery_organization=$project_config
#$foreman_location=$dc_config
#$discovery_location=$dc_config

case size($role_config) {
  0: { fail('Please specify any role') }
  default: {}
}

hiera_include('classes')

# update environment in puppet.conf
ini_setting { 'puppet_environment':
  ensure  => present,
  path    => '/etc/puppetlabs/puppet/puppet.conf',
  section => 'agent',
  setting => 'environment',
  value   => $::environment,
}

# puppet agent for new hosts
service { 'puppet':
  ensure => 'running',
  enable => true,
}
