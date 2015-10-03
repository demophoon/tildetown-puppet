class tildetown::packages () {
  $packages = [
    'joe',
    'weechat',
    'emacs',
    'alpine',
    'mutt',
    'tmux',
    'htop',
    'screen',
    'lynx',
    'tree',
    'finger',
    'cowsay',
    'figlet',
    'toilet',
    'git',
    'python3',
    'python3-pip',
    'python-virtualenv',
    'mongodb',
  ]

  package { $packages:
    ensure => present,
  }

}











