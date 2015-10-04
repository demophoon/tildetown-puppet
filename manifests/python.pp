class tildetown::python () {

  $venv = '/usr/local/virtualenvs/tildetown'
  $python_packages = ['prosaic']

  file { '/usr/local/virtualenvs':
    ensure => directory,
    owner => 'root',
    group => 'admin',
  }

  file { '/usr/bin/pyvenv':
    ensure => link,
    target => '/usr/bin/pyvenv-3.4',
    require => Package['python3.4-venv'],
  }

  python::pyvenv { $venv:
    owner => 'root',
    group => 'admin',
    require => [File['/usr/bin/pyvenv'],
                File['/usr/local/virtualenvs']],
  }

  python::pip { $python_packages:
    virtualenv => $venv,
  }

}
