class tildetown::web ($hostname) {
  include nginx

  $www_root = "/var/www/${hostname}"
  $cgi_server = 'http://localhost:5000'


  file { ['/var/www', $www_root]:
    ensure => directory
  }

  file { "${www_root}/index.html":
    ensure => file,
    replace => false,
    content => ':3',
  }

  nginx::resource::vhost { $hostname:
    ensure => present,
    use_default_location => false,
    server_name => ["www.${hostname}", $hostname],
  }

  nginx::resource::location { 'main':
    ensure => present,
    vhost => $hostname,
    location => '/',
    www_root => $www_root,
  }

  nginx::resource::location { 'userContent':
    ensure => present,
    location => '~ "^/~(.+?)(/.*)?$"',
    vhost => $hostname,
    location_alias => '/home/$1/public_html$2',
  }

  nginx::resource::location {['/guestbook', '/helpdesk']:
    proxy => $cgi_server,
    vhost => $hostname,
  }

  nginx::resource::location {'/cgi':
    rewrite_rules => ['^/cgi(.*)$ $1 break'],
    proxy => $cgi_server,
    vhost => $hostname,
  }

}
