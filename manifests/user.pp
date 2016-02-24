define tildetown::user ($pubkey_type = 'ssh-rsa', $shell = '/bin/bash', $pubkey) {
  $username = $title
  $home = "/home/${username}"

  user { $username:
    ensure => present,
    managehome => true,
    groups => ['town'],
    shell => $shell,
  }

  ssh_authorized_key { "${username}_default":
    user => $username,
    type => $pubkey_type,
    key => $pubkey,
    target => "${home}/.ssh/authorized_keys2",
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

  file { "${home}/.weechat":
    ensure => directory,
    owner => $username,
    group => $username,
    replace => false,
  } ->
  file { "${home}/.weechat/irc.conf":
    ensure => file,
    replace => false,
    owner => $username,
    group => $username,
    source => "puppet:///modules/tildetown/weechat_irc.conf",
  }
}
