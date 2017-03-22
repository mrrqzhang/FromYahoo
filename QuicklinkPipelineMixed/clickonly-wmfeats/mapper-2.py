import sys,re,math,os
sys.path.insert(0,'/'.join(__file__.split('/')[:-1]))
from genLibs import ConservativeNormalize as normalize


def process_url(url,donormalize=1):
    if donormalize: return normalize(url)
    else: return url


if __name__ == '__main__':
    largedomain=['ameblo.jp','yelp.com','zillow.com','tumblr.com','flickr.com','rakuten.co.jp','tripadvisor.com','expedia.co.in','pinterest.com','blogspot.com','linkedin.com','livingwithbugs.com','yahoo.co.jp','youtube.com','facebook.com','twitter.com','google.com','yahoo.com','wikipedia.org','ebay.com']
    dolower = 0
    if len(sys.argv) > 1:
        dolower = int(sys.argv[1])
    donormalize = 1
    if len(sys.argv) > 2:
        donormalize = int(sys.argv[2])

    for line in sys.stdin:
        url,clicks,views,linkflux,domain = line.strip('\r\t\n ').split('\t')
        if float(clicks)==0 and domain in largedomain: continue
        processed_url = process_url(url,donormalize)
        print '\t'.join([processed_url.lower() if dolower else processed_url, domain, clicks, views, url,linkflux])
 
