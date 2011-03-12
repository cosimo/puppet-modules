class bash {

    package { "bash":
        ensure => "installed"
    }

}

# Customize bash prompt for a machine
define bash::prompt ($description = "", $color = "red") {

    include bash

    # To assign color based on environment
    #$color = $environment ? { "production" => "red", default: "green" }

    file { $name:
        ensure => "present",
        content => template("bash/bashrc.erb"),
    }

}

