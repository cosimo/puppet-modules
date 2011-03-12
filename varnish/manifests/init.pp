class varnish {

    package { "varnish":
        ensure => "installed",
    }

    file { "/etc/init.d/varnish":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => 0755,
        source => "puppet:///varnish/varnish-init",
        require => Package["varnish"],
    }

    # Make sure suggested TCP/IP perf tuning parameters are there
    file { "/etc/sysctl.conf":
        ensure => "present",
        owner  => "root",
        group  => "root",
        mode   => 644,
        source => "puppet:///varnish/sysctl.conf.lenny",
    }

    exec { "update-sysctl":
        command => "/sbin/sysctl -p /etc/sysctl.conf",
        subscribe => File["/etc/sysctl.conf"],
        refreshonly => "true",
    }

    service { "varnish":
       ensure => "running",
       require => [ Package["varnish"], File["/etc/init.d/varnish"], File["/etc/sysctl.conf"] ],
       subscribe => Package["varnish"],
    }

    munin::plugin::custom { "varnish_": }

    munin::plugin { [
        "varnish_backend_traffic",
        "varnish_expunge",
        "varnish_hit_rate",
        "varnish_memory_usage",
        "varnish_objects",
        "varnish_request_rate",
        "varnish_threads",
        "varnish_transfer_rates",
        "varnish_uptime"
        ]:
        ensure => present,
        plugin_name => "varnish_",
    }

}

define varnish::config (
    $vcl_conf="default.vcl",
    $listen_address="",
    $listen_port=6081,
    $thread_min=200,
    $thread_max=5000,
    $thread_timeout=30,
    $storage_type="malloc",
    $storage_size="12G",
    $ttl=60,
    $thread_pools=$processorcount,
    $obj_workspace=8192,
    $sess_workspace=32768,
    $sess_timeout=3
) {

    file { "/etc/default/varnish":
        ensure  => "present",
        owner   => "root",
        group   => "root",
        mode    => 644,
        content => template("varnish/debian-defaults.erb"),
        require => Package["varnish"],
        notify  => Service["varnish"],
    }

}

define varnish::vcl ($source) {

    file { "/etc/varnish/$name":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => 644,
        source => $source,
        require => Package["varnish"],
        notify  => Service["varnish"],
    }

}

