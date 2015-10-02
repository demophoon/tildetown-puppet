define tilde::user ($pubkey_type = 'ssh-rsa', $pubkey) {
  $username = $title
  $home = "/home/${username}"
  $channel = $tilde::irc::channel

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

  file { "${username}/.ssh":
    path => "/home/${username}/.ssh",
    ensure => directory,
    owner => $username,
    group => $username,
  }

  # TODO weechat

  #file { "/home/${username}/.twurlrc":
  #  ensure => file,
  #  owner => $username,
  #  group => $username,
  #  replace => false,
  # TODO not using a module...i hope
  #  source => "puppet:///modules/tilde/twurlrc",
  #}
}
