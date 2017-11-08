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
#      trustfile => 'ownetrust.gpg'.
#  }
#
#  You can optionally specify user + group to override the defaults of 'ubuntu'

define gpg_keys::public (
    $keyname   = undef, 
    $keyfile   = undef, 
    $trustfile = undef,
    $user      = 'noc', 
    $group     = 'noc',
) {

    include gpg_keys

    # Put the public key file into a user-private dir
   
    file { "/home/${user}/.gnupg/${keyfile}" :
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => '0600',
        source => "puppet:///modules/gpg-keys/${keyfile}",
    }->
    file { "/home/${user}/.gnupg/${trustfile}" :
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => '0600',
        source => "puppet:///modules/gpg-keys/${trustfile}",
    }
    # Import the key into the keychain
    exec { "gpg --no-secmem-warning --batch --yes --import /home/${user}/.gnupg/${keyfile}" :
        user    => $user,
        path    => '/usr/bin',
        require => [
            File["/home/${user}/.gnupg/${keyfile}"],
            Package['gnupg1']
        ],
        # ... but only if we don't already have it
        unless  => "gpg --list-keys ${keyname} >/dev/null 2>&1",
    }
    exec { "gpg --no-secmem-warning --batch --yes --import-ownertrust /home/${user}/.gnupg/${trustfile}" :
        user    => $user,
        path    => '/usr/bin',
        require => [
            File["/home/${user}/.gnupg/${trustfile}"],
            Package['gnupg1']
        ],
        # ... but only if we don't already have it
        unless  => "gpg --list-keys ${keyname} >/dev/null 2>&1",
    }

}
