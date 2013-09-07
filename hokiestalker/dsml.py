import lxml.etree


class DSMLParser(object):
    namespace = '{http://www.dsml.org/DSML}'

    def __init__(self, f):
        try:
            xml = lxml.etree.parse(f)
        except lxml.etree.XMLSyntaxError:
            # if there is a syntax error, return an empty result iterator
            self.results = iter([])
            return

        self.results = xml.iterfind('{0}directory-entries/{0}entry'.format(
            self.namespace))

    def __iter__(self):
        return self

    def __next__(self):
        entry = self.results.__next__()
        attrs = {}
        for attr in entry.iterfind('{0}attr'.format(self.namespace)):
            attrs[attr.attrib['name']] = attr[0].text
        return type('DSMLEntry', (object,), attrs)
