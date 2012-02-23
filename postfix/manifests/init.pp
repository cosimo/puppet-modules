class postfix {

    include munin

    $preseed_file="/var/tmp/postfix.preseed"

    file { $preseed_file:
        ensure  => "present",
        source  => "puppet:///modules/postfix/postfix.preseed",
        mode    => 0600,
        backup  => "false",
    }

    package { "postfix":
        ensure => "installed",
        responsefile => $preseed_file,
        require => File[$preseed_file],
    }

    service { "postfix":
        ensure => "running",
        enable => "true",
        require => Package["postfix"],
    }

    munin::plugin { "postfix_mailqueue": }
    munin::plugin { "postfix_mailstats": }
    munin::plugin { "postfix_mailvolume": }

}

define postfix::config (
    $mode="delivery-only",
    $mydomain="",
    $relayhost=""
) {

    file { "/etc/postfix/main.cf":
        ensure => "present",
        content => template("postfix/main.cf.erb"),
        notify => Service["postfix"],
        require => Package["postfix"],
    }

    file { "/etc/postfix/master.cf":
        ensure => "present",
        content => template("postfix/master.cf.erb"),
        notify => Service["postfix"],
        require => Package["postfix"],
    }

}

