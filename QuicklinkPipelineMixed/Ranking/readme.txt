parent_url: domain url	
url	: ql url
nviews	: ql page view conditional on this domain ( page views of session with qls )
nviews_cond	: nviews less those views not clicked the search results with the same domain by user. user has no search intent for this domain. 
nclicks	: ql clicks
nviews_dom: domain page view count*6
nclicks_dom: sum(nclicks)	
ctr	: nclicks/nviews
ctr_cond: nclicks/nviews_cond

