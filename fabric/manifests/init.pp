class fabric {

    include python

    exec { "fabric-install":
        command => "/usr/bin/easy_install fabric",
        creates => "/usr/bin/fab",
        cwd => "/tmp",
        require => File["/usr/bin/easy_install"],
    }

    file { "/usr/bin/fab":
        ensure => "present",
        require => Exec["fabric-install"],
    }

}

