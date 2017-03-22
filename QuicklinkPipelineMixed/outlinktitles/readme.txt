1. create high ctr file: hcat QuickLinkGeneration.abf/outlinktitles/joined/par* | python CompareTitle.py 6 11,3 0,1,4,5 True False 3 | tail -n+2 | awk -F '\t' '{print $1"\thttp://"$2"\t"$6"\t"$4}' | sort -t $'\t' -k1,1 -k4,4rg > highctr.0.1.100.200.match

2. update title bank: 
    a. hcat QuickLinkGeneration.abf/outlinktitles/joined/par* | python CompareTitle.py 6 11,3 0,1,4,5 > matchedtitles.0.1.100.200.algo.outlink
    b. tail -n+2 ../outlinktitles/matchedtitles.0.1.100.200.algo.outlink | cut -f1,2,6 | python ../Editorial/dqt2json.py qltitle_edit.onejson algo.outlink

change log:
1. 02/09/2015: replace hotmail.com quicklinks in highctr.0.1.100.200.match
from 
hotmail.com http://signout.live.com/content/dam/imp/surfaces/mail_signout/v7/mail/en-us.html Outlook 0.0935323758657775
hotmail.com http://hotmail.com/?mkt=pt-br Conta Da Microsoft 0.052096330504170195
hotmail.com http://mail.live.com Check 0.01980235824575667
hotmail.com http://hotmail.com/?mkt=en-gb 0.017191055289516786
hotmail.com http://windows.microsoft.com/en-US/windows-live/microsoft-account-help-center Windows Help 6.465140225374102E-4

to
hotmail.com http://hotmail.com/?mkt=pt-br Conta Da Microsoft 0.052096330504170195
hotmail.com http://mail.live.com Sign In 0.01980235824575667
hotmail.com http://windows.microsoft.com/en-US/windows-live/microsoft-account-help-center Windows Help 6.465140225374102E-4 
