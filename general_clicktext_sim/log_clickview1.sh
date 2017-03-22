source config.sh
scp log_clickview.pig $gateway_dir
scp qry_set $gateway_dir
ssh $grid 'hadoop fs -rm -skipTrash usmlr/session/qry_set'
ssh $grid 'cd '"$gateway_working_dir"';hadoop fs -copyFromLocal qry_set usmlr/session'
foreach year (2013)
foreach month (06 07 08)
foreach period (0 1 2 3)
set range = $year$month$period
echo 'processing '$range
ssh $grid 'hadoop fs -rm -r -skipTrash usmlr/session/click'"$range"'.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash usmlr/session/view'"$range"'.gz'
ssh $grid 'hadoop fs -rm -r -skipTrash usmlr/session/qfreq'"$range"'.gz'
ssh $grid 'cd '"$gateway_working_dir"';pig -Dmapred.job.queue.name=adhoc -Dmapred.map.tasks.speculative.execution=true -Dmapred.reduce.tasks.speculative.execution=true -Dmapred.child.java.opts="-server -Xmx1280m -Djava.net.preferIPv4Stack=true" -Dmapred.min.split.size=2147483648 -p date_range="'"$range"'" log_clickview.pig'
end
end
end
