define resolver::dns ($nameservers, $search="", $domain="", $rotate="") {

    file { "/etc/resolv.conf":
        ensure => "present",
        owner  => "root",
        group  => "root",
        mode   => 644,
        content => template("resolver/resolv.conf.erb"),
    }

}

