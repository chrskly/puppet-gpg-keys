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

define public ($keyname = undef, $keyfile = undef, $user = "ubuntu", $group = "ubuntu") {

    require => gpg-keys

    # Put the public key file into a user-private dir
    file { '/home/$user/.puppet-gpg-keys/$keyfile' :
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => 0600,
    }

    # Import the key into the keychain
    exec { 'gpg-keys-public-import-$keyfile' :
        require => File['/home/$user/.puppet-gpg-keys/$keyfile'],
        command => "gpg --import /tmp/$fkeyfile",
        path    => "/usr/bin",
        # ... but only if we don't already have it
        unless  => "gpg --list-keys $keyname",
    }

}
