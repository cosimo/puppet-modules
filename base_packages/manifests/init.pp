class base_packages {

        $packagelist = [
            "ack-grep",
            "colordiff",
            "curl",        # Required by common, required by apt
            "facter",
            "git-core",
            "htop",
            "iftop",
            "iptraf",
            "jed",
            "joe",
            "libwww-perl",
            "logrotate",
            "lsof",
            "make",
            "mc",
            "oprofile",
            "psmisc",
            "rsync",
            "screen",
            "subversion",
            "sysstat",
            "tcpdump",
            "telnet",
            "unzip",
            "vim",
            "zip" ]

        package { $packagelist:
        	ensure => "installed",
        }

}

