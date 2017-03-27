datadir=/net/irdev8/export/home/inagakiy/jpmlr8.0/test/


#~yichang/bin/zhaohui_tool/Cfile2DCG /net/irdev4/export/crawlspace/sriharir/se_mlr/libmlr64-Mar-10-08/jp/jp_gbrank_mwq_tau0.2_525tree.c $datadir/all_features.non_la.mwq.csv $datadir/query_url.non_la.mwq.txt $datadir/judgedset.txt.trimmed 0 >& expr1/product-mwq.dcg
#~yichang/bin/zhaohui_tool/Cfile2DCG  /net/irdev4/export/crawlspace/sriharir/se_mlr/libmlr64-Mar-10-08/jp/jp_gbrank_1wq_tau0.2_600tree.c $datadir/all_features.non_la.1wq.csv $datadir/query_url.non_la.1wq.txt $datadir/judgedset.txt.trimmed 0 >& expr1/product-1wq.dcg
#~yichang/bin/zhaohui_tool/Cfile2DCG /home/sriharir/irdev4/se_mlr/libmlr519-Oct-08-07/jp/zz.atvt.0/mod0.c $datadir/all_features.la.csv  $datadir/query_url.la.txt $datadir/judgedset.txt.trimmed 0 >& expr1/product-ascii.dcg


#~yichang/bin/zhaohui_tool/Cfile2DCG /net/irdev17/export/crawlspace/ruiqiang/jpmlr-expr/gbrank2/task2.tree855.mword.cut.c  $datadir/all_features.non_la.mwq.csv $datadir/query_url.non_la.mwq.txt $datadir/judgedset.txt.trimmed 0 >& candidate-mwq.dcg

#~yichang/bin/zhaohui_tool/Cfile2DCG /net/irdev17/export/crawlspace/ruiqiang/jpmlr-expr/gbrank2/task22.tree1480.1word.cut.c $datadir/all_features.non_la.1wq.csv $datadir/query_url.non_la.1wq.txt $datadir/judgedset.txt.trimmed 0 >& candidate-1word.dcg

#~yichang/bin/zhaohui_tool/Cfile2DCG /net/irdev17/export/crawlspace/ruiqiang/jpmlr-expr/gbrank2/task3.tree850.ascii.cut.c  $datadir/all_features.la.csv  $datadir/query_url.la.txt  $datadir/judgedset.txt.trimmed 0 >& candidate-ascii.dcg


#cat expr1/product-mwq.dcg expr1/product-1wq.dcg expr1/product-ascii.dcg | awk '{if($1 !~/query/ && $1 !~ /overall/ && NF>1 ) print $0}' >! ../expr1/product-sum.dcg
cat candidate-mwq.dcg candidate-1word.dcg candidate-ascii.dcg | awk '{if($1 !~/query/ && $1 !~ /overall/ && NF>1 ) print $0}' >! candidate-sum.dcg

python /net/irdev1/export/crawlspace/zhaohui/tools/signtest/wilcoxon.newversion.py ../expr1/product-sum.dcg candidate-sum.dcg 
