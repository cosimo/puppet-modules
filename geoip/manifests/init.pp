class geoip {

    package { "libgeoip-dev":
        ensure => "installed",
    }

    package { "geoip-bin":
        ensure => "latest",
    }

    package { "libgeo-ip-perl":
        ensure => "installed",
    }

    # Cronjob that updates GeoIP database
    file { "/etc/cron.d/geoip-update":
        ensure => "present",
        owner => "root",
        group => "root",
        mode  => 0644,
        source => "puppet:///geoip/geoip-update.cron",
        notify => Service["cron"]
    }

}

class geoip::country inherits geoip {

    file { "/etc/GeoIP.conf":
        ensure => "present",
        owner => "root",
        group => "root",
        mode  => 0644,
        source => "puppet:///geoip/geoip-country.conf",
    }

    exec { "/usr/bin/geoipupdate":
        subscribe => File["/etc/GeoIP.conf"],
    }

}

class geoip::city inherits geoip {

    file { "/etc/GeoIP.conf":
        ensure => "present",
        owner => "root",
        group => "root",
        mode  => 0644,
        source => "puppet:///geoip/geoip-city.conf",
    }

    exec { "/usr/bin/geoipupdate":
        subscribe => File["/etc/GeoIP.conf"],
    }

}

