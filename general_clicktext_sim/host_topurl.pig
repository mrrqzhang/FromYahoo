DEFINE CMD `python get_host_click.py` ship('$gateway_working_dir/get_host_click.py');
DEFINE URL_NORM `python url_norm.py` ship('$gateway_working_dir/url_norm.py');

A0 = load '$input/*' USING PigStorage('\t') as (f1:chararray,f2:chararray,f3:int);
A = stream A0 through URL_NORM;
B1 = foreach A generate $1, $2;
B2 = group B1 by $0;
B = foreach B2 generate group, SUM(B1.$1);
url_click_host = stream B through CMD as (url:chararray,click:int,host:chararray);
C = group url_click_host by host;
D = foreach C {
        SA = order url_click_host by click DESC;
        SB = LIMIT SA 1;
        generate flatten(SB);
};
E = foreach D generate $2,$1,$0;
F = stream E through `awk -F"\t" '{if($2>100 && $1!="en.wikipedia.org"){print $1"\t"$3}else{print $1"\t"$1}}'`; 

store F into '$host_topurl.pig/host_topurl.gz';
