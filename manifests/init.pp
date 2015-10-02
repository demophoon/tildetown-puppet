class tildetown ($users, $hostname) {

  resources { 'user':
    purge => true,
    unless_system_user => true,
  }

  user { 'nate':
    ensure => present,
    groups => ['admin', 'sudo'],
  }

  create_resources(tildetown::user, $users)
}
