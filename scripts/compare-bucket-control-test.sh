

python /homes/ruiqiang/scripts/getCommonQry.new.py control.dat test.dat
sort -t "`echo \\t`" -k 2 control.dat.common >& control.dat.common.sorted
python /homes/ruiqiang/scripts/calc_ctrs_by_qry.py control.dat.common.sorted 6 control.dat.ctr
sort -t "`echo \\t`" -k 2 test.dat.common >& test.dat.common.sorted
python /homes/ruiqiang/scripts/calc_ctrs_by_qry.py test.dat.common.sorted 6 test.dat.ctr
python /homes/ruiqiang/scripts/getCommonQry.py control.dat.ctr test.dat.ctr bucketdiff.ctr 0


#perl /homes/ruiqiang/scripts/getUrlDiff.pl /grid/0/tmp/ruiqiang/control.dat.ctr /grid/0/tmp/ruiqiang/test.dat.ctr >& url.dif
#perl /homes/ruiqiang/scripts/data-merge.pl query.seg url.dif  >& url2.dif
#perl /homes/ruiqiang/scripts/data-merge.pl query-in-dic.txt url2.dif >& final.res
