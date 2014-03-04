puppet-gpg-keys
===============

Puppet module for distributing GPG keys

Sample usage

<
  gpg-keys::public{ 'publish' :
      keyname => 'publisher@foo.com',
      keyfile => 'publisher.gpg',
  }
>
