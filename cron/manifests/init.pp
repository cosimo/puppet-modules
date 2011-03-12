class cron {

    include ntp

	package { "cron":
		   ensure => "installed",
	}

	service { "cron":
        ensure => "running",
	}

}

