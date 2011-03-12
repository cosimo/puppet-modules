class python {

    package { "python":
        ensure => "installed",
    }

    package { "python-dev":
        ensure => "installed",
        require => Package["python"],
    }

    package { "python-setuptools":
        ensure => "installed",
        require => Package["python"],
    }

    package { "python-pkg-resources":
        ensure => "installed",
    }

    file { "/usr/bin/easy_install":
        ensure => "present",
        require => [
            Package["python-setuptools"],
            Package["python-dev"]
        ],
    }

}
