#new sample from fbcm14
sh ../../smtrewrite/dopig.sh join-bidterm2.pig "-p input=selected-queries-from-fbcm14.hoyi.rewrite.txt.top50 -p out=temp2"
sh ../../smtrewrite/dopig.sh join-bidterm2.pig "-p input=selected-queries-from-fbcm14.rewrite.txt -p out=temp"


#make query as key
#sh ../../smtrewrite/dopig.sh join-bidterm2.pig "-p input=qbert-product-hoyi-rtl-sample-results.top30 -p out=temp2"
#sh ../../smtrewrite/dopig.sh join-bidterm2.pig "-p input=b.rtl.greedy.top30 -p out=temp"

#rewrite as key
#sh ../../smtrewrite/dopig.sh join-bidterm.pig "-p input=qbert-product-hoyi-rtl-sample-results.top30 -p out=temp2"
#sh ../../smtrewrite/dopig.sh join-bidterm.pig "-p input=b.rtl.greedy.top30 -p out=temp"
