#!/usr/bin/env python
# -*- Mode: Python; indent-tabs-mode: nil -*-
# ***** BEGIN LICENSE BLOCK *****
# Version: MPL 1.1/GPL 2.0/LGPL 2.1
#
# The contents of this file are subject to the Mozilla Public License Version
# 1.1 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
# http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
# for the specific language governing rights and limitations under the
# License.
#
# The Original Code is [Open Source Virtual Machine].
#
# The Initial Developer of the Original Code is
# Adobe System Incorporated.
# Portions created by the Initial Developer are Copyright (C) 2005-2006
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#
# Alternatively, the contents of this file may be used under the terms of
# either the GNU General Public License Version 2 or later (the "GPL"), or
# the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
# in which case the provisions of the GPL or the LGPL are applicable instead
# of those above. If you wish to allow use of your version of this file only
# under the terms of either the GPL or the LGPL, and not to allow others to
# use your version of this file under the terms of the MPL, indicate your
# decision by deleting the provisions above and replace them with the notice
# and other provisions required by the GPL or the LGPL. If you do not delete
# the provisions above, a recipient may use your version of this file under
# the terms of any one of the MPL, the GPL or the LGPL.
#
# ***** END LICENSE BLOCK *****


import os, sys, re
from stat import *

class StatCache:
    def __init__(self):
        self._dict = {}

    def getStat(self, key):
        if not key in self._dict:
            try:
                self._dict[key] = os.stat(key)
            except OSError:
                self._dict[key] = None

        return self._dict[key]

    def getMTime(self, key):
        s = self.getStat(key);
        if s == None:
            return 0;

        return s.st_mtime

_statcache = StatCache()

def rebuildNeeded(file, dependencies, verbose):
    """Calculate whether a file needs to be rebuilt by comparing its timestamp
    against a list of dependencies.

    returns True or False"""

    f = _statcache.getMTime(file)
    if f == 0:
        if verbose:
            print >>sys.stderr, "Target %s doesn't exist" % file
        return True

    for dep in dependencies:
        d = _statcache.getMTime(dep)
        if d == 0:
            if verbose:
                print >>sys.stderr, "Target %s missing dependency %s" % (file, dep)
            return True
        if d > f:
            if verbose:
                print >>sys.stderr, "Target %s older than dependency %s" % (file, dep)
            return True

    return False

_fileFromLine = re.compile('^([^:]+): FORCE')

def rebuildsNeeded(files, outfile, verbose):
    """Write a makefile snippet indicating whether object files need to be
    rebuilt.

    @param files: a dictionary of { 'objfile', 'depfile' }"""

    oldrebuilds = {}
    do_write = False

    if os.path.exists(outfile):
        istream = open(outfile, "r")
        for line in istream:
            m = _fileFromLine.match(line)
            if m:
                oldrebuilds[m.group(1)] = None
        istream.close()
    else:
        print >>sys.stderr, "Writing %s: doesn't exist" % outfile
        do_write = True

    newrebuilds = []

    for (objfile, depfile) in files.items():
        rebuild = True

        try:
            d = open(depfile, "r")
            rebuild = \
                rebuildNeeded(objfile, \
                              [line.rstrip("\n\r") for line in d.readlines()],
                              verbose)
            d.close()

        except IOError:
            pass

        if rebuild:
            if verbose:
                print >>sys.stderr, "Scheduling %s for rebuilding" % objfile
            newrebuilds.append(objfile)

            if objfile in oldrebuilds:
                del oldrebuilds[objfile]
            else:
                do_write = True

    if do_write or len(oldrebuilds):
        print "Building %s" % outfile
        ostream = open(outfile, "w")
        for objfile in newrebuilds:
            ostream.write(objfile + ": FORCE\n")
        ostream.close()

if __name__ == "__main__":
    import sys
    import re

    _argExpr = re.compile("\\.ii?$")

    files = {}
    verbose = 'CALCDEPENDS_VERBOSE' in os.environ

    sys.argv.pop(0)
    if sys.argv[0] in ('-v', '--verbose'):
        verbose = True
        sys.argv.pop(0)

    outfile = sys.argv.pop(0)

    for objfile in sys.argv:
        depfile = _argExpr.sub(".deps", objfile)
        files[objfile] = depfile

    rebuildsNeeded(files, outfile, verbose)
