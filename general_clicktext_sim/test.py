word1="facebook"
word2="faecbook"

len_1=len(word1)
len_2=len(word2)

x =[[0]*(len_2+1) for _ in range(len_1+1)]

for i in range(0,len_1+1):
    x[i][0]=i
for j in range(0,len_2+1):
    x[0][j]=j
for i in range (1,len_1+1):
    for j in range(1,len_2+1):
        if word1[i-1]==word2[j-1]:
            x[i][j] = x[i-1][j-1] 
        else :
            x[i][j]= min(x[i][j-1],x[i-1][j],x[i-1][j-1])+1
print x[i][j]
