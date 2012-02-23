class logcheck {

    # Usually our /tmp partitions are really small
    $tmpdir = "/var/tmp"

    # Prevent logcheck from sending tons
    # of local email reports that nobody looks at
    $recipient = ""

    package { "logcheck":
        ensure => "installed",
    }

    file { "/etc/logcheck/logcheck.conf":
        ensure => "present",
        # Permissions are the same as logcheck package uses
        owner  => "root",
        group  => "logcheck",
        mode   => 0640,
        content => template("logcheck/logcheck.conf.erb"),
        require => Package["logcheck"],
    }

}
