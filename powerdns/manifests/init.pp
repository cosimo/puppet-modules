class powerdns {

    package { "pdns-server":
        ensure => "installed",
    }

    package { "pdns-doc":
        ensure => "installed",
    }

    package { "pdns-backend-pipe":
        ensure => "installed",
    }

    #package { "pdns-backend-geo":
    #    ensure => "installed"
    #}

    #file { "/etc/powerdns/pdns.d/pdns.local":
    #    ensure => "present",
    #    owner => "root",
    #    group => "root",
    #    mode => 644,
    #    source => "puppet:///powerdns/config/pdns.local",
    #}

    #file { "/etc/powerdns/plugin/geodirector.pl":
    #    ensure => "present",
    #    owner => "root",
    #    group => "root",
    #    mode => 755,
    #    source => "puppet:///powerdns/plugin/geodirector.pl",
    #}

    file { "/etc/logrotate.d/pdns":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => 644,
        source => "puppet:///powerdns/logrotate/pdns",
    }

    service { "pdns":
        ensure => "running",

        # Automatic service restart after config changes?
        #subscribe => [
        #    File["/etc/powerdns/pdns.conf"],
        #    File["/etc/powerdns/pdns.d/pdns.local"],
        #],
    }

}

