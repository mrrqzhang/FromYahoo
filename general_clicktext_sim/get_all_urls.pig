DEFINE CMD `python url_norm_self.py` ship('$gateway_working_dir/url_norm_self.py');

url = load 'usmlr/session/qu_click_view_qfreq.gz' USING PigStorage('\t') AS (f1:chararray,f2:chararray,f3:int,f4:int,f5:int);
url0 = filter url by (f3>=1) OR (f4>2);
url1 = foreach url0 generate $1;
A = load 'usmlr/sim/google_editorial.qur.txt.final' USING PigStorage('\t');
B = foreach A generate $1;
url2 = union url1, B;
url3 = stream url2 through CMD;
url4 = distinct url3;

store url4 into 'usmlr/sim/all_urls.gz';
