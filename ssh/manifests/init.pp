class ssh {

    package { "openssh-server":
        ensure => "installed"
    }

    service { "ssh":
        ensure => "running",
    }

    # TODO a common sshd_config?
    #file { "/etc/ssh/sshd_config":
    #   ...
    #}

}
