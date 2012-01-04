#
# Inspired by github.com/saz/puppet-timezone
# but simplified a lot.
#

class timezone ($timezone="Etc/UTC") {

    include cron

    # Keep tzdata always up to date, there's always changes there
    package { "tzdata":
        ensure => "latest",
    }

    file { "/etc/localtime":
        # Ensure as filename will copy the file
        ensure => "/usr/share/zoneinfo/$timezone",
        require => Package["tzdata"],
        # Trigger cron restart, or cron will still launch
        # jobs in the previous timezone
        notify => Service["cron"],
    }

    file { "/etc/timezone":
        ensure => "present",
        content => "$timezone\n",
        owner => "root",
        notify => Service["cron"],
    }

}
