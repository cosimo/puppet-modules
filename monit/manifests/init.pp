class monit {

    package { "monit":
        ensure => "installed"
    }

}

define monit::config ($check_interval=120, $start_delay=10, $mailserver="localhost", $alert_email_from="monit@localhost", $alert_email_to="root@localhost") {

    # Makes sure the service starts up
    file { "/etc/default/monit":
        ensure => "present",
        source => "puppet:///modules/monit/debian-defaults",
        owner  => "root",
        group  => "root",
        mode   => 0644,
        require => Package["monit"],
    }

    file { "/etc/monit/monitrc":
        ensure => "present",
        content=> template("monit/monitrc.erb"),
        owner  => "root",
        group  => "root",
        mode   => 0600,
        require => Package["monit"],
        notify => Service["monit"],
    }

    # Make sure the service is only attempted starting
    # after the defaults file has been installed
    service { "monit":
        ensure => "running",
        require => File["/etc/default/monit"],
        subscribe => [
            File["/etc/default/monit"],
            File["/etc/monit/monitrc"],
        ],
    }

}

define monit::check ($ensure, $content="", $source="") {

    if $source {
        file { "/etc/monit/conf.d/$name":
            ensure => $ensure,
            source => $source,
            owner  => "root",
            group  => "root",
            mode   => 0644,
            require=> Package["monit"],
            notify => Service["monit"],
        }
    }

    if $content {
        file { "/etc/monit/conf.d/$name":
            ensure => $ensure,
            content=> $content,
            owner  => "root",
            group  => "root",
            mode   => 0644,
            require=> Package["monit"],
            notify => Service["monit"],
        }
    }

}

