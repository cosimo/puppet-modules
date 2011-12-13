#
# Only supports "source", no "content" like the original module
#
define apt::key($ensure="present", $source="") {

  case $ensure {

    "present": {

      $thekey = "wget -O - '$source'"

      exec { "import gpg key $name":
        command => "${thekey} | /usr/bin/apt-key add -",
        #unless => "apt-key list | grep -Fqe '${name}'",
        unless => "apt-key list | grep '${name}'",
        path   => "/bin:/usr/bin",
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"],
      }

    }

    "absent": {

      exec { "delete gpg key $name":
        command => "/usr/bin/apt-key del ${name}",
        path    => "/bin:/usr/bin",
        onlyif  => "apt-key list | grep '${name}'",
      }

    }

  }

}
