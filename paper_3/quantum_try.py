import copy
import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange

# UTILS
def int_to_binary(s,m):
    if s == 0:
        return "0 " * m
    binary1 = ""
    while s > 0:
        binary1 = str(s % 2) + " " + binary1
        s = s // 2
    binary2 = "0 " * (m - len(binary1)//2) + binary1
    return binary2

# AGENTS
class Agent:
    def __init__(self, n_anctions, alfa):
        self.n_anctions = n_anctions
        self.indices = np.arange(n_anctions)
        self.alfa = alfa
    def reset(self):
        self.prob = np.ones(self.n_anctions) / self.n_anctions
        return np.random.choice(self.indices, p=self.prob)
    def act(self):
        return np.random.choice(self.indices, p=self.prob)
    def step(self, action, reward):    
        self.prob = (1 - self.alfa * reward) * self.prob
        self.prob[action] += self.alfa * reward

        if np.max(self.prob)>0.999:
          return 1
        else: 
          return 0
        
    def end(self): 
        return self.prob
    
# QUANTUM
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

def matrix_reward(rotat, J_init, J_dg, a_type):  
  prob = Numpy_QGT_Nplayers(rotat, J_init, J_dg, a_type[1])
  reward_g = prob.transpose() * game
  reward_h = reward_g.tolist()[0]
  return reward_h

# GAMES (entre 0 y 10)
def battle_of_sexes(n):
    mm = np.zeros([4,2])
    mm[0] = [10,  5]
    mm[1] = [ 0 , 0]
    mm[2] = [ 2 , 2]
    mm[3] = [ 5, 10]
    return mm

def minority_matrix(n): # https://en.wikipedia.org/wiki/El_Farol_Bar_problem
  mm = np.zeros([2**n,n])
  for i in range(2**n):
    numpy_data = np.fromstring(int_to_binary(i,n), dtype=int, sep=' ')
    if (np.count_nonzero(numpy_data == 0) > np.count_nonzero(numpy_data == 1)):
      mm[i] = np.where(numpy_data == 1, 10, 0)
    elif (np.count_nonzero(numpy_data == 0) < np.count_nonzero(numpy_data == 1)):
      mm[i] = np.where(numpy_data == 0, 10, 0)
  return  mm

def unscrupulous_matrix(n): # https://en.wikipedia.org/wiki/Unscrupulous_diner%27s_dilemma
  a = 100
  b = 50 * (n-1)/(n) # 25
  k = 110
  l = 10
  mm = np.zeros([2**n,n])
  for i in range(2**n):
    numpy_data = np.fromstring(int_to_binary(i,n), dtype=int, sep=' ')
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

def platonia_matrix(n): # https://en.wikipedia.org/wiki/Platonia_dilemma
  mm = np.zeros([2**n,n])
  for i in range(n):
    mm[2**i][n-i-1] = 10
  return  mm

# MAIN
players     = 2
alfa        = 0.001
t_max       = 100000
t_exp       = 0
window1     = 1000
p           = 0.99  # probabilidad de que los N jugadores encuentren su equilibrio de Nash más conveniente, asumiendo que existen N equilibrios de Nash
iterations  = int(np.ceil(np.log(1 - p)/np.log((players - 1)/(players))))
#iterations  = 1
dones       = [0 for i in range(players)]
actions     = [0 for i in range(players)]
rotat       = np.zeros([len(actions), 3])
rewards     = np.zeros((players, t_max * (iterations + 1)))
rewards_avg = np.zeros(rewards.shape)
hist        = [[[0] * players, [0] * players] for i in range(players)]
game        = unscrupulous_matrix(players)

N_SIZE = 3
A_MAX  = 2*np.pi
angulos = np.arange(0, A_MAX, A_MAX / np.power(2, N_SIZE))
all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]
gamma = 0
#gamma = np.pi/2
a_type = ['q', 0]

print("Players = {}. Gamma = {:.6f}. Number of actions = {}. \n {}".format(players, gamma, len(all_actions), game))

init_mat = np.matrix([[1] if i==0 else [0] for i in range(2**players)])
I_f = np.array(np.eye(2**players))
X_f = np.array(np.flip(np.eye(2**players),0))
J = np.matrix(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
J_dg = J.H
J_init = J * init_mat

t1 = 0
t2 = 0
t3 = []
# Exploration
for it in range(iterations):
    # Initialization
    print("\n")
    agents = []
    for i in range(players):
        agents.append(Agent(n_anctions=len(all_actions), alfa=alfa))
        actions[i] = agents[i].reset()
    reward = matrix_reward(rotat, J_init, J_dg, a_type)

    flag = True
    porc = 100
    while flag:
        # Update
        for i in range(players):
            rewards[i,t1+t2] = reward[i]
            if t2<window1:
                rewards_avg[i,t1+t2] = np.mean(rewards[i,t1:t1+t2+1])
            else:
                rewards_avg[i,t1+t2] = np.mean(rewards[i,t1+t2-window1:t1+t2+1])
            dones[i]   = agents[i].step(actions[i], reward[i])
            actions[i] = agents[i].act()
                
        # Done checking
        t2 += 1
        eq = (dones == np.ones(players)).all()
        if eq or (t2 == t_max):
            porc *= (t2+1)/t_max
            if t2>t_exp:
               t_exp = t2
            t1 += t2
            t2 = 0
            t3.append(t1-1)
            flag = False

        # N rewards
        for idx, action_i in enumerate(actions):
            rotat[idx] =  all_actions[action_i]
        reward = matrix_reward(rotat, J_init, J_dg, a_type)

    # Synchronization
    for i in range(len(hist)):
        if reward[i]>hist[i][1][i]:
            if eq:
              hist[i][0] = [np.argmax(agents[k].end()) for k in range(len(hist))]
            else:
              hist[i][0] = actions[:]
            hist[i][1] = reward

    print("{:02d}/{:02d} ---> {}, {}".format(it+1, iterations, actions, reward))
    print(hist)
    if eq:
        print("---> Convergence achieved in {:.4f}%".format(porc))
    else:
        print("---> No convergence achieved")

# Exploitation
k = 0
print("\n{}".format(t3))
print("{}\n".format(hist))
for t in trange(t_exp):

    for idx, action_i in enumerate(hist[k][0]):
        rotat[idx] =  all_actions[action_i]
    reward = matrix_reward(rotat, J_init, J_dg, a_type)   

    if k == (players-1):
        k = 0
    else:
        k += 1

    for i in range(players):
        rewards[i,t1+t] = reward[i]
        rewards_avg[i,t1+t] = np.mean(rewards[i,t1:t1+t+1])


av_re = 0
for i in range(players):
    plt.plot(rewards_avg[i][0:t1+t2+t_exp], label="Player {}".format(i))
    print("Average Reward of Player {} = {:.6f}.".format(i, rewards_avg[i][t1+t2+t_exp-1]))
    av_re += rewards_avg[i][t1+t2+t_exp-1]
print("Performance over all players = {:.2f}%.".format(10 * av_re))
for i in t3:
    plt.axvline(x = i, color = 'black')
plt.ylim(-0.5,10.5)
plt.xlabel("Iterations")
plt.ylabel("Rewards")
plt.title("Reward vs Iterations")
plt.legend(loc="upper right")
plt.show()