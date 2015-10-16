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
    'mongodb',
  ]

  package { $packages:
    ensure => present,
  }

}











