import sys
import re, string

def tokenize_punct(sent):
    regex = re.compile(r'([%s])' % re.escape(string.punctuation))
    sent = regex.sub(r' \1 ', sent)
    return sent
   

def remove_punct(sent):
    regex = re.compile(r'([%s])' % re.escape(string.punctuation))
    sent = regex.sub(r' ', sent)
    sent = re.sub('\s+',' ',sent)
    sent = re.sub('\s+$','',sent)
    sent = re.sub('^\s+','',sent)
    return sent

def normalize_wiki_entity(entity):
    entity = re.sub('\(.*\)','',entity, re.I)
    entity = remove_punct(entity)
    return entity.lower()





