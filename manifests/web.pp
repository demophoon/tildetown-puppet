class tildetown::web ($hostname) {
  include nginx

  $www_root = "/var/www/${hostname}"
  $cgi_server = 'http://localhost:5000'

  class { 'letsencrypt':
    email => 'nks@lambdaphil.es',
  }

  file { ['/var/www', $www_root]:
    ensure => directory
  }

  file { "${www_root}/index.html":
    ensure => file,
    replace => false,
    content => ':3',
  }

  letsencrypt::certonly { "${hostname} certs":
    domains       => ["www.${hostname}", $hostname],
    plugin        => 'webroot',
    webroot_paths => [$www_root],
    manage_cron   => true,
  }

  nginx::resource::vhost { $hostname:
    ensure => present,
    use_default_location => false,
    server_name => ["www.${hostname}", $hostname],
    ssl => true,
    ssl_cert => "/etc/letsencrypt/live/www.${hostname}/fullchain.pem",
    ssl_key => "/etc/letsencrypt/live/www.${hostname}/privkey.pem",
    rewrite_to_https => false,
    require => Letsencrypt::Certonly["${hostname} certs"],
  }

  nginx::resource::location { 'main':
    ensure => present,
    vhost => $hostname,
    location => '/',
    www_root => $www_root,
    ssl => true,
  }

  nginx::resource::location { 'userContent':
    ensure => present,
    location => '~ "^/~(.+?)(/.*)?$"',
    vhost => $hostname,
    location_alias => '/home/$1/public_html$2',
    ssl => true,
  }

  nginx::resource::location {['/guestbook', '/helpdesk']:
    proxy => $cgi_server,
    vhost => $hostname,
    ssl => true,
  }

  nginx::resource::location {'/cgi':
    rewrite_rules => ['^/cgi(.*)$ $1 break'],
    proxy => $cgi_server,
    vhost => $hostname,
    ssl => true,
  }

}
