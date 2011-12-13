class jenkins {

    include base_packages
    include apt
    include java
    include apache

    apt::key { "D50582E6":
        source => "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key",
    }

    apt::sources_list { "jenkins-ci":
        ensure  => "present",
        content => "deb http://pkg.jenkins-ci.org/debian binary/",
        require => Apt::Key["D50582E6"],
        notify => Exec["apt-get_update"]
    }

    package { "jenkins":
        ensure => "installed",
	require => Apt::Sources_list["jenkins-ci"],
    }

    # Setup apache to forward port 80 to 8080
    apache::module { "proxy": }
    apache::module { "proxy_http": }
    apache::module { "vhost_alias": }

    apache::vhost { "default":
        ensure => "absent",
    }

    apache::vhost { "jenkins":
        ensure => "present",
        source => "puppet:///modules/jenkins/apache-vhost",
    }

    # TAP::Harness::JUnit deps
    package { [ "libxml-simple-perl", "libtest-deep-perl" ]:
        ensure => "installed",
    }

    file { "/etc/sudoers.d/jenkins-nopasswd":
        ensure => "present",
        source => "puppet:///modules/jenkins/sudoers-rule",
        owner  => "root",
        group  => "root",
        mode   => 0440,
        # base_packages also contains 'sudo'
        require => Class["base_packages"],
    }

}

