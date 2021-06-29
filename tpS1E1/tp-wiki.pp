#Etape 2: installation de apache2 et php

package { 'apache2':
  ensure   => present,
  name     => 'apache2',
  provider => apt
}

package { 'php7.3':
  ensure   => present,
  name     => 'php7.3',
  provider => apt
}

#etape 3 téléchargement du dokuwiki.tgz

file { 'download-dokuwiki':
  ensure => present,
  source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
  path   => '/usr/src/dokuwiki.tgz'
}

#etape 4 extraire l'archive dokuwiki.tgz

exec { 'extract-dokuwiki':
  command => 'tar xavf dokuwiki.tgz',
  cwd     => '/usr/src',
  path    => ['/usr/bin'],
  require => File['download-dokuwiki'],
  unless  => 'test -d /usr/src/dokuwiki-2020-07-29'
}

file { 'rename-dokuwiki-2020-07-29':
  ensure  => present,
  source  => '/usr/src/dokuwiki-2020-07-29',
  path    => '/usr/src/dokuwiki',
  require => Exec['extract-dokuwiki']
}

#etape 5 création des VM

##  Créer un dossier pour les données du site XXX

file { 'create new directory for recettes.wiki in /var/www and allow apache to write in':
  ensure  => directory,
  source  => '/usr/src/dokuwiki',
  path    => '/var/www/recettes.wiki',
  recurse => true,
  owner   => 'www-data',
  group   => 'www-data',
  require => File['rename-dokuwiki-2020-07-29']
}

file { 'create new directory for politique.wiki in /var/www and allow apache to write in':
  ensure  => directory,
  source  => '/usr/src/dokuwiki',
  path    => '/var/www/politique.wiki',
  recurse => true,
  owner   => 'www-data',
  group   => 'www-data',
  require => File['rename-dokuwiki-2020-07-29']
}


##  Créer un fichier de configuration pour XXX
