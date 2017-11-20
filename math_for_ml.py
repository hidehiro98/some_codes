# https://codeiq.jp/magazine/2017/01/46932/
# coding: UTF-8

import matplotlib.pyplot as plt

# N = 4
# head_p = 0.5

# # グラフを表示する
# def bar_plot(p):
#     plt.bar(range(0, N+1), p, label="N=" + str(N))
#     plt.legend()
#     plt.title("COIN")
#     plt.xlabel("k")
#     plt.ylabel("p")
#     plt.show()

# # 組み合わせの公式
# def collaboration (N, k):
#     denom = 1
#     numer = 1
#     denom_list = list(reversed(range(1, N+1)))
#     numer_list =  list(reversed(range(1, k+1)))
#     for _N, _k in zip(denom_list, numer_list):
#         denom *= _N
#         numer *= _k
#     return denom / numer

# # 実行
# p = [0] * (N + 1)

# for k  in range(N + 1):
#     c = collaboration(N, k)
#     p[k] = c * ((head_p ** k) * ((1 - head_p) ** (N - k)))

# print p

# bar_plot(p)



# 階乗
def factorial(n):
    prod = 1
    for i  in range(1, n+1):
        prod *= i
    return prod

#目の出方を列挙する
def prod(list1,list2):
 p=[]
 for l1 in list1:
  for l2 in list2:
   p.append(l1+l2)
 return p

def selfprod(list, n):
 sp=list
 for i in xrange(n):
  sp=prod(list,sp)
 return sp

k=[]
for i in xrange(6):
 k.append([i])

print k
print prod(k, k)

pattern=selfprod(k,5)

# print pattern

for p in pattern:
 sum=0
 for i in p:
  sum=sum+i
 if sum==5:
  denom=1
  for j in xrange(6):
   denom=denom*factorial(p[j])
  print p
  print factorial(5)/denom*(1.0/6)**5
