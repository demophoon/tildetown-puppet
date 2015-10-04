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
    'python3.4-venv',
    'mongodb',
  ]

  package { $packages:
    ensure => present,
  }

}











