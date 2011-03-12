class puppet {

    package { "puppet":
        ensure => "installed",
    }

    # Replace the server variable in clients' puppet.conf
    file { "/etc/puppet/puppet.conf":
        ensure => "present",
        content => "# Puppet master/client configuration file
#
#--------------------------------------------------------
# This file is initially installed by the puppet-config
# svn repository hosted at system://, but the subsequent
# updates are managed by puppet itself.
#
# This file is part of the 'puppet' puppet module,
# located in /etc/puppet/modules/puppet/manifests/init.pp
#
#--------------------------------------------------------
#

[main]
server = $server
logdir = /var/log/puppet
vardir = /var/lib/puppet
ssldir = /var/lib/puppet/ssl
rundir = /var/run/puppet
factpath = \$vardir/lib/facter
pluginsync = true

# For external node classifier to work
external_nodes = /etc/puppet/bin/puppet-node-classifier
node_terminus = exec

[master]
templatedir = /var/lib/puppet/templates
modulepath = /etc/puppet/modules
reports = store,log,tagmail"
    }

    # First time usage to request/sign certificate
    file { "/usr/local/bin/puppet-bootstrap":
        ensure => "present",
        source => "puppet:///puppet/scripts/puppet-bootstrap",
        owner  => "root",
        group  => "root",
        mode   => 775,
    }

    # For every time you want to run puppet "one-shot"
    file { "/usr/local/bin/puppet-launch":
        ensure => "present",
        source => "puppet:///puppet/scripts/puppet-launch",
        owner  => "root",
        group  => "root",
        mode   => 775,
    }

    service { "puppet":
        enable => "false",
    }

}

