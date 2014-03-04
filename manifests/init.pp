# = Class: gpg-keys
#
# This module distributes GPG keys to systems. For, y'know, encrption and stuff.
#
# == Parameters:
#
# == Actions:
#
# == Requires:
#
# == Sample Usage:
#

class gpg-keys {
    package { 'gnupg' :
        ensure => installed,
    }
}
