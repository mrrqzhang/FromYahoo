2016/02/16
head -9000 phrasematch-to-editor.txt | tail -3000 | sed "s/^ *[[:digit:]]* //g" | awk -F "\t" '{if(match($1,$2) && $0!~/site:/ && $0!~/Template by/ && $2!="" && $1!=$2 && $0!~/\"buy /) print $0}' > phrasematch-to-editor.3K2.txt

2016/02/11
head -6000 phrasematch-to-editor.txt | tail -3000 | sed "s/^ *[[:digit:]]* //g" | awk -F "\t" '{if(match($1,$2) && $0!~/site:/ && $0!~/Template by/ && $2!="" && $1!=$2 && $0!~/\"buy /) print $0}'

2016/02/09
head -3000 phrasematch-to-editor.txt | tail -2000 | sed "s/^ *[[:digit:]]* //g" | awk -F "\t" '{if(match($1,$2) && $0!~/site:/ && $0!~/Template by/ && $2!="" && $1!=$2) print $0}' 

#get ad title
hcat /projects/qrw/ruiqiang/GeminiBuckets/nonWLdump/part* | gunzip | grep PHRASE | grep n1 | awk -F "\t" '{print $2"\t"$8"\t"$7"\t"$14"\t"$11"\t"$12"\t"$13}' | sort | uniq >& a.1

hcat /projects/qrw/ruiqiang/GeminiBuckets/nonWLdump/part* | gunzip | grep PHRASE | grep n1 | awk -F "\t" '{print $2"\t"$8"\t"$7"\t"$13}' | sort | uniq >& a.1

#sed "s/^ *[[:digit:]]* //g" a.1 | awk -F "\t" '{if(match($1,$2)) print $0}'

