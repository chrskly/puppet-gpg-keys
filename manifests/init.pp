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

class gpg_keys {
	#is it version2 that use libgcrypt. we have some probleswith it
	package { 'gnupg':
      ensure => 'absent',
    }
    #we want version1
    package { 'gnupg1' :
        ensure => installed,
    }
}
