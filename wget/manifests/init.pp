class wget {

    #defined in base_packages
    #package { "wget":
    #    ensure => "installed",
    #}
}

define wget::download(
       $source,
       $target
) {
    exec { "wget-download-$name":
        command => "/usr/bin/wget --no-check-certificate -O $target $source 2>/dev/null",
        creates => $target,
        require => Package["wget"],
    }
}

