class theschwartz::worker {

    package { "libtheschwartz-perl":
        ensure => "installed",
    }

    package { "libtheschwartz-worker-sendemail-perl":
        ensure => "installed",
    }

}

class theschwartz::server {

    package { "libtheschwartz-perl"
        ensure => "installed",
    }

    package { "mysql-server":
        ensure => "installed",
    }

    file { "/etc/mysql/conf.d/jobqueue.cnf":
        ensure => present,
        owner => root,
        group => root,
        mode => 0644,
        source => "puppet:///theschwartz/mysql-jobqueue.cnf",
    }

}

