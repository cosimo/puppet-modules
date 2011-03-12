# debian.pp - debian specific defines for apache
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
# 
# After http://reductivelabs.com/trac/puppet/wiki/Recipes/DebianApache2Recipe
# where Tim Stoop <tim.stoop@gmail.com> graciously posted this recipe
# modifications for multiple distros with support from <admin@immerda.ch>

class apache::debian inherits apache::base { 
    info("Configuring apache for Debian")
    #TODO: refactor all debian specifics from ::base here
    Package["apache"] { name => apache2 }
    Service["apache"] {
        name => "apache2",
        pattern => "/usr/sbin/apache2",
        hasrestart => true,
    }

    Exec["reload-apache"] { command => "/etc/init.d/apache2 reload", }
    Exec["force-reload-apache"] { command => "/etc/init.d/apache2 force-reload", }

    # remove the default site in debian
    file { "/etc/apache2/sites-enabled/000-default": ensure => absent }

}
