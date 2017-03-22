Procedures
-----------
1. When new editorial titles come in, arrange it in the tsv format of domain, ql, title; domain, ql do not need to be normalized
2. A master json file qltitle_edit.onejson needs to be updated
3. Run `cat dqt.tsv | python dqt2json.py qltitle_edit.onejson label` ; this will update the onejson file, and also create a backup file, qltitle_edit.onejson.bak, overriding the previous backup file

Action Log
-----------
1. cut -f2,3,5 ../misc/editorial/title-to-editor.unjudged.domainclicks.agree.txt | python dqt2json.py
2. cut -f1-3 ../misc/editorial/dqts.1-2001.tsv | python dqt2json.py
3. cut -f1-3 ../misc/editorial/dqts.2002-4000.tsv | python dqt2json.py
4. tail -n+2 ../outlinktitles/matchedtitles.0.1.100.200.algo.outlink | cut -f1,2,6 | python dqt2json.py qltitle_edit.onejson algo.outlink
    a. hcat QuickLinkGeneration.abf/outlinktitles/joined/par* | python CompareTitle.py 6 11,3 0,1,4,5 > matchedtitles.0.1.100.200.algo.outlink
