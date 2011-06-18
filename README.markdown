# Hokie Stalker #
Query the Virginia Tech LDAP server for information about a person.
Licensed under the New BSD License.

There is a [Ruby Port](https://github.com/benwr/hokiestalker) available, written by benwr. I have shamelessly ported some of his additional features back to my Python version.

## Prerequisites ##
* Python 2.7
* [python-ldap](http://www.python-ldap.org/)

## Installation ##
1. Clone repository
2. Symlink /usr/bin/hs to hs.py in this repository.
3. ???
4. Profit!

## Usage ##
* Search by PID, name, or email address (in that order): `hs <pid/name/email>`
* Search by name or email address only: `hs <name/email>`
