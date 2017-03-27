# format: score\tdecision(1/0)
import sys,math

RANGE_MIN=0        # thres min sample
RANGE_MAX=500     # max sample point
STEP=1
sigmoid=0

score = []
score_max=0
for line in sys.stdin:
    val,judge = line.strip('\r\t\n').split('\t')
    score.append([val,judge])
    if float(val)>score_max: score_max=float(val)

correct=0
recognized=0
all=0
#for thres in [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]:
sys.stdout.write('thres\trecall\tprecision\tcorrect\trecognized\tall\n')
for thres2 in range(RANGE_MIN,RANGE_MAX,STEP):
    thres=float(thres2)*score_max/RANGE_MAX

    correct=0
    recognized=0
    all=0
    for item in score:
        if sigmoid: item[0]=1.0/(1.0+math.exp((-1)*float(item[0])));
#        print item, item[1]

        if int(item[1])==int(1): all+=1
        if float(item[0])>=float(thres): recognized+=1
        if float(item[0])>=float(thres) and int(item[1])==int(1): correct+=1
    if recognized!=0 :
       precision=float(correct)/recognized
       recall = float(correct)/all
       sys.stdout.write('thres:%f\t%f\t%f\tcorrect:%f\trecognized:%f\tall:%f\n' %(thres,recall,precision,correct, recognized, all))


