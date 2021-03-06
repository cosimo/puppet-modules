class base_packages {

    $packagelist = [
        "ack-grep",
        "bc",
        "bzip2",
        "colordiff",
        "curl",            # Required by common, required by apt
        "debconf",
        "debconf-utils",   # Required to use debconf-{get,set}-selections
        "dmidecode",
        "dnsutils",
        "ethtool",
        "facter",
        "gcc",
        "gdb",
        #"git",
        "git-core",
        "gnupg",
        "htop",
        "ifenslave-2.6",
        "iftop",
        "iotop",
        "iptraf",
        "jed",
        "joe",
        "less",
        "libwww-perl",
        "logrotate",
        "lsb-release",
        "lsof",
        "lynx-cur",
        "m4",
        "make",
        "manpages-posix",
        "manpages-posix-dev",
        "mc",
        "moreutils",
        "mtr",
        "oprofile",
        "otp",
        "p7zip-full",
        "patch",
        "pigz",
        "psmisc",
        "rsync",
        "screen",
        "socat",
        "ssh",
        "strace",
        "subversion",
        "sudo",
        "sysstat",
        "tcpdump",
        "tcpflow",
        "telnet",
        "tree",
        "trickle",
        "unzip",
        "vim",
        "w3m",
        "wget",
        "whois",
        "zip",
    ]

    package { $packagelist:
        ensure => "installed",
    }

}
