class locales {

    package { "locales": 
        ensure => "latest",
    }

    file { "/etc/locale.gen":
        source => [
            "puppet:///locales/les/locale.gen.$fqdn",
            "puppet:///locales/files/host/locale.gen.$hostname",
            "puppet:///locales/files/env/locale.gen.$role",
            "puppet:///locales/locale.gen"
        ],
        owner => "root",
        group => "root",
        mode => 644,
        require => Package["locales"],
    }

    exec { "/usr/sbin/locale-gen":
        subscribe => File["/etc/locale.gen"],
        refreshonly => true,
        require => [ Package["locales"], File["/etc/locale.gen"] ]
    }

}

