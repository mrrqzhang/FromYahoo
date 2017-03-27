#! /usr/bin/env python

from TNSR_Util import *

def main():
    if len(sys.argv) != 11:
        print '''Usage: atvt.py <rawcsv> <query_url.txt> <TreeNum> <NodeNum> <LearnRate> <newcsv> <lambda_alpha> <lambda_beta> <iterations> <junk dir>
	...... This is for adaptive Target Value Transformation ......
	Note: This program must be run on the machine where Treenet has been installed!

        inputs: <rawcsv>, <query_url.txt>, <TreeNum>, <NodeNum>, <LearnRate>, <lambda_alpha>, <lambda_beta>, <iterations> <junk dir>
            where <lambda_alpha> and <lambda_beta> are regularization parameters for alpha:slope and beta:intercept respectively. Both usually range from 0.01 to 100. You could try 0.01, 0.1, 1, 10, 100 first and conduct fine-tuning further. 
        outputs: <newcsv>

'''
        sys.exit()
        
    lambda_alpha = atof(sys.argv[7]); lambda_beta = atof(sys.argv[8]); iterations = atoi(sys.argv[9])
    idxes,qries = getQryIdx(sys.argv[2])
    grades = []
    csvfile = ""

    tmp_predict_csv = os.path.join(sys.argv[10], 'predict.atvttmp.csv')
    tmp_raw_csv = os.path.join(sys.argv[10], 'raw.atvttmp.csv')
    tmp_c = os.path.join(sys.argv[10], 'atvttmp.c')
    tmp_grv = os.path.join(sys.argv[10], 'atvttmp.grv')
    tmp_dat = os.path.join(sys.argv[10], 'atvttmp.dat')

    os.system("rm "+tmp_predict_csv+" "+tmp_raw_csv+" "+tmp_c+" "+tmp_grv+" "+tmp_dat)
    
    for cnt in range(iterations):
	    if cnt == 0:
		    csvfile = sys.argv[1]
	    else:
		    csvfile = sys.argv[6]
            tncmd(csvfile, sys.argv[3], sys.argv[4], sys.argv[5], tmp_c, tmp_grv, tmp_dat, sys.argv[10])
            tstcmd(csvfile, tmp_grv, tmp_predict_csv, sys.argv[10])
	    newgrades=getnormalgrades(tmp_predict_csv, qries, idxes, lambda_alpha, lambda_beta)[-1]
	    if grades == newgrades:
		    break
	    grades = newgrades
	    changegrades(csvfile, newgrades, tmp_raw_csv)
	    os.system("mv "+tmp_raw_csv+" "+sys.argv[6])

    os.system("rm "+tmp_predict_csv+" "+tmp_raw_csv+" "+tmp_c+" "+tmp_grv+" "+tmp_dat)

if(__name__ == "__main__"):
    main()	

