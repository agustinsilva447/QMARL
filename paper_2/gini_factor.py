import numpy as np

def gini_coefficient(list1):
    tot_rewards = [np.sum(i) for i in list1]
    n = len(tot_rewards)
    tot_rewards.append(0)
    sor_rewards = np.cumsum(np.sort(tot_rewards))

    are_rewards = 0
    for i in range(n):
        are_rewards += sor_rewards[i] + sor_rewards[i+1]
    are_rewards /= 2*n

    max_rewards = sor_rewards[-1] / 2
    gini_coef = (max_rewards - are_rewards) / (max_rewards)
    return gini_coef

case1 = [[50,00,00,00,00], 
         [00,50,00,00,00], 
         [00,00,50,00,00], 
         [00,00,00,50,00], 
         [00,00,00,00,50]]
gini_coef1 = gini_coefficient(case1)
print(gini_coef1)

case2 = [[50,50,50,50,50], 
         [00,00,00,00,00], 
         [00,00,00,00,00], 
         [00,00,00,00,00], 
         [00,00,00,00,00]]
gini_coef2 = gini_coefficient(case2)
print(gini_coef2)