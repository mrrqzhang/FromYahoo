pigfile=$1
hadoop fs -copyFromLocal canon.tar.gz .
pig -Dpig.additional.jars="lib/NearVariantForVCanon.jar:./lib/javaCanon.jar" -Dmapreduce.map.env="JAVA_HOME=/home/gs/java/jdk64/current,LD_LIBRARY_PATH=./canon/canon/lib64" -Dmapreduce.reduce.env="JAVA_HOME=/home/gs/java/jdk64/current,LD_LIBRARY_PATH=./canon/canon/lib64" -Dpig.tmpfilecompression=false -Dyarn.app.mapreduce.am.env="JAVA_HOME=/home/gs/java/jdk64/current" -Dyarn.app.mapreduce.am.admin.user.env="LD_LIBRARY_PATH=/home/gs/hadoop/current/lib/native/Linux-amd64-64" -Dmapred.child.java.opts="-Xmx1200m -Djava.library.path=./canon/canon/lib64:/home/gs/hadoop/current/lib/native/Linux-amd64-64" -Dmapred.child.env="LD_LIBRARY_PATH=./canon/canon/lib64:/home/gs/hadoop/current/lib/native/Linux-amd64-64" -Dmapred.job.map.memory.mb=3548 -Dmapred.job.reduce.memory.mb=3548 -Dmapred.cache.archives="canon.tar.gz#canon" -Dmapred.create.symlink=yes -Dmapreduce.admin.user.env="LD_LIBRARY_PATH=/home/gs/hadoop/current/lib/native/Linux-amd64-64" -Dmapreduce.job.acl-view-job=* -Dmapreduce.job.acl-modify-job=* -Dmapreduce.map.output.compress=false -f $pigfile
