class tildetown::python () {

  $scripts = '/usr/local/tildetown-scripts'
  $venv = '/usr/local/virtualenvs/tildetown'
  $python_packages = ['prosaic', 'hy', 'sh', 'bpython', 'gunicorn', 'pyhocon', 'Flask', 'tildetown']

  exec { 'scripts':
    creates => $scripts,
    command => "/usr/bin/git clone https://github.com/tildetown/tildetown-scripts ${scripts}"
    } ->
    file { $scripts:
      group => 'admin',
      ensure => 'directory',
      recurse => true,
    }

  file { '/usr/local/virtualenvs':
    ensure => directory,
    owner => 'root',
    group => 'admin',
    recurse => 'true',
  }

#  file { '/usr/bin/pyvenv':
#    ensure => link,
#    target => '/usr/bin/pyvenv-3.4',
#    require => Package['python3.4-venv'],
#  }

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
