import copy
import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange
from math import sqrt

###################################################### 
# Utils functions
###################################################### 

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

######################################################
# Quantum Circuit
###################################################### 
    
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
    #outp = [int_to_binary_1(i,n_p) for i in range(2**n_p)]
    #output = np.random.choice(outp, p=np.asarray(prob).reshape(-1))
    return prob

######################################################
# Multi-agent System
###################################################### 

def matrix_reward(rotat, J_init, J_dg, a_type):  
  prob = Numpy_QGT_Nplayers(rotat, J_init, J_dg, a_type[1])
  reward_g = prob.transpose() * mm
  reward_h = reward_g.tolist()[0]
  return reward_h

def gradient_rotat(rew,r,j,k,e,a,J_init,J_dg,pot=0):
  r2 = copy.deepcopy(r)
  r2[j][k] += e  
  rew2 = matrix_reward(r2,J_init,J_dg,a)
  if pot==0:
    g_new = (rew2[j]-rew[j])/e
  else:
    g_new = (rew2[j]*gini_coefficient(rew2)**pot-rew[j]*gini_coefficient(rew)**pot)/e
  return g_new

def gini_coefficient(list1):
    tot_rewards = [np.sum(i) for i in list1]
    tot_rewards.append(0)
    sor_rewards = np.cumsum(np.sort(tot_rewards))
    max_rewards = sor_rewards[-1]
    are_rewards = 2*np.sum(sor_rewards) - max_rewards
    gini_coef = (are_rewards) / (max_rewards)
    return (gini_coef - 1)/(n - 1)

######################################################
# N-player Games
###################################################### 

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

######################################################
# Main program
######################################################

n       = 4
t1      = 1000000
t2      = t1
q_noise = [0]
gamman  = [np.pi/2]
alpha1n = [0.0001]
alpha2n = [1e-8]
beta1n  = [0.9]
beta2n  = [0.999]
epsilnn = [1e-8]
mm      = unscrupulous_matrix(n)
print(mm)

t_fair = []
t_rewr = []
for ii,q in enumerate(q_noise):
  total_fair = []
  total_rewr = []
  for gamma in gamman:
    init_mat = np.matrix([[1] if i==0 else [0] for i in range(2**n)])
    I_f = np.array(np.eye(2**n))
    X_f = np.array(np.flip(np.eye(2**n),0))
    J = np.matrix(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
    J_dg = J.H
    J_init = J * init_mat
    for alpha1 in alpha1n:
      for alpha2 in alpha2n:
        for beta1 in beta1n:
          for beta2 in beta2n:
            for epsilon in epsilnn:
              print("N = {}. Quantum Noise = {}. Gamma = {:.6f}. A1 = {}. A2 = {}. B1 = {}. B2 = {}.".format(n, q, gamma, alpha1, alpha2, beta1, beta2))
              a_type = ['q', 0]
              b_type = ['q', q]
              rotat = [[np.pi * np.random.rand(), np.pi * np.random.rand(), np.pi * np.random.rand()] for i in range(n)]
              m = [[0.0,0.0,0.0] for i in range(n)]
              v = [[0.0,0.0,0.0] for i in range(n)]
              feedback   = [[] for i in range(n)]
              fairness   = []
              #rotacion0  = []
              #rotacion1  = []

              for t in trange(t1):
                reward = matrix_reward(rotat, J_init, J_dg, a_type)
                aux = copy.deepcopy(rotat)
                #rotacion0.append(aux[0])
                #rotacion1.append(aux[1])
                for i in range(n):  
                  for j in range(3):
                    grad = gradient_rotat(reward,aux,i,j,epsilon,b_type,J_init,J_dg)
                    m[i][j] = beta1 * m[i][j] + (1.0 - beta1) * grad
                    v[i][j] = beta2 * v[i][j] + (1.0 - beta2) * grad**2
                    mhat = m[i][j] / (1.0 - beta1**(t+1))
                    vhat = v[i][j] / (1.0 - beta2**(t+1))      
                    rotat[i][j] = rotat[i][j] + alpha1 * mhat / (sqrt(vhat) + alpha2)
                    while (rotat[i][j]<0) or (2*np.pi<=rotat[i][j]):
                      if (rotat[i][j]<0):
                        rotat[i][j] += 2*np.pi
                      if (2*np.pi<=rotat[i][j]):
                        rotat[i][j] -= 2*np.pi
                  #if (t%10==0):
                  feedback[i].append(reward[i])   
                if (t%t2 == 0):
                  rotat = [[np.pi * np.random.rand(), np.pi * np.random.rand(), np.pi * np.random.rand()] for i in range(n)]
                  m = [[0.0,0.0,0.0] for i in range(n)]
                  v = [[0.0,0.0,0.0] for i in range(n)]
                #gini = gini_coefficient(feedback)
                #fairness.append(gini)  
              avgr = np.mean(feedback)
              gini = gini_coefficient(feedback)
              #total_rewr.append(avgr)
              #total_fair.append(gini)
              t_rewr.append(avgr)
              t_fair.append(gini)
              print("AVGR = {:.6f}. GINI = {:.6f}.".format(avgr, gini))

  """
  print("N = {}. Quantum Noise = {}.".format(n, q))
  p_total_rewr = [ "{:.6f}".format(elem) for elem in total_rewr ]
  p_total_fair = [ "{:.6f}".format(elem) for elem in total_fair ]
  print("avg_rew_n{}_{} = {}".format(q_text[ii],n,p_total_rewr))
  print("far_fac_n{}_{} = {}".format(q_text[ii],n,p_total_fair))  
  """
print("Rewards  = ", t_rewr)
print("Fairness = ", t_fair)
######################################################
# Plots
###################################################### 

"""
plt.plot(q_noise, t_rewr, ".-")
plt.title("Average Reward vs Quantum Noise (N = {})".format(n))
plt.xlabel("Quantum Noise")
plt.ylabel("Average Reward")
plt.show()
"""

"""
freq = np.fft.fftfreq(np.arange(t1).shape[-1])[1:t1//2]
fig0, axs = plt.subplots(1,2,figsize=(20,8))
for i in range(n):
  axs[0].plot(feedback[i], label="Player {}".format(i))
  sp = np.fft.fft(feedback[i])
  spp = (sp * sp.conj()).real
  axs[1].plot(freq, spp[1:t1//2])
plt.show()
"""

"""
fig0, axs = plt.subplots(1,2,figsize=(20,8))
fig0.suptitle("Rewards and Fairness for epsilon = {}.".format(epsilon), fontsize=16)
axs[0].set_title("Total average rewards versus learning rate")
axs[0].plot(alphan, total_rewr)
axs[0].set_xlabel("Learning rate")
axs[0].set_ylabel("Average reward")
axs[0].set_ylim(0, 10)
axs[1].set_title("Total fairness factor versus learning rate")
axs[1].plot(alphan, total_fair)
axs[1].set_xlabel("Learning rate")
axs[1].set_ylabel("Average reward")
axs[1].set_ylim(0, 1)
plt.show()
"""

"""
fig0, axs = plt.subplots(1,2,figsize=(20,8))
fig0, axs = plt.subplots(1,2,figsize=(20,8))
axs[0].set_title("Avg Reward vs Quantum Noise")
axs[0].plot(q_noise, total_rewr)
axs[0].set_xlabel("Quantum Noise")
axs[0].set_ylabel("Avg Reward")
#axs[0].set_ylim(0, 10)
axs[1].set_title("Avg Fairness vs Quantum Noise")
axs[1].plot(q_noise, total_fair)
axs[1].set_xlabel("Quantum Noise")
axs[1].set_ylabel("Avg Fairness")
axs[1].set_ylim(0, 1)
plt.show()
"""

"""
fig0, axs = plt.subplots(1,2,figsize=(20,8))
fig0.suptitle("Q = {}. A1 = {}".format(q, alpha1), fontsize=16)
for i in range(n):
  axs[0].plot(feedback[i], label="Player {}".format(i))
axs[1].plot(fairness)
axs[0].set_ylim(0, 10 * n)
axs[1].set_ylim(0, 1)
axs[0].legend()
plt.show()
"""

for i in range(n):
  plt.plot(feedback[i], label="Player {}".format(i))
plt.ylim(0, 10)
plt.xlabel("Iterations")
plt.ylabel("Rewards")
plt.legend()
plt.show()

"""
rot0 = np.array(rotacion0)
rot1 = np.array(rotacion1)
fig = plt.figure(figsize=(20,10))
ax = fig.add_subplot(1, 2, 1, projection='3d')
ax.plot(*rot0.T, lw=0.5)
ax = fig.add_subplot(1, 2, 2, projection='3d')
ax.plot(*rot1.T, lw=0.5)
plt.show()
"""