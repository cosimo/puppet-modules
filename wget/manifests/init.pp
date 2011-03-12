class wget {
    package { "wget":
        ensure => "installed",
    }
}

define wget::download($url, $dest_file) {
    exec { "wget-download-$name":
        command => "/usr/bin/wget --no-check-certificate -O $dest_file $url 2>/dev/null",
        creates => $dest_file,
        require => Package["wget"],
    }
}

