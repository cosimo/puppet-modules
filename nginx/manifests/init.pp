#
# Nginx puppet module
#

import "defines.pp"

class nginx {
    include "nginx::${operatingsystem}"
}

class nginx::base {

    package { "nginx":
            ensure => installed;
    }

    service { "nginx":
        ensure => "running",
        require => Package["nginx"]
    }

    file {
        "/etc/nginx/conf.d":
            ensure => "directory",
            checksum => "mtime",
            mode => 644,
            owner => "root",
            group => "root",
            require => Package["nginx"],
            notify => Exec["reload-nginx"];
    }

    file { "/etc/nginx":
        mode => 755,
        owner => root,
        group => root,
        ensure => directory,
        recurse => false,
        backup => false,
        require => Package["nginx"],
    }

    file { "/var/log/nginx":
        mode => 750,
        owner => "root",
        group => "adm",
        ensure => "directory",
        require => Package["nginx"],
    }

    file { "/var/www":
        mode => 755,
        owner => "www-data",
        group => "www-data",
        ensure => "directory",
    }

    # Notify this when nginx needs a reload
    exec { "reload-nginx":
        refreshonly => true,
        before => [ Service["nginx"], Exec["force-reload-nginx"] ],
    }

    exec { "force-reload-nginx":
        refreshonly => true,
        before => Service["nginx"],
    }

    munin::plugin {
       [ "nginx_memory", "nginx_request", "nginx_status" ]:
           ensure => present,
           config => "env.url http://localhost/nginx_status"
    }

    #nagios::service { "http_${nginx_port_real}":
    #       check_command => "http_port!${nginx_port_real}"
    #}

    # We try to manage our logs with our own cronjobs (below)
    file { "/etc/logrotate.d/nginx":
        ensure => "present",
        owner  => "root",
        group  => "root",
        mode   => 644,
        source => "puppet:///nginx/logrotate.conf",
    }

}

