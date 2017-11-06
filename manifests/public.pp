# = Class: gpg-keys::public
#
# This defined type places a public key in the keychain of the host
#
# == Parameters:
#
# == Actions:
#
# == Requires:
#
# == Sample usage:
#  gpg-keys::public{ 'publish' :
#      keyname => 'publisher@foo.com',
#      keyfile => 'publisher.gpg',
#  }
#
#  You can optionally specify user + group to override the defaults of 'ubuntu'

define gpg_keys::public (
    $keyname = undef, 
    $keyfile = undef, 
    $user    = 'noc', 
    $group   = 'noc',
) {

    include gpg_keys

    # Put the public key file into a user-private dir
    file { "/home/${user}/.puppet-gpg-keys/" :
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '0600',
    }
    file { "/home/${user}/.puppet-gpg-keys/${keyfile}" :
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => '0600',
        source => "puppet:///modules/gpg-keys/${keyfile}",
    }

    # Import the key into the keychain
    exec { "gpg --import /home/${user}/.puppet-gpg-keys/${keyfile}" :
        require => [
            File["/home/${user}/.puppet-gpg-keys/${keyfile}"],
            Package['gnupg']
        ],
        user    => $user,
        path    => '/usr/bin',
        # ... but only if we don't already have it
        unless  => "gpg --list-keys ${keyname} >/dev/null 2>&1",
    }

}
