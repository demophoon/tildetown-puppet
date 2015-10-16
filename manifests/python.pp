class tildetown::python ($mailgun_url, $mailgun_key, $trello_email, $guestbook_dir) {

  $scripts = '/usr/local/tildetown-scripts'
  $venv = '/usr/local/virtualenvs/tildetown'
  $python_packages = ['prosaic', 'hy', 'sh', 'bpython', 'gunicorn', 'pyhocon', 'Flask', 'tildetown', 'irc']

  file { $scripts:
    ensure => link,
    target => '/home/nate/tildetown-scripts',
    } ->
    file { "${scripts}/tildetown/cfg.conf":
      group => 'admin',
      ensure => file,
      content => template('tildetown/cfg.conf.erb'),
      } ->
      file { $guestbook_dir:
        ensure => directory,
        group => admin,
      }

  file { '/usr/local/virtualenvs':
    ensure => directory,
    owner => 'root',
    group => 'admin',
    recurse => 'true',
  }

  file { '/usr/local/bin/prosaic':
    ensure => present,
    mode => '775',
    source => 'puppet:///modules/tildetown/prosaic',
  }

  python::pyvenv { $venv:
    owner => 'root',
    group => 'admin',
    require => [File['/usr/local/virtualenvs']],
  }

  python::pip { $python_packages:
    virtualenv => $venv,
    } ->
    file { '/etc/init.d/tildecgictl':
      source => 'puppet:///modules/tildetown/tildecgictl',
      mode => '774',
      owner => 'root',
      group => 'admin',
      } ->
      service { 'tildecgictl':
        ensure => running,
        enable => true,
      }
}
