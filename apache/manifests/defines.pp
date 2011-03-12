define apache::module ( $ensure = 'present', $require_package = 'apache' ) {
    case $ensure {
        'present' : {
            exec { "/usr/sbin/a2enmod $name":
                unless => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ] \\
                    && [ /etc/apache2/mods-enabled/${name}.load -ef /etc/apache2/mods-available/${name}.load ]'",
                notify => Exec["force-reload-apache"],
                require => Package[$require_package],
            }
        }
        'absent': {
            exec { "/usr/sbin/a2dismod $name":
                onlyif => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ] \\
                    && [ /etc/apache2/mods-enabled/${name}.load -ef /etc/apache2/mods-available/${name}.load ]'",
                notify => Exec["force-reload-apache"],
                require => Package[$require_package],
            }
        }
    }
}

# threaded, prefork or event
define apache::mpm () {

    package { "apache2-mpm-$name":
        ensure => "installed",
        notify => Service["apache"],
    }

}

define apache::vhost ($ensure = 'present', $source = '') {

    case $ensure {

        "present": {
            file { "/etc/apache2/sites-available/$name":
                owner => "root",
                group => "root",
                mode => 644,
                source => $source,
                require => Package["apache2"],
                notify => Service["apache2"],
            }

            file { "/etc/apache2/sites-enabled/$name":
                owner => "root",
                group => "root",
                mode => 644,
                ensure => "link",
                target => "/etc/apache2/sites-available/$name",
                require => Package["apache"],
                notify => Service["apache"],
            }

            # Sometimes, we use /var/www/project -> /opt/project/current/www,
            # so we can't enforce a directory.
            # Maybe: TODO: make it an option?

            #file { "/var/www/$name":
            #    ensure => "directory",
            #    owner  => "www-data",
            #    group  => "www-data",
            #    mode   => 755,
            #}

            file { "/var/log/apache2/$name":
                ensure => "directory",
                owner => "www-data",
                group => "root",
                mode => 755,
                require => File["/var/log/apache2"],
            }

        }

        "absent" : {
            file { "/etc/apache2/sites-enabled/$name":
                ensure => "absent",
                notify => Service["apache"],
            }
        }

    }

}

