class sun_java6 {

    exec {
        #"/bin/echo \"sun-java6-plugin shared/accepted-sun-dlj-v1-1 boolean true\" | /usr/bin/debconf-set-selections":
        #alias => "debconf-set-selections-sun-java6-plugin";

        "/bin/echo \"sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true\" | /usr/bin/debconf-set-selections":
        alias => "debconf-set-selections-sun-java6-bin";

        "/bin/echo \"sun-java6-jre shared/accepted-sun-dlj-v1-1 boolean true\" | /usr/bin/debconf-set-selections":
        alias => "debconf-set-selections-sun-java6-jre";
    } 

    package { 
        #"sun-java6-plugin":
        #    require => [
        #        Exec["debconf-set-selections-sun-java6-plugin"],
        #        Package["sun-java6-bin"],
        #        Package["sun-java6-jre"] ],
        #    ensure => "installed";

        "sun-java6-bin":
            require => Exec["debconf-set-selections-sun-java6-bin"],
            ensure => "installed";

        "sun-java6-jre":
            require => Exec["debconf-set-selections-sun-java6-jre"],
            ensure => "installed";
    }

}

class java {

    include sun_java6

}

