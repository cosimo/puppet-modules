class perl {

	$packagelist = ["perl", "perl-doc" ]

	package { $packagelist:
		   ensure => "installed"
	}

}

