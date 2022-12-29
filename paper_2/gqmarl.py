import copy
import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange
from math import sqrt

def int_to_binary(n,m):
    if n == 0:
        return "0" * m
    binary1 = ""
    while n > 0:
        binary1 = str(n % 2) + binary1
        n = n // 2
    binary2 = "0" * (m - len(binary1)) + binary1
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

def final_strategy(rx_1, ry_2, rx_3, depo):
  return depo * rx_3 * ry_2 * rx_1

def minority_matrix(prob):
  n = int(np.log2(len(prob)))
  mm = np.zeros([2**n,n])
  for i in range(n):
    mm[2**i][n-i-1] = 10 * n
  payoff = prob.transpose() * mm
  return payoff.tolist()[0]

def Numpy_QGT_Nplayers(tipo, gamma = 8 *np.pi/16, lamda = 0):
    n_p = len(tipo)
    init_mat = np.matrix([[1] if i==0 else [0] for i in range(2**n_p)])
    I_f = np.array(np.eye(2**n_p))
    X_f = np.array(np.flip(np.eye(2**n_p),0))
    J = np.matrix(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
    J_dg = J.H

    for i in range(n_p):
      players_gate = final_strategy(rX_numpy(tipo[i][0]), rY_numpy(tipo[i][1]), rX_numpy(tipo[i][2]), depolarization(lamda))
      if i==0:
        strategies_gate = players_gate
      else:
        strategies_gate = np.kron(strategies_gate, players_gate)

    outputstate = J_dg * strategies_gate * J * init_mat
    prob = np.power(np.abs(outputstate),2)
    outp = [int_to_binary(i,n_p) for i in range(2**n_p)]
    output = np.random.choice(outp, p=np.asarray(prob).reshape(-1))
    return output, prob, outputstate

def matrix_reward(rotat, a_type):  
  output, prob, state = Numpy_QGT_Nplayers(rotat, a_type[1], a_type[2])
  reward_g = minority_matrix(prob)
  return reward_g

def gradient_rotat(r,j,k,e,a):
  r1 = copy.deepcopy(r)
  r1[j][k] -= e
  rew1 = matrix_reward(r1,a)
  r2 = copy.deepcopy(r)
  r2[j][k] += e  
  rew2 = matrix_reward(r2,a)
  g_new = (rew2[j]-rew1[j])/(2*epsilon)
  return g_new

n = 3
max_it = 100000
epsilon = 1e-5
alpha1 = 0.01
alpha2 = 1e-9
beta1  = 0.9
beta2  = 0.99
rotat = [[np.pi * np.random.rand(), np.pi * np.random.rand(), np.pi * np.random.rand()] for i in range(n)]
total_fair = []
q_noise = [0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.125, 0.15, 0.175, 0.2, 0.3, 0.4, 0.5, 0.75, 1]

for q in q_noise:
  a_type = ['q', 8 *np.pi/16, q]
  m = [[0.0,0.0,0.0] for i in range(n)]
  v = [[0.0,0.0,0.0] for i in range(n)]
  strategies = [[] for i in range(3*n)]
  feedback   = [[] for i in range(n)]
  rewards    = [[] for i in range(n)]
  fairness = []
  avg_fair = []

  for t in trange(max_it):
    reward = matrix_reward(rotat, a_type)
    aux = copy.deepcopy(rotat)
    f0 = 1
    for i in range(n):
      feedback[i].append(reward[i])
      if t<1000:
        rewards[i].append(np.mean(feedback[i][0:t+1]))
      else:
        rewards[i].append(np.mean(feedback[i][t-1000:t+1]))
      f0 *= rewards[i][-1]
      for j in range(3):
        strategies[3*i+j].append(rotat[i][j])
        grad = gradient_rotat(aux,i,j,epsilon,a_type)
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
    fairness.append(f0)
    avg_fair.append(np.mean(fairness))

  print("A1 = {}. A2 = {}. B1 = {}. B2 = {}.".format(alpha1, alpha2, beta1, beta2))
  for i in range(n):
    print("Player {} => Strategy = {} and Reward = {}".format(i,rotat[i],reward[i]))
  print("Quantum Noise = {}. Final Average Fairness Factor = {}.".format(q, avg_fair[-1]))
  total_fair.append(avg_fair[-1])

plt.title("Fairness/Performance vs Quantum Noise")
plt.plot(q_noise, total_fair)
plt.xlabel("Quantum Noise")
plt.ylabel("Fairness/Performance")
plt.show()
"""
fig0, axs = plt.subplots(2,2,figsize=(20,15))
for i in range(n):
  axs[0,0].plot(feedback[i], label="Player {}".format(i))
  axs[0,1].plot(rewards[i],  label="Player {}".format(i))
  for j in range(3):
    axs[1,0].plot(strategies[3*i+j], label="Player {}. Strategy {}.".format(i,j))
axs[1,1].plot(fairness)
axs[1,1].plot(avg_fair)
axs[1,1].set_ylim(0, 100)
#axs[0,0].legend()
#axs[0,1].legend()
#axs[1,0].legend()
#axs[1,1].legend()
plt.show()
"""