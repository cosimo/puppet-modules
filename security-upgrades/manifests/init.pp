class security-upgrades::ssl {

    # Usually SSL packages are updated as soon as there's a
    # security problem, so make sure they're up to date
    package { "openssl":
        ensure => "latest",
    }

    package { "libssl0.9.8":
        ensure => "latest",
    }

}

class security-upgrades {

    include security-upgrades::ssl

}

