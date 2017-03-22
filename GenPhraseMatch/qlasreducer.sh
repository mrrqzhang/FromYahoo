export LD_LIBRARY_PATH=$PWD/qlas/lib64:$PWD/qlas/lib;
chmod 755 $PWD/qlas/bin64/qlas_analyze
chmod 755 $PWD/qlas/bin64/qlas_deserialize
sed "s:\/home\/y\/share\/qlas\/db-spell:$PWD\/qlas\/share\/qlas\/db-spell:g" $PWD/datapack/config.us.xml > $PWD/config.us.xml


#$PWD/qlas/bin64/qlas_analyze -C $PWD/config.us.xml -Y $PWD/qlas -y $PWD/qlas/conf/yell/libyell.config.qlas-devel -I $PWD/qlas/conf/internetlocality/config.txt  -R $PWD/datapack -i "-" -G

cut -f1 | $PWD/qlas/bin64/qlas_analyze -C $PWD/config.us.xml -Y $PWD/qlas -y $PWD/qlas/conf/yell/libyell.config.qlas-devel -I $PWD/qlas/conf/internetlocality/config.txt  -R $PWD/datapack -i "-" -G  | $PWD/qlas/bin64/qlas_thunk2tsv -q | awk -F'\t' '{if ($2==1) print $0}'
