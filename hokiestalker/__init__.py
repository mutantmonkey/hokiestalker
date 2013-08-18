def parse_addr(data):
    """Parse the address from an LDAP response when $ is used to
    separate lines."""
    if data is None:
        return None
    addr = data.split('$')
    return addr
