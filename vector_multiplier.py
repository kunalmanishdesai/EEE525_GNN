ans = 0
x=0
k=1
for i in range(96):

    if (x == 32): x = 0
    if (k == 32): k = 0
    print(x,k)
    ans += x*k
    x+=1
    k+=1
    

print(ans)