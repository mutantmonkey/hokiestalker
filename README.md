Hokie Stalker
=============

Query the Virginia Tech LDAP server for information about a person.
Licensed under the New BSD License.

There is a [Ruby port](https://github.com/benwr/hokiestalker) available, written by benwr. I have shamelessly ported some of his additional features back to my Python version.

## Prerequisites ##
* Python 2.7
* [python-ldap](http://www.python-ldap.org/)

## Installation ##
1. `git clone git://github.com/mutantmonkey/hokiestalker.git`
2. `ln -s /path/to/hokiestalker/hs.py /usr/bin/hs`
3. ???
4. Profit!

## Usage ##
* Search by PID, name, or email address: `hs <pid/name/email>`
* Search by name only: `hs -n <name>`
