define nginx::config (
    $ensure = "present",
    $user = "www-data",
    $worker_processes = 8,
    $worker_connections = 4096,
    $keepalive_timeout = 3
) {

    case $name {
        "" : { $name = "/etc/nginx/nginx.conf" }
        default : {}
    }

    file { $name:
        ensure => $ensure,
        owner => "root",
        group => "root",
        mode => 0644,
        content => template("nginx/nginx.conf.erb"),
        require => Package["nginx"],
        notify => Service["nginx"],
    }

}

define nginx::vhost ($ensure = 'present', $source = '') {

    case $ensure {

        "present": {
            file { "/etc/nginx/sites-available/$name":
                owner => "root",
                group => "root",
                mode => 644,
                source => $source,
                require => Package["nginx"],
                notify => Service["nginx"],
            }

            file { "/etc/nginx/sites-enabled/$name":
                owner => "root",
                group => "root",
                mode => 644,
                ensure => "link",
                target => "/etc/nginx/sites-available/$name",
                require => Package["nginx"],
                notify => Service["nginx"],
            }

            file { "/var/www/$name":
                ensure => "directory",
                owner  => "www-data",
                group  => "www-data",
                mode   => 755,
                require => File["/var/www"],
            }

            file { "/var/log/nginx/$name":
                ensure => "directory",
                owner => "www-data",
                group => "root",
                mode => 755,
                require => File["/var/log/nginx"],
            }

        }

        "absent" : {
            file { "/etc/nginx/sites-enabled/$name":
                ensure => "absent",
                notify => Service["nginx"],
            }
        }

    }

}

