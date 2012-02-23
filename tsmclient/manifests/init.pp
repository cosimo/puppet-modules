class tsmclient {

    case $operatingsystem {
        #/CentOS|Redhat/ : { include tsmclient::centos }
        /Debian|Ubuntu/ : { include tsmclient::debian }
        default : {}
    }

    include tsmclient::common
}

class tsmclient::debian {

    package { [ "libstdc++6", "ia32-libs", "ksh" ]:
        ensure  => "installed",
    }

    # Needs an apt-get update in case the IBM TSM packages
    # are not in the apt index yet
    exec { "tsm-apt-update":
        command => "apt-get update",
        path    => "/bin:/usr/bin:/sbin",
        unless  => "apt-cache policy gskcrypt32 | head -1 | grep gskcrypt32",
    }

    package { "gskcrypt32":
        ensure  => "latest",
        require => Exec["tsm-apt-update"],
    }

    package { "gskssl32":
        ensure  => "latest",
        require => Package["gskcrypt32"],
    }

    package { "tivsm-api":
        ensure => "latest",
        require => [
            Package["gskcrypt32"],
            Package["libstdc++6"],
            Package["ia32-libs"],
            Package["ksh"],
        ],
    }

    package { "tivsm-ba":
        ensure => "latest",
        require => Package["tivsm-api"],
    }

    # 64 bit architecture requires that you install all of the 32 bit components first..
    case $architecture {
        "amd64" : {
            package { "gskcrypt64":
                ensure => "latest",
            }

            package { "gskssl64":
                ensure  => "latest",
                require => Package["gskcrypt64"],
            }
            package { "tivsm-api64":
                ensure => "latest",
                require => [
                    Package["gskcrypt64"],
                    Package["tivsm-api"],
                ],
            }
        }
    }

    file { "tsm_client_defaults":
        ensure => "present",
        owner   => "root",
        group   => "root",
        mode    => "0644",
        path    => "/etc/default/dsmcad",
        source  => "puppet:///modules/tsmclient/debian/dsmcad.default",
    }

    file { "tsm_client_init":
        ensure  => "present",
        owner   => "root",
        group   => "root",
        mode    => "0755",
        path    => "/etc/init.d/dsmcad",
        source  => "puppet:///modules/tsmclient/debian/dsmcad.init",
        require => $architecture ? {
            "i686" => [
                Package["tivsm-api"],
                Package["tivsm-ba"],
                File["tsm_client_defaults"],
                File["/etc/ld.so.conf.d/tsm.conf"],
                File["/var/log/tsm"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm-linux-exclude.excl"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm-nocompression.excl"],
            ],
            "amd64" => [
                Package["tivsm-api"],
                Package["tivsm-ba"],
                Package["tivsm-api64"],
                File["tsm_client_defaults"],
                File["/etc/ld.so.conf.d/tsm.conf"],
                File["/var/log/tsm"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm-linux-exclude.excl"],
                File["/opt/tivoli/tsm/client/ba/bin/dsm-nocompression.excl"],
            ],
        },
    }
}

class tsmclient::common {

    # Your TSM instance
    $tsmserver = "127.0.0.1"
    $tsmport = "1500"
    $tsmpassword = "YourSuperSecretPassword"

    service { "dsmcad":
        subscribe   => [
            File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
            File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"],
            File["/opt/tivoli/tsm/client/ba/bin/dsm-linux-exclude.excl"],
            File["/opt/tivoli/tsm/client/ba/bin/dsm-nocompression.excl"],
            File["tsm_client_init"],
            File["/etc/ld.so.conf.d/tsm.conf"],
        ],
        ensure      => "running",
        enable      => "true",
        pattern     => "dsmcad",
    }

    file { "/var/log/tsm":
        ensure => directory,
        owner  => "root",
        group  => "root",
    }

    file { "/opt/tivoli/tsm/client/ba/bin/dsm-linux-exclude.excl":
        ensure  => "present",
        owner   => "root",
        group   => "bin",
        mode    => 0644,
        source  => "puppet:///modules/tsmclient/inclexcl/dsm-linux-exclude.excl",
        require => Package["tivsm-ba"],
    }

    file { "/opt/tivoli/tsm/client/ba/bin/dsm-nocompression.excl":
        ensure  => "present",
        owner   => "root",
        group   => "bin",
        mode    => 0644,
        source  => "puppet:///modules/tsmclient/inclexcl/dsm-nocompression.excl",
        require => Package["tivsm-ba"],
    }

    file { "/opt/tivoli/tsm/client/ba/bin/dsm.opt":
        owner   => root,
        group   => bin,
        mode    => 0644,
        require => Package["tivsm-ba"],
        content => template("tsmclient/dsm.opt.erb"),
    }

    file { "/opt/tivoli/tsm/client/ba/bin/dsm.sys":
        owner   => root,
        group   => bin,
        mode    => 0644,
        require => File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"],
        content => template("tsmclient/dsm.sys.erb"),
    }

    file { "/etc/ld.so.conf.d/tsm.conf":
        ensure => "present",
        owner  => "root",
        group  => "root",
        mode   => 0644,
        content=> "/opt/tivoli/tsm/client/api/bin
/usr/local/ibm/gsk8/lib
",
        notify => Exec["tsm-ldconfig"],
    }

    exec { "tsm-ldconfig":
        cwd         => "/tmp",
        path        => "/bin:/sbin",
        command     => "/sbin/ldconfig",
        refreshonly => "true",
        subscribe   => File["/etc/ld.so.conf.d/tsm.conf"],
    }

    exec { "store-password":
        cwd     => "/opt/tivoli/tsm/client/ba/bin",
        path    => "/opt/tivoli/tsm/client/ba/bin",
        require => File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
        command => "/opt/tivoli/tsm/client/ba/bin/dsmc set password $tsmpassword $tsmpassword",
        onlyif  => "/opt/tivoli/tsm/client/ba/bin/dsmc query session </dev/null | /bin/grep ^ANS1025E",
    }

}

