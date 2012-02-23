class rsyslog {

    package { "rsyslog":
        ensure => "installed",
    }

    service { "rsyslog":
        ensure => "running",
    }

}

define rsyslog::conf ($priority=90, $content="", $source="") {

    $filename = "/etc/rsyslog.d/$priority-$name.conf"

    # Either source or content, but not both are allowed
    case $source {
        "" : {
            # No source, so "content" is mandatory
            file { $filename:
                ensure  => "present",
                owner   => "root",
                group   => "root",
                mode    => 0644,
                content => $content,
                require => Package["rsyslog"],
                notify  => Service["rsyslog"],
            }
        }
        default : {
            # Source was supplied, so use it
            file { $filename:
                ensure  => "present",
                owner   => "root",
                group   => "root",
                mode    => 0644,
                source  => $source,
                require => Package["rsyslog"],
                notify  => Service["rsyslog"],
            }
        }
    }

}
