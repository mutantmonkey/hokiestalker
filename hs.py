#!/usr/bin/python2
################################################################################
# hs.py - Hokie Stalker
# Query the Virginia Tech LDAP server for information about a person
#
# author: mutantmonkey <mutantmonkey@gmail.com>
################################################################################

import ldap

LDAP_URI = "ldap://directory.vt.edu"

l = ldap.initialize(LDAP_URI)

"""Return a formatted row for printing."""
def row(name, data):
	out = "%-20s%s" % (name + ":", data[0])

	# print additional lines if necessary, trimming off the first row
	if len(data) > 1:
		for line in data[1:]:
			out += "\n%20s%s" % ('', line)

	return out

"""Parse the address from an LDAP response where $ is used to separate lines."""
def parse_addr(data):
	addr = data[0].split('$')
	return addr

"""Search LDAP using the argument as a query. Argument must be a valid LDAP query."""
def search(query):
	result = l.search_s('ou=People,dc=vt,dc=edu', ldap.SCOPE_SUBTREE, query)
	if len(result) <= 0:
		return False

	for dn, entry in result:
		print row('Name', entry['cn'])
		print row('UID', entry['uid'])

		if 'uupid' in entry:
			print row('PID', entry['uupid'])

		if 'major' in entry:
			print row('Major', entry['major'])
		elif 'department' in entry:
			print row('Department', entry['department'])

		if 'title' in entry:
			print row('Title', entry['title'])

		if 'postalAddress' in entry:
			print row('Office', parse_addr(entry['postalAddress']))

		if 'mailStop' in entry:
			print row('Mail Stop', entry['mailStop'])

		if 'telephoneNumber' in entry:
			print row('Office Phone', entry['telephoneNumber'])

		if 'localPostalAddress' in entry:
			print row('Mailing Address', parse_addr(entry['localPostalAddress']))

		if 'localPhone' in entry:
			print row('Phone Number', entry['localPhone'])

		if 'mail' in entry:
			print row('Email Address', entry['mail'])

		print 

	return True

q = 'presidente'

# initially try search by PID
s = search('uupid=%s' % q)

# try partial search on CN if no results found for PID
if not s:
	s = search('cn=*%s*' % q)

# try email address if no results found for PID or CN
if not s:
	s = search('mail=%s*' % q)

if not s:
	print "No results found"

