#
# Apache puppet module
#
# Basic structure and defines come from:
# git://git.black.co.at/modules-apache/
#

import "defines.pp"

class apache {
    include "apache::${operatingsystem}"
}

class apache::base {

    package { "apache":
            ensure => installed;
    }

    service { "apache":
        ensure => "running",
        require => Package["apache"]
    }

    file {
        "/etc/apache2/conf.d":
            ensure => "directory",
            checksum => "mtime",
            mode => 644,
            owner => "root",
            group => "root",
            require => Package["apache"],
            # If you want automatic reload, uncomment this
            # notify => Exec["reload-apache"];
    }

    file { "/etc/apache2":
        mode => 755,
        owner => root,
        group => root,
        ensure => directory,
        recurse => false,
        backup => false,
        require => Package[apache],
    }

    file { "/var/log/apache2":
        mode => 750,
        owner => "root",
        group => "adm",
        ensure => "directory",
        require => Package["apache"],
    }

    # always enable output compression
    #apache::module { "deflate": ensure => present }

    # Notify this when apache needs a reload. This is only needed when
    # sites are added or removed, since a full restart then would be
    # a waste of time. When the module-config changes, a force-reload is
    # needed.
    exec { "reload-apache":
        refreshonly => true,
        before => [ Service["apache"], Exec["force-reload-apache"] ],
    }

    exec { "force-reload-apache":
        refreshonly => true,
        before => Service["apache"],
    }

    apache::module { info:   ensure => present }
    apache::module { status: ensure => present }

    munin::plugin {
        [ "apache_accesses", "apache_activity", "apache_processes", "apache_volume",
          "apache_smaps" ]:
        ensure => "present",
    }

    munin::plugin { "mem_apache2":
        ensure => "present",
        plugin_name => "mem_"
    }

    #nagios::service { "http_${apache_port_real}":
    #       check_command => "http_port!${apache_port_real}"
    #}

    cron { "log-compress" :
        ensure => "present",
        command => "nohup /usr/bin/find /var/log/apache2/ -type f -name '*.log.*' -mtime 1 -exec bzip2 {} \\;",
        user => "root",
        hour => 1,
        minute => 0
    }

    cron { "log-purge":
        ensure => "present",
        command => "nohup /usr/bin/find /var/log/apache2/ -type f -name '*.log.*' -mtime 14 -exec rm -f {} \\;",
        user => "root",
        hour => 1,
        minute => 45,
    }

}

