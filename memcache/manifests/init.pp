class memcache {

	include munin

    package { "memcache":
        name => "memcached",
        ensure => present
    }

    service { "memcache":
        name => "memcached",
        ensure => running,
        require => Package["memcache"]
    }

    munin::plugin::custom { "memcached_": }

    munin::plugin {
        [ "memcached_bytes", "memcached_counters", "memcached_rates" ]:
        plugin_name => "memcached_",
    }

    # TODO: provide autoconfiguration of memcached.conf file
    #       through a template, like:
    #
    # memcache::config { "/etc/memcached.conf":
    #     port => 11211,
    #     size => 4096,
    # }

    #file { "/etc/memcached.conf":
    #   source => "puppet:///memcache/etc/memcached.conf",
    #   require => Package["memcached"],
    #   notify => Service["memcached"]
    #}

    file { "/etc/logrotate.d/memcached":
        ensure => "present",
        require => Package["memcache"],
    }

}

define memcache::config ($address = "", $port = "11211", $size = "512", $max_connections = "8192", $user = "root", $logfile = "/var/log/memcached") {

    include memcache

    file { $name:
        content => template("memcache/memcached.conf.erb"),
        require => Package["memcache"],
        notify  => Service["memcache"],
    }

}

