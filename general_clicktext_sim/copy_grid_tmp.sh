# copy $3 at $1 to $4 at $2
# csh copy_grid.sh $zt $ob local/primary/dirname local/primary
# csh -x copy_grid.sh $nb $zt /projects/localsearch/data/local/index/archive/20131022 /user/ckang/local/archive
set source = `echo $3 | awk -F'/' '{print $NF}'`
#ssh $1 'rm -r /grid/0/tmp/ckang/'"$source"''
#ssh $2 'rm -r /grid/0/tmp/ckang/'"$source"''
#ssh $1 'hadoop fs -copyToLocal '"$3"' /grid/0/tmp/ckang'
#ssh $1 'scp -r /grid/0/tmp/ckang/'"$source"' '"$2"'\:/grid/0/tmp/ckang'
#ssh $2 'hadoop fs -rm -r '"$4"'/'"$source"''
ssh $2 'hadoop fs -copyFromLocal /grid/0/tmp/ckang/'"$source"' '"$4"''
