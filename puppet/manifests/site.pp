include yum
include apache

apache::vhost { 'drupal.local':
  port     => '80',
  docroot  => '/var/www/html/drupal',
  priority => 25,
  override => 'all',
}

include apache::mod::rewrite

firewall { '100 allow http and https access':
  port   => [ 80, 443 ],
  proto  => tcp,
  action => accept,
}

include ::mysql::server

mysql::db { 'drupal':
  user     => 'drupal',
  password => 'drupal',
  host     => 'localhost',
  grant    => ['ALL'],
}

class { '::mysql::bindings':
  php_enable => true,
}

include php::mod_php5

php::ini { '/etc/php.ini':
  display_errors => 'On',
  memory_limit   => '256M',
}

php::module {
  [
    'devel',
    'gd',
    'mbstring',
    'pecl-xdebug',
    'pecl-xhprof',
    'xml',
  ]:
}

include drush