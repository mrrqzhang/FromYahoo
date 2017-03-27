# format: score\tdecision(1/0)
# two files: file1 file2
import sys,math

RANGE_MIN=0        # thres min sample
RANGE_MAX=50     # max sample point
STEP=1
sigmoid=0

score1 = []
score_max1=0
with open(sys.argv[1],'r') as FILE1:
    for line in FILE1:
    	val,judge = line.strip('\r\t\n').split('\t')
    	score1.append([val,judge])
    	if float(val)>score_max1: score_max1=float(val)


score2 = []
score_max2=0
with open(sys.argv[2],'r') as FILE2:
    for line in FILE2:
    	val,judge = line.strip('\r\t\n').split('\t')
    	score2.append([val,judge])
    	if float(val)>score_max2: score_max2=float(val)

if len(score1)!=len(score2): 
    print ("The two input does not match: different length")
    exit()

correct=0
recognized=0
all=0
#for thres in [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]:
sys.stdout.write('thres1\tthres2\trecall\tprecision\tcorrect\trecognized\tall\n')
for thx in range(RANGE_MIN,RANGE_MAX,STEP):
  for thy in range(RANGE_MIN,RANGE_MAX,STEP):
    thres1=float(thx)*score_max1/RANGE_MAX
    thres2=float(thy)*score_max2/RANGE_MAX
    correct=0
    recognized=0
    all=0
    for ci in range(len(score1)):
        item1,item2 = score1[ci],score2[ci]
        if item1[1]!=item2[1]:
            print ("The two input does not match: judgement inconsistent")
            exit()

        if sigmoid: item[0]=1.0/(1.0+math.exp((-1)*float(item[0])));

        if int(item1[1])==int(1): all+=1
        if float(item1[0])>=float(thres1) and float(item2[0])>=float(thres2): 
            recognized+=1
            if int(item1[1])==int(1): correct+=1
    if recognized!=0 :
       precision=float(correct)/recognized
       recall = float(correct)/all
       sys.stdout.write('thres1:%f\tthres2:%f\t%f\t%f\tcorrect:%f\trecognized:%f\tall:%f\n' %(thres1,thres2,recall,precision,correct, recognized, all))


