import sys

#excluded = ['in','for','hotel','to','new','cheap','online','womens','flower','the','buy','of','home','and','free','hotels','sale','black','car','care','delivery','battery','mens','flowers','best','size','top','a','reviews','city','review','shoes','homes','rental','on','white','inn','shop','beach','shirt','discount','ca','women','batteries','hp','replacement','with','day','plus','find','san','blue','jobs','light','insurance','used','2','york','weather','school','t','near','kids','business','county','california','living','tickets','floral','order','red','north','deals','senior','house','men','set','park','by','long','la','3','college','tx','s','1','parts','university','green','real','west','rentals','local','book','eat','ny','estate','watch','health'] 

#excluded = ['for','in','online','new','cheap','sale','buy','car','best','to','of','free','the','and','womens','home','reviews','on','used','a','review','discount','top','mens','price','jobs','black','deals','women','with','shoes','insurance','auto','parts','school','replacement','size','find','prices','college','cars','phone','kids','white','2014','shop','men','flower','job','battery','hp','s','care','degree','programs','store','business','deal','ford','custom','service','set','card','ca','how','t','flowers','schools','at','light','cost','program','sales','california','texas','university','tx','blue','delivery','shoe','toyota','tv','2013','city','plus','computer','tires','2','small','ladies','com','4','truck','health','purchase','tire','shirt','dress','air','coupon','boots','bed','cards','accessories','girls','florida','cheapest','company','system','house','2012','batteries','get','credit','3','hotel','colleges','employment','training','samsung','work','san','classes','fl','furniture','book','baby','leather','printer','ink','internet','dealer','line','5','sets','red','outdoor','2015','by','vehicle','north','homes','my','honda','cover','chevy','coupons','high','download','class','design','shirts','software','courses','repair','affordable','medical','wall','wireless','mobile','laptop','clothing','chevrolet','rates','sport','order','rental','near','2011','up','cable','10','i','companies','table','gift','one','degrees','beach','services','lighting','jacket','electric','1','cell','day','nursing','mini','all','york','long','gas','dodge','holiday','large','education','water','search','game','cartridge','code','systems','pants','watch','is','christmas','storage','ny','local','inch','door','course','part','rated','gold','nike','security','bag','woman','management','nissan','pro','rate','career','plan','suv','kit','wood','boot','compare','pc','covers','low','good','virginia','what','website','your','loan','boys','performance','state','clearance','photo','la','clothes','kitchen','plans','6','2010','digital','weather','quote','lights','ohio','dresses','florist','dog','cartridges','golf','silver','phones','special','travel','check','office','pricing','floor','center','codes','green','glass','back','chair','jersey','application','hewlett','packard','value','filter','laser','seat','case','girl','floral','color','offers','gifts','stores','dealers','power','window','va','carolina','co','man','jackets','illinois','georgia','wholesale','bags','short','windows','mercedes','us','ga','il','room','from','x','wheels','print','county','quotes','pa','nc','promo','no','camera','sports','make','sell','grand','specials','apparel','bank','toner','south','wheel','womans','site','shops','discounts','iphone','series','video','pet','jeep','full','body','www','children','old','brown','florists','rentals','kid','garden','pink','7','st','masters','sneakers','games','area','tickets','style','american','jeans','oil','chicago','family','bath','art','senior','report','life','colorado','send','tech','pre','michigan','ratings','listings','master','real','mustang','toddler','tops','apple','food','child','lease','galaxy','big','personal','certification','dealership','e','careers','wedding','winter','smart','web','chairs','where','canon','west','range','loans','mattress','time','information','pennsylvania','dining','luxury','promotion','led','8','living','bar','arizona','radio','bike','lamp','sandals','dallas','products','bmw','vehicles','childrens','rooms','houston','rent','oh','steel','machine','bathroom','party','van','hotels','offer','patio','personalized','place','tax','washington','certificate','missouri','comparison','little','ma','box','v','kits','interior','classic','indiana','az','stock','music','nj','lawn','hot','boat','under','tables','2009','chrome','coat','swim','portable','mount','shorts','automobile','toys','king','mats','do','help','pickup','boy','account','hair','front','term','ring','shipping','list','gmc','tn','running','trucks','restaurant','charger','universities','pant','diamond','jewelry','medicare','national','accessory','motorcycle','ideas','hybrid','cases','shower','rims','audio','motor']

excluded=[]

wv=dict()
for line in sys.stdin:
    wv.clear()
    fields = line.strip('\r\t\n ').split('\t')
    q = fields[0]
    r = fields[1]
    for item in q.split():
  	wv[item]=q
    for item in r.split():
        wv[item]=q

    for key,data in wv.items():
	if key in excluded: continue
        sys.stdout.write('%s\t%s\n' % (key,data))      