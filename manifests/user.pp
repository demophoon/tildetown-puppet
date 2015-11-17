define tildetown::user ($pubkey_type = 'ssh-rsa', $pubkey) {
  $username = $title
  $home = "/home/${username}"

  $fix_shell = "/bin/grep ${username} /etc/passwd | /bin/grep :$ && chsh ${username} -s /bin/bash"

  user { $username:
    ensure => present,
    managehome => true,
    groups => ['town'],
  }

  ssh_authorized_key { "${username}_default":
    user => $username,
    type => $pubkey_type,
    key => $pubkey,
    target => "${home}/.ssh/authorized_keys2",
  }
  exec { "${fix_shell}":
    returns => [0,1],
    # TODO this is a stopgap; having this here means that we have to run this
    # always with apply. that's fine for now, but maybe not in the future.
  }

  file { "${username}/.ssh":
    path => "${home}/.ssh",
    ensure => directory,
    owner => $username,
    group => $username,
  }

  file { "${home}/.vimrc":
    ensure => file,
    replace => false,
    owner => $username,
    group => $username,
    source => 'puppet:///modules/tildetown/vimrc',
  }

  file { "${home}/public_html":
    ensure => directory,
    owner => $username,
    group => $username,
    replace => false,
  } ->
  file { "${home}/public_html/index.html":
    ensure => present,
    owner => $username,
    group => $username,
    replace => false,
    source => 'puppet:///modules/tildetown/index.html',
  }

  # TODO move secrets to common.yaml
  file { "/home/${username}/.twurlrc":
    ensure => file,
    owner => $username,
    group => $username,
    replace => false,
    source => "puppet:///modules/tildetown/twurlrc",
  }
}
