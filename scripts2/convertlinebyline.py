# /export/crawlspace/ykonda/convertlinebyline.py
# given a filename, converts line by line from EUCJP to UTF8 and create a file with .utf8 attached at the end
# usage:
#   python convertlinebyline filenametoconvert

import sys

try:
    filenametoconvert = sys.argv[1]
except IndexError:
    print "usage:"
    print " python convertlinebyline filenametoconvert"
    sys.exit()

outfd = open(filenametoconvert+".utf8","w")
for line in open(filenametoconvert,"r"):
    try:
        myline = line.strip("\n").split("\t")
        query = myline[1]
        query = query.decode("euc-jp").encode("utf-8")
        myline[1] = query
        try:
            label = myline[5]
            label = label.decode("euc-jp").encode("utf-8")
            myline[5] = label
        except Exception, inst:
            pass
        outfd.write("\t".join(myline)+"\n")
    except UnicodeDecodeError, inst:
        continue
outfd.close()
