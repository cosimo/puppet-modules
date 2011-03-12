#
# Apache Solr puppet module
#
# Based on Mike's input. To be tested.
#

class solr {

    include tomcat
    include wget

}

define solr::instance ($solr_home = "/var/opt/solr", $solr_version = "1.4.1") {

    include solr

    $solr_tar_file = "/var/lib/apache-solr-$solr_version.tgz"
    $solr_dir = "/var/lib/apache-solr-$solr_version"

    file { $solr_home:
        ensure => "directory",
        owner => "tomcat6",
        group => "tomcat6",
        mode  => 0755,
        require => Package["tomcat6"],
    }

    file { "$solr_home/webapps":
        ensure => "directory",
        owner => "tomcat6",
        group => "tomcat6",
        mode  => 0755,
        require => [
            Package["tomcat6"],
            File[$solr_home]
        ],
    }

    wget::download { "apache-solr-$solr_version":
        source => "http://mirrors.powertech.no/www.apache.org/dist/lucene/solr/$solr_version/$solr_tar_file",
        target => $solr_tar_file,
    }

    exec { "unpack-apache-solr-$solr_version":
        command => "/bin/tar xzf $solr_tar_file -C /var/lib",
        creates => $solr_download_dir,
        require => Wget::Download["apache-solr-$solr_version"],
    }

    exec { "copy-solr-$solr_version-war":
        command => "cp -p $solr_download_dir/dist/apache-solr-$solr_version.war $solr_home/webapps/solr.war",
        creates => "$solr_home/webapps/solr.war",
        require => Exec["unpack-apache-solr-$solr_version"],
    }

    file { "/etc/tomcat6/Catalina/localhost/solr.xml":
        ensure => "present",
        owner  => "tomcat6",
        group  => "tomcat6",
        mode   => 0644,
        content => template("solr/solr.xml"),
    }

}

