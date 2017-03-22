sed 's/\t/\n/g' | sed 's/|/\n/g' | sed 's/:/\t/g' | sort -t'	' -k$1,$1gr
