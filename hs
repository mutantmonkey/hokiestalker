#!/usr/bin/python3
###############################################################################
# hs.py - Hokie Stalker
# Query the Virginia Tech people search service for information about a person.
# Available under the ISC License.
#
# https://github.com/mutantmonkey/hokiestalker
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
###############################################################################

import sys
import urllib.parse
import urllib.request

from hokiestalker import dsml
from hokiestalker import parse_addr

SEARCH_URL = "https://webapps.middleware.vt.edu/peoplesearch/PeopleSearch?"\
    "query={0}&dsml-version=2"


def row(rows, name, data):
    """Return a formatted row for printing."""
    if data is None:
        return

    if type(data) == str:
        rows.append("{0:20s}{1}".format(name + ':', data))
    else:
        rows.append("{0:20s}{1}".format(name + ':', data[0]))

        # print additional lines if necessary, trimming off the first row
        if len(data) > 1:
            for line in data[1:]:
                rows.append("{0:20s}{1}".format('', line))


def search(query):
    """Search LDAP using the argument as a query. Argument must be
    a valid LDAP query."""
    query = urllib.parse.quote(query)
    r = urllib.request.Request(SEARCH_URL.format(query), headers={
        'User-agent': 'hokiestalker/2.0',
        })
    f = urllib.request.urlopen(r)

    has_results = False
    results = dsml.DSMLParser(f)

    for entry in results:
        has_results = True

        rows = []
        names = []
        if hasattr(entry, 'displayName'):
            names.append(entry.displayName)

        if hasattr(entry, 'givenName') and hasattr(entry, 'sn'):
            if hasattr(entry, 'middleName'):
                names.append('{0} {1} {2}'.format(
                    entry.givenName,
                    entry.middleName,
                    entry.sn))
            else:
                names.append('{0} {1}'.format(
                    entry.givenName,
                    entry.sn))

        row(rows, 'Name', names)

        if hasattr(entry, 'uid'):
            row(rows, 'UID', entry.uid)

        if hasattr(entry, 'uupid'):
            row(rows, 'PID', entry.uupid)

        if hasattr(entry, 'major'):
            row(rows, 'Major', entry.major)
        elif hasattr(entry, 'department'):
            row(rows, 'Department', entry.department)

        if hasattr(entry, 'title'):
            row(rows, 'Title', entry.title)

        if hasattr(entry, 'postalAddress'):
            row(rows, 'Office', parse_addr(entry.postalAddress))

        if hasattr(entry, 'mailStop'):
            row(rows, 'Mail Stop', entry.mailStop)

        if hasattr(entry, 'telephoneNumber'):
            row(rows, 'Office Phone', entry.telephoneNumber)

        if hasattr(entry, 'localPostalAddress'):
            row(rows, 'Mailing Address', parse_addr(
                entry.localPostalAddress))

        if hasattr(entry, 'localPhone'):
            row(rows, 'Phone Number', entry.localPhone)

        if hasattr(entry, 'mail'):
            row(rows, 'Email Address', entry.mail)

        print("\n".join(rows))
        print()

    return has_results


if __name__ == '__main__':
    q = sys.argv[1:]
    s = search(' '.join(q))

    if not s:
        print("No results found")
