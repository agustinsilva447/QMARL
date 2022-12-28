import copy
import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange

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

    state = J_dg * strategies_gate * J * init_mat
    prob = np.power(np.abs(state),2)
    outp = [int_to_binary(i,n_p) for i in range(2**n_p)]
    output = np.random.choice(outp, p=np.asarray(prob).reshape(-1))
    return output, prob, state

def minority_matrix(prob): # estimated value
  n = int(np.log2(len(prob)))
  mm = np.zeros([2**n,n])
  for i in range(n):
    mm[2**i][n-i-1] = 10 * n
  payoff = prob.transpose() * mm
  return payoff.tolist()[0]       

def matrix_reward(rotat, a_type):  
  output, prob, state = Numpy_QGT_Nplayers(rotat, a_type[1], a_type[2])
  reward_g = minority_matrix(prob)
  return reward_g        

def gradient_rotat(r,j,k,e,a,l):
  r1 = copy.deepcopy(r)
  r1[j][k] -= e
  rew1 = matrix_reward(r1,a)
  r2 = copy.deepcopy(r)
  r2[j][k] += e  
  rew2 = matrix_reward(r2,a)
  r_new = (r[j][k] + l * (rew2[j]-rew1[j])/(2*epsilon))
  while (r_new < 0) or (2*np.pi <= r_new):
    if (r_new>=2*np.pi):
      r_new -= 2*np.pi
    if (r_new<0):
      r_new += 2*np.pi
  return r_new  

n = 2
max_it = 10000
a_type = ['q', 8 *np.pi/16, 0]
epsilon = 1e-4
l_rate  = 1e-3
rotat = [[np.pi * np.random.rand(), np.pi * np.random.rand(), np.pi * np.random.rand()] for i in range(n)]
strategies = [[] for i in range(3*n)]
feedback   = [[] for i in range(n)]

for i in trange(max_it):
  reward = matrix_reward(rotat, a_type)
  for h in range(n):
    for g in range(3):
      strategies[3*h+g].append(rotat[h][g])
    feedback[h].append(reward[h])

  aux = copy.deepcopy(rotat)
  for j in range(n):
    for k in range(3):
      rotat[j][k] = gradient_rotat(aux,j,k,epsilon,a_type,l_rate)  

  diff = 0
  for i in range(n):
    for j in range(3):
      diff += np.abs(rotat[i][j] - aux[i][j])
  if diff<1e-4:
    break

print("Learning rate = {}. Epsilon = {}. Diff = {}".format(l_rate, epsilon, diff))
for i in range(n):
  print("Player {} => Strategy = {} and Reward = {}".format(i,rotat[i],reward[i]))

fig0, axs = plt.subplots(1,2,figsize=(15,5))
for i in range(n):
  axs[0].plot(feedback[i], label="Player {}".format(i))
for i in range(n):
  for j in range(3):
    axs[1].plot(strategies[3*i+j], label="Player {}. Strategy {}.".format(i,j))
#axs[0].legend()
#axs[1].legend()
plt.show()      