import copy
import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange
from math import sqrt

def int_to_binary_1(s,m):
    if s == 0:
        return "0" * m
    binary1 = ""
    while s > 0:
        binary1 = str(s % 2) + binary1
        s = s // 2
    binary2 = "0" * (m - len(binary1)) + binary1
    return binary2

def int_to_binary_2(s,m):
    if s == 0:
        return "0 " * m
    binary1 = ""
    while s > 0:
        binary1 = str(s % 2) + " " + binary1
        s = s // 2
    binary2 = "0 " * (m - len(binary1)//2) + binary1
    return binary2
    
def rX_numpy(phi):
  rx = np.matrix([[    np.cos(phi/2), -1j*np.sin(phi/2)],
                  [-1j*np.sin(phi/2),     np.cos(phi/2)]])
  return rx

def rY_numpy(phi):
  ry = np.matrix([[np.cos(phi/2), -1*np.sin(phi/2)],
                  [np.sin(phi/2),    np.cos(phi/2)]])
  return ry

def depolarization(lamda):
  I = np.matrix([[1,  0],
                 [0,  1]])
  X = np.matrix([[0,  1],
                 [1,  0]])
  Y = np.matrix([[0, -1j],
                 [1j, 0]])
  Z = np.matrix([[1,  0],
                 [0, -1]])
  pauli_gates = [I, X, Y, Z]
  index = np.random.choice([0, 1, 2, 3], p = [1-lamda, lamda/3, lamda/3, lamda/3])
  return pauli_gates[index]

def final_strategy(rx_1, ry_2, rx_3, depo = 1):
  return depo * rx_3 * ry_2 * rx_1

def Numpy_QGT_Nplayers(tipo, J_init, J_dg, lamda = 0):
    n_p = len(tipo)
    for i in range(n_p):
      
      if lamda == 0:
        players_gate = final_strategy(rX_numpy(tipo[i][0]), rY_numpy(tipo[i][1]), rX_numpy(tipo[i][2]))
      else:
        players_gate = final_strategy(rX_numpy(tipo[i][0]), rY_numpy(tipo[i][1]), rX_numpy(tipo[i][2]), depolarization(lamda))
      
      if i==0:
        strategies_gate = players_gate
      else:
        strategies_gate = np.kron(strategies_gate, players_gate)

    outputstate = J_dg * strategies_gate * J_init
    prob = np.power(np.abs(outputstate),2)
    #outp = [int_to_binary(i,n_p) for i in range(2**n_p)]
    #output = np.random.choice(outp, p=np.asarray(prob).reshape(-1))
    return prob

def matrix_reward(rotat, J_init, J_dg, a_type):  
  prob = Numpy_QGT_Nplayers(rotat, J_init, J_dg, a_type[1])
  reward_g = prob.transpose() * mm
  reward_h = reward_g.tolist()[0]
  return reward_h

def gradient_rotat(rew,r,j,k,e,a,J_init,J_dg):
  """r1 = copy.deepcopy(r)
  r1[j][k] -= e
  rew1 = matrix_reward(r1,J_init,J_dg,a)"""
  r2 = copy.deepcopy(r)
  r2[j][k] += e  
  rew2 = matrix_reward(r2,J_init,J_dg,a)
  g_new = (rew2[j]-rew[j])/e
  return g_new

def gini_coefficient(list1):
    tot_rewards = [np.sum(i) for i in list1]
    tot_rewards.append(0)
    sor_rewards = np.cumsum(np.sort(tot_rewards))
    max_rewards = sor_rewards[-1]
    are_rewards = 2*np.sum(sor_rewards) - max_rewards
    gini_coef = (are_rewards) / (max_rewards)
    return (gini_coef - 1)/(n - 1)

def minority_matrix(n): # https://en.wikipedia.org/wiki/El_Farol_Bar_problem
  mm = np.zeros([2**n,n])
  for i in range(2**n):
    numpy_data = np.fromstring(int_to_binary_2(i,n), dtype=int, sep=' ')
    if (np.count_nonzero(numpy_data == 0) > np.count_nonzero(numpy_data == 1)):
      mm[i] = np.where(numpy_data == 1, 10, 0)
    elif (np.count_nonzero(numpy_data == 0) < np.count_nonzero(numpy_data == 1)):
      mm[i] = np.where(numpy_data == 0, 10, 0)
  return  mm

def platonia_matrix(n): # https://en.wikipedia.org/wiki/Platonia_dilemma
  mm = np.zeros([2**n,n])
  for i in range(n):
    mm[2**i][n-i-1] = 10
  return  mm

def unscrupulous_matrix(n): # https://en.wikipedia.org/wiki/Unscrupulous_diner%27s_dilemma
  a = 100
  b = 50 * (n-1)/(n) # 25
  k = 110
  l = 10
  mm = np.zeros([2**n,n])
  for i in range(2**n):
    numpy_data = np.fromstring(int_to_binary_2(i,n), dtype=int, sep=' ')
    for j in range(len(mm[i])):
      x = np.where(numpy_data == 0, l, k)
      if numpy_data[j] == 0:
        mm[i][j] = b - np.sum(x) / n
      else:
        mm[i][j] = a - np.sum(x) / n
  mmin = np.min(mm)
  mmax = np.max(mm)
  mm = -10 * (mm - mmin)/(mmin - mmax)
  return mm

def volunteer_matrix(n): # https://en.wikipedia.org/wiki/Volunteer%27s_dilemma
  mm = np.zeros([2**n,n])
  for i in range(2**n):
    numpy_data = np.fromstring(int_to_binary_2(i,n), dtype=int, sep=' ')
    if (np.count_nonzero(numpy_data == 1) != n):
      mm[i] = numpy_data
    else:
      mm[i] -= 10 
  return mm

def euclidian_distance(r0,r1):
  return np.sqrt(np.sum((r0 - r1)**2))

def lyapunov_adjust(xa,xb,d0,d1):
  return xa + d0 * (xb - xa) / d1

n       = 4
q       = 0
max_it  = 1000000
alpha1  = 0.0001
alpha2  = 1e-8
beta1   = 0.9
beta2   = 0.999
epsilon = 1e-8
gamma   = np.pi/2
d0      = 1e-8
mm      = volunteer_matrix(n)
print(mm)

init_mat = np.matrix([[1] if i==0 else [0] for i in range(2**n)])
I_f = np.array(np.eye(2**n))
X_f = np.array(np.flip(np.eye(2**n),0))
J = np.matrix(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
J_dg = J.H
J_init = J * init_mat

print("N = {}. Quantum Noise = {}. A1 = {}.".format(n, q, alpha1))
total_rewr0 = []
total_rewr1 = []
rotat = [[np.pi * np.random.rand(), np.pi * np.random.rand(), np.pi * np.random.rand()] for i in range(n)]
rotat0 = copy.deepcopy(rotat)
rotat1 = copy.deepcopy(rotat)
m0 = [[0.0,0.0,0.0] for i in range(n)]
v0 = [[0.0,0.0,0.0] for i in range(n)]
m1 = [[0.0,0.0,0.0] for i in range(n)]
v1 = [[0.0,0.0,0.0] for i in range(n)]
a_type = ['q', 0]
b_type = ['q', q]
feedback0   = [[] for i in range(n)]
feedback1   = [[] for i in range(n)]
d = []
l = []

for t in trange(max_it):
  reward0 = matrix_reward(rotat0, J_init, J_dg, a_type)
  aux0 = copy.deepcopy(rotat0)
  reward1 = matrix_reward(rotat1, J_init, J_dg, a_type)
  aux1 = copy.deepcopy(rotat1)
  for i in range(n):
    feedback0[i].append(reward0[i])   
    feedback1[i].append(reward1[i])      
    for j in range(3):
      # original version
      grad0 = gradient_rotat(reward0,aux0,i,j,epsilon,b_type,J_init,J_dg)
      m0[i][j] = beta1 * m0[i][j] + (1.0 - beta1) * grad0
      v0[i][j] = beta2 * v0[i][j] + (1.0 - beta2) * grad0**2
      mhat0 = m0[i][j] / (1.0 - beta1**(t+1))
      vhat0 = v0[i][j] / (1.0 - beta2**(t+1))   
      rotat0[i][j] = rotat0[i][j] + alpha1 * mhat0 / (sqrt(vhat0) + alpha2)
      while (rotat0[i][j]<0) or (2*np.pi<=rotat0[i][j]):
        if (rotat0[i][j]<0):
          rotat0[i][j] += 2*np.pi
        if (2*np.pi<=rotat0[i][j]):
          rotat0[i][j] -= 2*np.pi
      # displaced version
      grad1 = gradient_rotat(reward1,aux1,i,j,epsilon,b_type,J_init,J_dg)
      m1[i][j] = beta1 * m1[i][j] + (1.0 - beta1) * grad1
      v1[i][j] = beta2 * v1[i][j] + (1.0 - beta2) * grad1**2   
      mhat1 = m1[i][j] / (1.0 - beta1**(t+1))
      vhat1 = v1[i][j] / (1.0 - beta2**(t+1))      
      rotat1[i][j] = rotat1[i][j] + alpha1 * mhat1 / (sqrt(vhat1) + alpha2)      
      while (rotat1[i][j]<0) or (2*np.pi<=rotat1[i][j]):
        if (rotat1[i][j]<0):
          rotat1[i][j] += 2*np.pi
        if (2*np.pi<=rotat1[i][j]):
          rotat1[i][j] -= 2*np.pi

  if t<1000:
    d.append(0)
    l.append(0)
  elif t==1000:
    rotat1 += d0 / (np.sqrt(3*n))
    d1 = euclidian_distance(rotat0,rotat1)
    d.append(np.log(d1/d0))
    l.append(np.log(d1/d0))
  else:
    d1 = euclidian_distance(rotat0,rotat1)
    d.append(np.log(d1/d0))
    if t<2000:
      l.append(np.mean(d[1000:t]))
    else:
      l.append(np.mean(d[t-1000:t]))
    rotat1 = lyapunov_adjust(rotat0, rotat1, d0, d1)

total_rewr0.append(feedback0)
total_rewr1.append(feedback1)
print("Average reward = {}. Fairness factor = {}".format(np.mean(feedback0), gini_coefficient(feedback0)))
print("Average reward = {}. Fairness factor = {}".format(np.mean(feedback1), gini_coefficient(feedback1)))

for i in range(n):
  plt.plot(feedback0[i], label="Player {}".format(i))
#plt.ylim(0, 10)
plt.ylim(-11, 2)
plt.xlabel("Iterations")
plt.ylabel("Rewards")
plt.legend()
plt.show()

fig0, axs = plt.subplots(figsize=(10,5))
print(np.mean(d[1000::]))
plt.plot(d)
plt.plot(l)
plt.show()