Hokie Stalker
=============

Query the Virginia Tech people search service for information about a person.
Licensed under the ISC License.

There is a [Ruby port](https://github.com/benwr/hokiestalker) available,
written by benwr. I have shamelessly ported some of his additional features
back to my Python version.

## Prerequisites ##
* Python 3.x
* [lxml](http://lxml.de/)

## Installation ##
1. `git clone git://github.com/mutantmonkey/hokiestalker.git`
2. `ln -s /path/to/hokiestalker/hs.py /usr/bin/hs`
3. ???
4. Profit!

## Usage ##
* Search by PID, name, or email address: `hs <pid/name/email>`
