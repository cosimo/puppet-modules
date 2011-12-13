define apt::sources_list ($ensure="present", $source="", $content="") {

    case $ensure {

        "present" : {

            if $source {

                file { "/etc/apt/sources.list.d/${name}.list":
                    ensure => $ensure,
                    owner  => "root",
                    group  => "root",
                    mode   => 0644,
                    source => $source,
                    before => Exec["apt-get_update"],
                    notify => Exec["apt-get_update"],
                }

            } else {

                file { "/etc/apt/sources.list.d/${name}.list":
                    ensure  => $ensure,
                    content => $content,
                    owner  => "root",
                    group  => "root",
                    mode   => 0644,
                    before  => Exec["apt-get_update"],
                    notify  => Exec["apt-get_update"],
                }

            }

        }

        "absent" : {

            file { "/etc/apt/sources.list.d/${name}.list" :
                ensure => "absent",
            }

        }

    }

}
