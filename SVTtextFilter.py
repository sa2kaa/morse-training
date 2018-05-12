#!/usr/bin/python
# -*- coding: latin-1 -*-
#
# The purpose of this script is to convert content from 
# https://www.svt.se/svttext/web/pages/100.html that has been parsed by
# html2text.py to a text version suitable for morse transmission.
# Typically replace 100.html with some more interesting page.
#
# Usage: ./html2text <url>|./SVTtextFilter
#
# Coding definition on the second line is required to make replacements of swedish charcters pass
# without warning according to https://www.python.org/dev/peps/pep-0263/.
#
#                  Copyright (C) 2018 Olof Tångrot (SA2KAA)
#
#  This program is free software; you  can redistribute it and/or modify it
#  under the terms of the GNU General Public License version 2 as published
#  by the Free Software Foundation (http://www.gnu.org/licenses/gpl.html).
#
import sys
import re

n = 0
contentLines = 0
catenateLines = False
for l in sys.stdin:
    l = ' '.join(l.split()) # Remove multiple wihte space.
    l.replace('[','/')
    if n == 0: # Start searching for the double empty row that marks the beginning of the content block.
        if not l.strip(): # First test for an empty line.
            n = n + 1
    elif n == 1:
        if not l.strip(): # Test for a consequtive empty line.
            n = n + 1
        else:
            n = 0 # Reset double empty row test.
    elif n == 2: # Now the content block begins
        contentLines = contentLines + 1 # Just count content lines.
        if not l.strip():
            pass # Don't print empty lines.
        elif contentLines < 24: # Stop beginning after the excluded
            l = l.replace('[','/')
            l = l.replace(']','/')
            l = l.replace('(','/')
            l = l.replace(')','/')
            l = l.upper()
            l = l.replace('å','Å')
            l = l.replace('ä','Ä')
            l = l.replace('ö','Ö')
            l = l.replace('é','E')
            l = l.replace('É','E')
		
            if catenateLines:
                l = last + l
                catenateLines = False
            if l.endswith('-'): 
                last = re.sub('-$', '', l) # Remove '-' at lineend and save for catenation with the next line
                catenateLines = True # flag that the last word was broken by hypen.
            else:
                print l

