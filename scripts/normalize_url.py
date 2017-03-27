import sys,re,math,os,logging,traceback

def normalize(url):
        # caveats: 
        # home.[a-z]+: https://vetrecs.archives.gov/VeteranRequest/home.html
        # home: http://15dollarstore.com/s/home
        # home/index.html: http://www.boatracingfacts.com/home/index.html

        ret = url
        for p,q in [('^https?://',''),
                    ('^m\.',''),
                    ('^touch\.',''),
                    ('^www[0-9]?\.',''),
                    ('/$',''),  # strip forward slash at the end
                    ('/(index|home|default)\.[a-z]+$','')]:
            ret= re.sub(p,q,ret)
        return ret.strip('\r\t\n ')  


for line in sys.stdin:
    print normalize(line)

