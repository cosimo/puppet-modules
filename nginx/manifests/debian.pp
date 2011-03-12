class nginx::debian inherits nginx::base { 
    info("Configuring nginx for Debian")

    Package["nginx"] { name => "nginx" }
    Service["nginx"] {
        name => "nginx",
        pattern => "/usr/sbin/nginx",
        hasrestart => true,
    }

    Exec["reload-nginx"] { command => "/etc/init.d/nginx reload", }
    Exec["force-reload-nginx"] { command => "/etc/init.d/nginx force-reload", }

    file { "/etc/nginx/sites-enabled/default": ensure => absent }

}
