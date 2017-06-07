#! /usr/bin/env python
import sys
import re

for l in sys.stdin:
    if re.search('Alignment type:', l):
        fp = l.split('<a href="')[0]
        print >>sys.stderr, re.sub('<.*?>', '\n', fp)
        url = l.split('<a href="')[1].split('">')[0]
        fn = url.split('/')[-1]
        print >>sys.stdout, 'https://www.hiv.lanl.gov/%s ' % url
        break

