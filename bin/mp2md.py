#! /usr/bin/python

# Simple script for reading in microPlatform JSON and converting to markdown

import sys,json
from pprint import pprint

data = json.load(sys.stdin)

print "\n## Summary\n"
summary = data['data']['notes']['summary']
print summary

print "## Highlights\n"
highlights = data['data']['notes']['highlights']
for highlight in data['data']['notes']['highlights']:
    print('- '+highlight+'')

print "\n## Components\n"
try:
    for part in data['data']['notes']['parts']:
        try:
            for project in part['projects']:
                print '\n### ' + project['name'] + '\n'

                try:
                    print '\n#### Features'
                    for feature in project['features']:
                        print '\n##### '+feature['heading'] + ': \n- ' + feature['summary'].replace('\n','\n').strip() + '\n'
                except KeyError:
                    print "- Not addressed in this update"

                try:
                    print '\n#### Bugs'
                    for bug in project['bug_fixes']:
                        print '\n##### '+bug['heading'] + ': \n- ' + bug['summary'].replace('\n','\n').strip() + '\n'
                        try:
                            for cve in bug['cves']:
                                print ' - [CVE-'+cve+ '](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-'+cve+')'

                        except KeyError:
                            print ''

                except KeyError:
                    print "- Not addressed in this update"
        except KeyError:
            print ""
except KeyError:
    print ""
