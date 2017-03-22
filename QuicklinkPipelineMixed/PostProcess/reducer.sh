#!/usr/bin/sh

args1=$1
args2=$2
aliasdict=$3
worseqls=$4
# ================================= #
# Grid Post-Processing reducer code #
# ================================= #

python AddHighCtr.py $args1 | python AddHighCtr.py $args2 | python remove-bad-ql.py $worseqls |   python JoinAliasParallel.py $aliasdict
