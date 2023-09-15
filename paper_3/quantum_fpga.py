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
    
# QUANTUM
def general1qgate(a,b,c):
    u2 = np.matrix([[             np.cos(a/2), -np.exp(1j*c)    *np.sin(a/2)],
                    [np.exp(1j*b)*np.sin(a/2),  np.exp(1j*(b+c))*np.cos(a/2)]])
    return u2

def Numpy_QGT_Nplayers(tipo, J_init, J_dg):
    n_p = len(tipo)
    for i in range(n_p):      
      players_gate = general1qgate(tipo[i][0], tipo[i][1], tipo[i][2])
      if i==0:
        strategies_gate = players_gate
      else:
        strategies_gate = np.kron(strategies_gate, players_gate)
    outputstate = J_dg * strategies_gate * J_init
    prob = np.power(np.abs(outputstate),2)
    return prob

def matrix_reward(rotat, J_init, J_dg):  
  prob = Numpy_QGT_Nplayers(rotat, J_init, J_dg)
  reward_g = prob.transpose() * game
  reward_h = reward_g.tolist()[0]
  return reward_h

# GAMES
def minority_matrix(n):
  mm = np.zeros([2**n,n])
  for i in range(2**n):
    numpy_data = np.fromstring(int_to_binary(i,n), dtype=int, sep=' ')
    if (np.count_nonzero(numpy_data == 0) > np.count_nonzero(numpy_data == 1)):
      mm[i] = np.where(numpy_data == 1, 10, 0)
    elif (np.count_nonzero(numpy_data == 0) < np.count_nonzero(numpy_data == 1)):
      mm[i] = np.where(numpy_data == 0, 10, 0)
  return  mm

def platonia_matrix(n): 
  mm = np.zeros([2**n,n])
  for i in range(n):
    mm[2**i][n-i-1] = 10
  return  mm

# MAIN
players     = 11
alfa        =  0.0001
t_max       = 1000000
window1     = 1000
actions     = [0 for i in range(players)]
rotat       = np.zeros([len(actions), 3])
rewards     = np.zeros((players, t_max))
rewards_avg = np.zeros(rewards.shape)
game        = minority_matrix(players)

N_SIZE = 3
A_MAX  = 2*np.pi
angulos = np.arange(0, A_MAX, A_MAX / np.power(2, N_SIZE))
all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]
#gamma = 0
gamma = np.pi/2
print("Players = {}. Learning Rate = {}. Gamma = {:.6f}. Number of actions = {}. \n {}".format(players, alfa, gamma, len(all_actions), game))

init_mat = np.matrix([[1] if i==0 else [0] for i in range(2**players)])
I_f = np.array(np.eye(2**players))
X_f = np.array(np.flip(np.eye(2**players),0))
J = np.matrix(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
J_dg = J.H
J_init = J * init_mat

# Initialization
agents = []
for i in range(players):
    agents.append(Agent(n_anctions=len(all_actions), alfa=alfa))
    actions[i] = agents[i].reset()
    rotat[i] = all_actions[actions[i]]
reward = matrix_reward(rotat, J_init, J_dg)

# Iterations
for t in trange(t_max):
    # Update
    for i in range(players):
        rewards[i,t] = reward[i]
        if t<window1:
            rewards_avg[i,t] = np.mean(rewards[i,0:t+1])
        else:
            rewards_avg[i,t] = np.mean(rewards[i,t-window1:t+1])
        agents[i].step(actions[i], reward[i])
        actions[i] = agents[i].act()
        rotat[i] = all_actions[actions[i]]
    reward = matrix_reward(rotat, J_init, J_dg)

# Plotting
cumsum = 0
for i in range(players):
    plt.plot(rewards_avg[i], label="Player {}".format(i))
    print("Average Reward of Player {} = {:.6f}.".format(i, rewards_avg[i][-1]))
    cumsum += rewards_avg[i][-1]
if (game == minority_matrix(players)).all():
   print("Performance over all players = {:.2f}%.".format(10 * cumsum / (players // 2)))
elif (game == platonia_matrix(players)).all():
   print("Performance over all players = {:.2f}%.".format(10 * cumsum))
plt.ylim(-0.5,10.5)
plt.xlabel("Iterations")
plt.ylabel("Rewards")
plt.title("Reward vs Iterations")
plt.legend(loc="upper right")
plt.show()