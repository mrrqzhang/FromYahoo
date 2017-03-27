
export QLAS_HOME=/home/y
DATAPACK=/net/mlrnfs/vol/ss02/ruiqiang/qlas_datapack_0929/share/qlas/proxy-ish/db-qlas-US/Current-database/

SCORER_HOME=/net/mlrnfs/vol/ss01/ruiqiang/dev-qlas/qlas/misc/scorer

SCRIPT_HOME= 

~/scripts/qlas_train_scorer_qi_true.pl -h $QLAS_HOME/qlas -H $SCORER_HOME -R $DATAPACK  -C ./config.$TRAIN_DIR.us.xml -r ruiqiang -s 1 -T /net/mlrnfs/vol/ss02/ruiqiang/QICT/$TRAIN_DIR/training  -p $SCORER_HOME/data/mapping_from_editorial_to_eng.v2.txt  -i us -w 'num-jabba-matches:0=4 domain-lm=local,threshold=0.2/0.8,entities=place_name/business,weight=4' -d 12345 >& /net/mlrnfs/vol/ss02/ruiqiang/QICT/$TRAIN_DIR/training/training.log



