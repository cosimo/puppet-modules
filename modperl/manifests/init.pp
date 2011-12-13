class modperl {

    include apache
    include perl

    #apache::mpm { "worker":
    #    ensure => "absent"
    #}
    apache::mpm { "prefork": }

    #apache::module { "deflate":
    #    ensure => "absent"
    #}

    package { "libapache2-mod-apreq2":
        ensure => "installed",
        configfiles => "keep",
        require => Package["apache2-mpm-prefork"],
    }

    package { "libapache2-mod-perl2":
        ensure => "installed",
        configfiles => "keep",
        require => Package["apache2-mpm-prefork"],
    }

    # Have seen some breakage after dist-upgrades
    # where libapache2-mod-apreq2 is installed but
    # mods-available/apreq.load is not there (?)
    # or it's empty (??)
    #
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=573062
    file { "/etc/apache2/mods-available/apreq.load":
        ensure => "present",
        content => "LoadModule apreq_module /usr/lib/apache2/modules/mod_apreq2.so",
        require => Package["libapache2-mod-apreq2"],
    }

    apache::module { "apreq":
        ensure => "present",
        require => Package["libapache2-mod-apreq2"],
    }

    apache::module { "perl":
        ensure => "present",
        require => Package["libapache2-mod-perl2"],
    }

}

