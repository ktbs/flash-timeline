#! /usr/bin/python

import sys
import re
import collections

pattern = re.compile("dgettext\(\S+,\s*(.+?)\s*\)")

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print "Syntax: %s output.pot source.(as|mxml)..." % sys.argv[0]
        sys.exit(1)

    col = collections.OrderedDict()

    for fname in sys.argv[2:] :
        with open(fname) as f:
            lines = f.readlines()
        for n, line in enumerate(lines):
            params = pattern.findall(line)
            for label in params:
                label = label.strip()
                if label[0] == "'":
                    # replace with double quotes
                    label = '"' + label[1:-1].replace('"', '\\"') + '"'
                if label[0] != '"' or label[-1] != '"':
                    print "Error: bad quotes for line %d:\n%s" % (n, line)
                    continue
                if label in col:
                    if col[label][-1] == "\n":
                        col[label] += '#: %s:%d\n' % (fname, n + 1)
                    else:
                        col[label] += ' %s:%s\n' % (fname, n + 1)
                else:
                    col[label] = '#: %s:%d' % (fname, n + 1)

    with open(sys.argv[1], 'w') as output:
        for k, v in col.iteritems():
           output.write(v)
           if v[-1:] != "\n":
             output.write("\n")
           output.write("msgid " + k + "\nmsgstr \"\"\n\n")
