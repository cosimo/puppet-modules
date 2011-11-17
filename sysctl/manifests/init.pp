class sysctl {

    $sysctl_dir = "/etc/sysctl.d"

    #
    # Ensure basic system sanity. No big deal
    #

    file { "/etc/sysctl.conf":
        ensure => "present",
        owner  => "root",
        group  => "root",
        mode   => 0644,
    }

    file { $sysctl_dir:
        ensure => "directory",
        owner  => "root",
        group  => "root",
        mode   => 0755,
    }

}

define sysctl::settings ($ensure="present", $source="", $content="", $priority=40) {

    $sysctl_dir = "/etc/sysctl.d"
    $sysctl_file = "${sysctl_dir}/${priority}-${name}.conf"

    exec { "reload-sysctl-${priority}-${name}-settings":
        command => "/sbin/sysctl -p ${sysctl_file}",
        require => File[$sysctl_file],
        subscribe => [
            File[$sysctl_file],
            File["/etc/sysctl.conf"],
        ],
        refreshonly => "true",
    }

    if $source {
        file { $sysctl_file:
            ensure => $ensure,
            source => $source,
            owner  => "root",
            group  => "root",
            mode   => 0644,
            notify => Exec["reload-sysctl-${priority}-${name}-settings"],
        }
    }

    if $content {
        file { $sysctl_file:
            ensure => $ensure,
            content=> "${content}
",
            owner  => "root",
            group  => "root",
            mode   => 0644,
            notify => Exec["reload-sysctl-${priority}-${name}-settings"],
        }
    }

}

define sysctl::lvs_direct_routing ($ensure="present", $priority=90) {

    sysctl::settings { "lvs-direct-routing":
        priority => $priority,
        ensure   => $ensure,
        source   => "puppet:///modules/sysctl/lvs/direct-routing.conf",
    }

}

define sysctl::tcp_performance ($ensure="present", $priority=90) {

    sysctl::settings { "tcp-performance":
        priority => $priority,
        ensure   => $ensure,
        source   => "puppet:///modules/sysctl/tcp/performance.conf",
    }

}

