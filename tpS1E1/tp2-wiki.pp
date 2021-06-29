$path1 = '/usr/src'
$path2 = '/usr/bin'
$path3 = '/var/www'

class dokuwiki {
    package { 'apache2':
            ensure => present
    }

    package { 'php7.3':
            ensure => present
    }

#etape 3 téléchargement du dokuwiki.tgz

    file { 'download-dokuwiki':
            ensure => present,
            source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
            path   => "${path1}/dokuwiki.tgz"
    }

#etape 4 extraire l'archive dokuwiki.tgz

    exec { 'extract-dokuwiki':
            command => 'tar xavf dokuwiki.tgz',
            cwd     => "${path1}",
            path    => ["${path2}"],
            require => File['download-dokuwiki'],
            unless  => "test -d ${path1}/dokuwiki-2020-07-29"
    }

    file { 'rename-dokuwiki-2020-07-29':
            ensure  => present,
            source  => "${path1}/dokuwiki-2020-07-29",
            path    => "${path1}/dokuwiki",
            require => Exec['extract-dokuwiki']
    }
}

    #etape 5 création des VM

##  Créer un dossier pour les données du site XXX

class dokuwiki_deploy {
    file { "create new directory for ${env}.wiki in ${path3} and allow apache to write in":            
            ensure  => directory,
            source  => "${path1}/dokuwiki",
            path    => "${path3}/${env}.wiki",
            recurse => true,
            owner   => 'www-data',
            group   => 'www-data',
            require => File['rename-dokuwiki-2020-07-29']
    }
}

node 'server0' {
    $env = 'recettes'
    include dokuwiki
    include dokuwiki_deploy
}

node 'server1' {
    $env = 'politique'
    include dokuwiki
    include dokuwiki_deploy
}
