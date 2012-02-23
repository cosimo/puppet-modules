Puppet Module to Manage TSM Client
==================================

Description
-----------

This is a modified version of the Puppet TSM (Tivoli Storage Manager)
module written by Richard Clark <richard@fohnet.co.uk> and tweaked
for Debian.

You will need to tweak the manifests/init.pp file with your
own TSM instance IP, port, and password.

Probably there's a better way to do this, by including
variables in your main site.pp. YMMV.

Following is the original puppet-tsm module description.

---

Puppet module to manage installation, upgrade and reconfiguration of Tivoli Storage Manager (TSM) client.

Supported Distros:

* CentOS 5.x
* RHEL 5.x

Tested TSM Client Versions:

* 6.2.1

Installation
------------
Copy TSM client install files to a webserver running on your puppetmaster at files/tsmclient

Install files are available at ftp://index.storesys.ibm.com/tivoli-storage-management/patches/client/v6r2/Linux/LinuxX86/v621

Alternatively, push them up to your local yum repository and serve them from there.

Copy tsmclient tarball to puppet module directory.

Configure a node on the tsm server matching the hostname of the client and add it to appropriate schedules.

Configure needed variables on the node manifest or via external modules:

* tsmserver
* tsmport
* tsmpassword

Add the module to the node definition or include it elsewhere.

`include tsm::client`

Author
------
Written by Richard Clark <richard@fohnet.co.uk>
Homepage: https://github.com/rdark/puppet-tsmclient


License
-------
GPL 2
