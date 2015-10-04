class tildetown ($users, $hostname) {

  File { backup => false, }

  resources { 'user':
    purge => true,
    unless_system_user => true,
  }

  group { 'town':
    ensure => present,
  }

  user { 'ubuntu':
    ensure => present,
  }

  user { 'wiki':
    ensure => present,
    managehome => true
  }

  file { '/home/wiki':
    ensure => directory,
    owner => 'wiki',
    group => 'town',
    mode => '0775',
  }

  user { 'nate':
    ensure => present,
    groups => ['admin', 'sudo'],
  }

  file { '/usr/local/bin/motd':
    ensure => present,
    mode => '775',
    content => "#!/bin/sh\ncat /etc/motd",
    require => File['/etc/motd'],
  }

  file { '/usr/local/bin/irc':
    ensure => present,
    mode => '775',
    source => "puppet:///modules/tildetown/irc",
  }

  file { '/usr/local/bin/prosaic':
    ensure => present,
    mode => '775',
    source => 'puppet:///modules/tildetown/prosaic',
  }

  file { '/etc/motd':
    ensure => file,
    owner => root,
    group => root,
    mode => '0665',
    source => "puppet:///modules/tildetown/motd",
  }

  create_resources(tildetown::user, $users)
}
