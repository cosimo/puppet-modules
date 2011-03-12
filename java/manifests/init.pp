class java {

    package { "sun-java6-bin":
        ensure => "installed"
    }

    package { "sun-java6-jre":
        ensure => "installed"
    }

}

