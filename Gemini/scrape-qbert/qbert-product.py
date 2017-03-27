import logging
import subprocess
import os
import urllib
from xml.dom import minidom
import time
import hashlib
import codecs
import sys

logging.basicConfig(level=logging.DEBUG, format='%(levelname)s:%(name)s:%(asctime)s| %(message)s', datefmt='%Y-%m-%d %I:%M:%S%p')
logger = logging.getLogger('com.yahoo.gemini.ss.qbert.scrape')

class Qbert:
  def __init__(self):
    # TODO: review options: config=hmspo, mkt=us.
#    self.end_point = 'http://qb2.cbs.cb.ne1.yahoo.com/qbert?uq=%s&config=hmspo&mkt=us'
    self.end_point = 'http://qb5.cbs.cb.bf1.yahoo.com:4080/qbert?uq=%s&config=hmspo&mkt=us'
    self.devnull = open(os.devnull, 'w')
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout)

  def load_query_file(self, filename):
    # g^A18938272^A16498^A1603.3300024867058
    # assume 1st column is the query or canon we care about.
    logger.debug('query file to load: %s', filename)
    qmap = {}
    f = open(filename)
    for line in [line.strip() for line in f if len(line.strip()) > 0]:
      items = line.split('')
      q = items[0]
      assert(len(q) != 0)
      qmap[q] = 0
    logger.debug('distinct queries: %d', len(qmap.keys()))
    return qmap.keys()

  def detect_bad_query(self, q):
    special = '"'
    special += "'"
    count = len([e for e in q if e in special])
    return True if count > 0 else False

  def prepare_command(self, q):
    cmd = []
    cmd += ['/usr/bin/curl']
    url = (self.end_point % urllib.quote_plus(q))
    cmd += [url]
    logger.debug('==============================================================')
    logger.debug('raw query: %s', q)
    logger.debug('qbert url: %s', url)
    return cmd

  def execute(self, cmd):
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=self.devnull)
    [out, err] = p.communicate()
    return out

  def xml_get_node(self, root, *path):
    if root is None:
      return None
    curr = root
    for p in path:
      t = curr.getElementsByTagName(p)
      if len(t) == 1:
        curr = t[0]
      else:
        return None
    return curr

  def xml_get_nodes(self, root, key):
    if root is None:
      return None
    nodes = root.getElementsByTagName(key)
    return nodes

  def xml_get_attributes(self, root, *keys):
    values = []
    for k in keys:
      n = root.getElementsByTagName(k)
      if len(n) == 1:
        n = n[0]
        values.append(n.firstChild.data)
      else:
        values.append('')
    return values

  def parse_xml(self, blob):
    if blob is None:
      return None
    if len(blob.strip()) == 0:
      return None
    xmldoc = minidom.parseString(blob)
    return xmldoc

  def retrieve_qbert(self, q, retry=5):
    cmd = self.prepare_command(q)
    for i in range(retry):
      try:
        blob = self.execute(cmd)
        xmldoc = self.parse_xml(blob)
      except:
        time.sleep(2)
        continue
      suggestions_node = self.xml_get_node(xmldoc, 'QBert', 'Suggestions')
      suggestion_nodes = self.xml_get_nodes(suggestions_node, 'Suggestion')
      if suggestion_nodes is None:
        logger.error('raw query [%s] qbert exception.', q)
        return None
      ret = []
      logger.debug('raw query [%s] qbert return=%d', q, len(suggestion_nodes))
      for s in suggestion_nodes:
        vals = self.xml_get_attributes(s, 'rank', 'substitute', 'type', 'RelScore')
        (rank, substitute, type, score) = vals
        ret.append({'rank':rank, 'substitute':substitute, 'type':type, 'score':score})
        logger.debug({'rank':rank, 'substitute':substitute, 'type':type, 'score':score})
      return ret

  def dump_output(self, q, substitutes):
    if substitutes is not None:
      if len(substitutes) > 0:
        out = [q, str(len(substitutes))]
        out.append(''.join(['0', q, 'SELF', '9999']))
        for s in substitutes:
          out.append(''.join([s[k] for k in ['rank', 'substitute', 'type', 'score']]))
        logger.info(''.join(out))
  
  def dump_smt_input(self, q, substitutes):
    # output format: f1, f2, f3, f4, kw1 [tab-separated]
    # f2:unique query id.
    # f1: URL encoded query.
    # f2: MD5sum of query.
    # f3: rank
    # f4: score. * 1000.0
    if substitutes is not None:
      if len(substitutes) > 0:
        encoded = urllib.quote_plus(q)
        uid = 'QBERTAPI-'+hashlib.md5(q).hexdigest()
        out = [encoded, uid, '0', '9999', q]
        print '\t'.join(out)
        for s in substitutes:
          score = ('%d' % (float(s['score']) * 1000.0))
          out = [encoded, uid, s['rank'], score, s['substitute']]
          print '\t'.join(out)

if __name__ == '__main__':
  qbert = Qbert()
  #queries = qbert.load_query_file('raw_query.csv')
  canon = sys.argv[1]
  queries = qbert.load_query_file(canon)
  for q in queries:
    substitutes = qbert.retrieve_qbert(q)
    try:
       qbert.dump_output(q, substitutes)
#       qbert.dump_smt_input(q, substitutes)
    except: pass
    time.sleep(0.1)

