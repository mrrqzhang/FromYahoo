 cat ~/home17/recencyv2/USmarket/test2Don/data/config-0-0-0.txt | ~ciyaliao/bin/RunQueries -mode prod -market us -host i18ndev124 -fields cat_rich_rsslink -db testrss -add "FILTER:cat_rich_rsslink==1\npragma:noqcache,argoverride" -yqry 1 -port 155555 | less     [ruiqiang@irdev17 ~/scripts]$ cat ~/home17/recencyv2/USmarket/test2Don/data/config-0-0-0.txt | ~ciyaliao/bin/RunQueries -mode prod -market us -host i18ndev124 -fields cat_rich_rsslink -db testrss -add "FILTER:cat_rich_rsslink==1\npragma:noqcache,argoverride\nRssFCFilter:" -yqry 1 -port 155555

 

cat ~/home17/recencyv2/USmarket/test2Don/data/config-0-0-0.txt | ~ciyaliao/bin/RunQueries -mode prod -market us -host i18ndev124 -fields cat_rich_rsslink -db fconly-en-us -add "FILTER:cat_rich_rsslink==1\npragma:noqcache,argoverride" -yqry 1

cat a.1 | ~ciyaliao/bin/RunQueries -mode prod -market us -host idpproxy-yahoo1bucket.idp.inktomisearch.com -fields cat_rich_rsslink -db fconly-en-us -add "RssFCFilter:FILTER(cat_rich_rsslink==1)\npragma:noqcache,argoverride"

