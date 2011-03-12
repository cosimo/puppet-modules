class ntp {

    include munin

    # Keep ntp always updated
    package { "ntp":
        ensure => "latest"
    }

    package { "ntpdate":
        ensure => "installed"
    }

    # And the service running
    service { "ntp":
        ensure => "running",
    }

    # Multicast config
    file { "/etc/ntp.conf":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => 0600,
        source => "puppet:///ntp/multicast/ntp.conf",
        notify => Service["ntp"],
        require => Package["ntp"],
    }

    file { "/etc/ntp":
        ensure => "directory",
        owner => "root",
        group => "root",
        mode  => 0700,
    }

    file { "/etc/ntp/ntp.keys":
        ensure => "present",
        owner => "root",
        group => "root",
        mode  => 0400,
        source => "puppet:///ntp/multicast/ntp.keys",
        notify => Service["ntp"],
        require => File["/etc/ntp"],
    }

    # NTP munin plugins
    munin::plugin::custom { "ntp_offset": }
    munin::plugin { "ntp_offset": }

}

