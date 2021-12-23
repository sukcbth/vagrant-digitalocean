class common {
    exec {
            'apt-get-update':
            command     => '/usr/bin/apt-get update',
            refreshonly => true,
    }
}

class nodejspkg {
    package {
            'curl' : ensure => installed,
            require    => Exec['apt-get-update'],
    }

    exec {
            'setup-nodejs-install':
            command     => '/usr/bin/curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -',
            require    => Package['curl'],
    }

    package {
            'nodejs' : ensure => installed,
            require    => Exec['apt-get-update'],
    }
}

class mysql_server {
  package { 'mysql-server':
    ensure => installed,
  }

  service { 'mysql':
    ensure  => true,
    enable  => true,
    require => Package['mysql-server'],
  }
}

node default {
        include common
}

node /^appserver.*$/ {
        include common
        include nodejspkg
}

node /^dbserver.*$/ {
  class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts => true
  }
}
