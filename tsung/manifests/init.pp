class tsung {

    $packagelist = ["gnuplot", "tsung"]

    package { $packagelist:
        ensure => "installed"
    }
}
