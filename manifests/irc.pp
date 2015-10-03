class tildetown::irc ($hostname, $ircoperpass) inherits charybdis {
  # A lot of this is cargo coded from a PR on puppet-tilde by delfuego, no joke
  # :/

  class { 'charybdis::serverinfo':
    server_name => "${hostname}",
    server_description => 'html + feels = <3',
    network_name => 'tilde.club',
    network_description => 'html + feels = <3',
    max_clients => '1024',
    # TODO WTF
    server_id => '99Z',
    hub => true,
    ssl_cert => '/etc/charybdis/test.cert',
    ssl_private_key => '/etc/charybdis/test.key',
    ssl_dh_params => '/etc/charybdis/dh.pem',
    ssld_count => '1',
    restartpass => 'notused',
    diepass => 'notused',
    # FTW ODOT
  }

  class { 'charybdis::admin':
    adminname => 'tilde node admin',
    description => '<3',
    email => "root@${hostname}",
  }

  charybdis::listen { 'default':
    port => '6665 .. 6669',
    sslport => '6697',
  }

  charybdis::operator { 'root':
    users => [ 'root@127.0.0.0/8' ],
    privset => 'admin',
#    password => $ircoperpass,
    password => 'lololol',
    # TODO WTF
    snomask => '+Zbfkrsuy',
    flags => [ '~encrypted' ],
    # FTW ODOT
  }

  class { 'charybdis::cluster':
    clustername => '*.tilde.club'
  }

  # TODO WTF
  charybdis::auth { 'localhostusers':
    order => '2',
    users => '*@127.0.0.0/8',
    authclass => 'users',
  }

  include charybdis::log
  include charybdis::default::alias
  include charybdis::default::channel
  include charybdis::default::general
  include charybdis::default::modules
  include charybdis::default::privset
  # FTW ODOT

  charybdis::class { 'users':
    ping_time => '2 minutes',
    number_per_ident => '10',
    number_per_ip => '1024',
    number_per_ip_global => '1024',
    cidr_ipv4_bitlen => '24',
    cidr_ipv6_bitlen => '64',
    number_per_cidr => '1024',
    max_number => '3000',
    sendq => '400 kbytes'
  }

  charybdis::class { 'opers':
    ping_time => '5 minutes',
    number_per_ip => '256',
    max_number => '1024',
    sendq => '1 megabyte'
  }

  charybdis::class { 'server':
    ping_time => '5 minutes',
    connectfreq => '5 minutes',
    max_number => '24',
    sendq => '4 megabytes'
  }

  charybdis::exempt { 'default': }
  charybdis::shared { 'default': }

}
