#etape 2: installation de apache2 et php

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

file { 'download dokuwiki.tgz':
  ensure => present,
  source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
  path   => '/usr/src/dokuwiki.tgz'
}

#etape 4 extraire l'archive dokuwiki.tgz

exec { 'extraire dokuwiki.tgz':
  command => 'tar xavf dokuwiki.tgz',
  cwd     => '/usr/src',
  path    => ['/usr/bin']
}

file { 'move dokuwiki':
  ensure => present,
  source => '/usr/src/dokuwiki-2020-07-29',
  path   => '/usr/src/dokuwiki'
}

#etape 5 création des VM

##  Créer un dossier pour les données du site XXX

file { 'create new directory for recettes.wiki in /var/www and allow apache to write in':
  ensure => directory,
  path   => '/var/www/recettes.wiki',
  recurse => true,
  owner   => 'www-data',
  group   => 'www-data'
}

file { 'create new directory for politique.wiki in /var/www and allow apache to write in':
  ensure => directory,
  path   => '/var/www/politique.wiki',
  recurse => true,
  owner   => 'www-data',
  group   => 'www-data'
}

## Installer dokuwiki dans le site XXX

file { 'Copy dokuwiki directory contents in recettes.wiki':
  ensure => present,
  source => '/usr/src/dokuwiki',
  path   => '/var/www/recettes.wiki'
}

file { 'Copy dokuwiki directory contents in politique.wiki':
  ensure => present,
  source => '/usr/src/dokuwiki',
  path   => '/var/www/politique.wiki'
}

##  Créer un fichier de configuration pour XXX
