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
import json

from hokiestalker import parse_addr

SEARCH_URL = "https://apps.middleware.vt.edu/v1/persons/ldap/fuzzysearch?"\
    "query={0}"

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

def jhasattr(obj, attr):
    return attr in obj.keys()

def search(query):
    """Search LDAP using the argument as a query. Argument must be
    a valid LDAP query."""
    query = urllib.parse.quote(query)
    r = urllib.request.Request(SEARCH_URL.format(query), headers={
        'User-agent': 'hokiestalker/2.0',
        })
    f = urllib.request.urlopen(r)

    has_results = False
    results = json.loads(f.read())

    for entry in results:
        has_results = True

        rows = []
        names = []
        if jhasattr(entry, 'displayName'):
            names.append(entry.get("displayName")[0])

        if jhasattr(entry, 'givenName') and jhasattr(entry, 'sn'):
            if jhasattr(entry, 'middleName'):
                names.append('{0} {1} {2}'.format(
                    entry.get("givenName")[0],
                    entry.get("middleName")[0],
                    entry.get("sn")[0]))
            else:
                names.append('{0} {1}'.format(
                    entry.get("givenName")[0],
                    entry.get("sn")[0]))

        row(rows, 'Name', names)

        if jhasattr(entry, 'uid'):
            row(rows, 'UID', entry.get("uid")[0])

        if jhasattr(entry, 'uupid'):
            row(rows, 'PID', entry.get("uupid")[0])

        if jhasattr(entry, 'major'):
            row(rows, 'Major', entry.get("major")[0])
        elif jhasattr(entry, 'department'):
            row(rows, 'Department', entry.get("department"))

        if jhasattr(entry, 'title'):
            row(rows, 'Title', entry.get("title")[0])

        if jhasattr(entry, 'postalAddress'):
            row(rows, 'Office', parse_addr(entry.get("postalAddress")[0]))

        if jhasattr(entry, 'mailStop'):
            row(rows, 'Mail Stop', entry.get("mailStop")[0])

        if jhasattr(entry, 'telephoneNumber'):
            row(rows, 'Office Phone', entry.get("telephoneNumber")[0])

        if jhasattr(entry, 'localPostalAddress'):
            row(rows, 'Mailing Address', parse_addr(
                entry.get("localPostalAddress")[0]))

        if jhasattr(entry, 'localPhone'):
            row(rows, 'Phone Number', entry.get("localPhone")[0])

        if jhasattr(entry, 'mailPreferredAddress'):
            row(rows, 'Email Address', entry.get("mailPreferredAddress")[0])

        print("\n".join(rows))
        print()

    return has_results


if __name__ == '__main__':
    q = sys.argv[1:]
    s = search(' '.join(q))

    if not s:
        print("No results found")
