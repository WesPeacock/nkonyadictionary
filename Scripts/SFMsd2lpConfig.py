#!/usr/bin/env python
# This program merges a Standard Format semantic categories file into a
# pre-existing XML file.
#
# The Semantic domains in SFM format with optional additional spaces
# between fields but not inside any field indicated by <>:
# \sfmarker <IgnoredButNotOptional> Name - can be multiple words <code>
# e.g.:
# \tx 4.    Dress and Adornment II.C.4
# After trailing white space is removed, lines less 5 characters are ignored
# lines not starting with \tx are ignored
# The format of the lines is taken from a file created by Tony Naden
#
# The codes in the XML file are preceded by a prefix.
# The XML records have the structure illustrated in this example:
# <categories visible="true" style="user">
#  <category code="TN_II.C.4">
#   <displayNames>
#    <displayName lang="en">Dress and Adornment</displayName>
#   </displayNames>
#  </category>
# </categories>
# 
# The <categories> element is a child to the root element.
# The structure of the XML data is from the Lexique Pro config file.
# ".updated" is appended to the input XML file name for the output.

from lxml import etree

XMLfileName='Nkolex in Unicode.lpConfig'
fileNameOfSemanticDomains='TNTHSHED.TXT'
codePrefix="TN_"

configTree=etree.parse(XMLfileName)
categories=configTree.find('categories')

# processing semantic domain list
for line in open(fileNameOfSemanticDomains):
    line=" ".join(line.strip().split()) # remove CRLF & multiple spaces
    if len(line) < 5: continue # formatting line
    marker=line.split(' ', 1)[0]
    if marker != "\\tx": continue
    linecode=codePrefix + line.rsplit(' ', 1)[1] # code from end of line
    line = line.rsplit(' ', 1)[0] + " " + linecode
    linetext=line.split(' ', 2)[2]
    path='//category[@code="' + linecode + '"]' # set up search matching category
    if categories.xpath(path):
        cat=categories.xpath(path)[0] # first category that matches the code
        if cat.find('displayNames/displayName') is not None:
            print cat.tag, cat.attrib['code'], "is already named '" + cat.findtext('displayNames/displayName') + "'"
        else:
            displayNames = etree.SubElement(cat, 'displayNames')
            displayName = etree.SubElement(displayNames, 'displayName', lang="en")
            displayName.text = linetext
    else: # Search for category failed, create a new one
        cat = etree.SubElement(categories, 'category')
        cat.set('code', linecode)
        displayNames = etree.SubElement(cat, 'displayNames')
        displayName = etree.SubElement(displayNames, 'displayName', lang="en")
        displayName.text = linetext

# sort the categories
categoriesSorted = sorted(categories.getchildren(), key=lambda x: x.get("code", "Unknown"))

# delete the categories
for cat in categoriesSorted:
    categories.remove(cat)

# create them in sorted order
for cat in categoriesSorted:
    categories.append(cat)

configTree.write(open(XMLfileName +".updated", 'w'), pretty_print=True, encoding="UTF-8")
