import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange
#from qiskit.quantum_info import entropy

np.seterr(all='raise')

def eq_vector(q):
    aux = q + 2 * np.abs(np.min(q)) + 0.01
    z = aux / np.sum(aux)
    return z

def info_measure(z):
    h = - np.sum(z*np.log(z))
    return h

def opti_temperature(q_values, to, lamda = 0.5, threshold = 0.0001, max_it = 100):
    z_values = eq_vector(q_values)
    i_amount = info_measure(z_values)
    for i in range(max_it):
      if to>0.0015:
        t_opt = to
      else:
        t_opt = 0.0015
      aux1 = np.exp(z_values/t_opt)
      aux2 = np.sum(aux1)
      to_num = np.sum(z_values * aux1)
      to_den = aux2 * (np.log(aux2) - (i_amount)/(1 + lamda))
      to = (to_num)/(to_den)
      if np.abs(t_opt - to) < threshold:
        break
    return t_opt

class Agent:
    def __init__(self, n_anctions, epsilon_0=0, Tf=0.125, To=5, tau = 10000):
        self.Tf = Tf
        self.To = To
        self.Tb = To
        self.tau = tau
        self.epsilon_0 = epsilon_0
        self.indices = np.arange(n_anctions)

    def reset(self, q_initial = None):
        if q_initial:
          self.q_estimation = q_initial
        self.q_estimation = np.zeros(len(self.indices)) + 10
        self.action_count = np.zeros(len(self.indices))
        return np.random.choice(self.indices), self.To

    def act(self, t, l):
        #self.Tb = self.Tf + (self.To - self.Tf) * np.power(np.e, -t/self.tau)
        self.Tb = opti_temperature(self.q_estimation, self.Tb, l)
        if np.random.rand() < self.epsilon_0:
            return np.random.choice(self.indices), self.Tb
        try:
            exp_est = np.exp(self.q_estimation / self.Tb)
            act_pro = exp_est / np.sum(exp_est)
        except:
            q_best = np.max(self.q_estimation)
            return np.random.choice(np.where(self.q_estimation == q_best)[0]), self.Tb
        return np.random.choice(self.indices, p=act_pro), self.Tb

    def step(self, action, reward):
        self.action_count[action] += 1
        self.q_estimation[action] += (reward - self.q_estimation[action]) / self.action_count[action]
    
    def end(self): 
        try:
            exp_est = np.exp(self.q_estimation / self.Tb)
            act_pro = exp_est / np.sum(exp_est)
        except:
            act_pro = self.q_estimation/np.sum(self.q_estimation)
            return self.q_estimation, act_pro
        return self.q_estimation, act_pro

def int_to_binary(n,m):
    if n == 0:
        return "0" * m
    binary1 = ""
    while n > 0:
        binary1 = str(n % 2) + binary1
        n = n // 2
    binary2 = "0" * (m - len(binary1)) + binary1
    return binary2

def classical_game_Nplayers(rotat):
  output = ""
  for i in rotat:
    output += str(int(i))
  return output

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

    outputstate = J_dg * strategies_gate * J * init_mat
    #ent_of_formation = entropy(outputstate)
    prob = np.power(np.abs(outputstate),2)
    outp = [int_to_binary(i,n_p) for i in range(2**n_p)]
    output = np.random.choice(outp, p=np.asarray(prob).reshape(-1))
    return output, outputstate, prob #, ent_of_formation

def minority_variant(output):
    l =  len(output)
    reward = [0 for i in range(l)]
    if (output.count('1') == 1):
        reward[output.find('1')] = 10 * l
    return reward

def reward_game(rotat, a_type):
    if a_type[0] == 'q':
      output, _s, _p = Numpy_QGT_Nplayers(rotat, a_type[1], a_type[2])
    elif a_type[0] == 'c':
      output = classical_game_Nplayers(rotat)
    return minority_variant(output) #, ent

def game(all_actions, actions, a_type):
    if a_type[0] == 'q':
      rotat = np.zeros([len(actions), 3])
    elif a_type[0] == 'c':
      rotat = np.zeros([len(actions)])

    for idx, action_i in enumerate(actions):
        rotat[idx] =  all_actions[action_i]
    reward = reward_game(rotat, a_type)
    return reward #, ent

def simulate(agents, time, all_actions, a_type, l): 
    q_table =      [0 for i in range(len(agents))] 
    act_pro =      [0 for i in range(len(agents))] 
    actions =      [0 for i in range(len(agents))] 
    reward =       [0 for i in range(len(agents))]
    rewards =      np.zeros((len(agents), time))
    rewards_avg =  np.zeros(rewards.shape) 
    temp =         [0 for i in range(len(agents))]
    temperatures = [[0] for i in range(len(agents))]
    #entanglements =     np.zeros(time)
    #entanglements_avg = np.zeros(entanglements.shape) 

    for t in trange(time):
        for i, agent in enumerate(agents):
            if t==0:
                actions[i], temp[i] = agent.reset()
            else:
                rewards[i, t] = reward[i]
                if t<50000:
                  rewards_avg[i, t] = np.mean(rewards[i,0:t+1])
                else:
                  rewards_avg[i, t] = np.mean(rewards[i,t-50000:t+1])
                agent.step(actions[i], reward[i])
                actions[i], temp[i] = agent.act(t,l)
            temperatures[i].append(temp[i])
        reward = game(all_actions, actions, a_type)
        #entanglements[t] = entanglement
        #entanglements_avg[t] = np.mean(entanglements[0:t+1])

    for i, agent in enumerate(agents):
      q_table[i], act_pro[i] = agent.end()
    return rewards, rewards_avg, q_table, act_pro, temperatures #, entanglements, entanglements_avg

players = 5
time = 200000
epsilon = 0.1
lamda = 0.5
To = 0
Tf = 0.125
tau = 100000
N_SIZE = 3
a_types = [['c'],
           ['q', 8 *np.pi/16, 0]
           #['q', 7 *np.pi/16, 0],
           #['q', 6 *np.pi/16, 0],
           #['q', 5 *np.pi/16, 0],
           #['q', 4 *np.pi/16, 0],
           #['q', 3 *np.pi/16, 0],
           #['q', 2 *np.pi/16, 0],
           #['q', 1 *np.pi/16, 0],
           #['q', 0 *np.pi/16, 0],
           #['q', 8 *np.pi/16, 0.01],
           #['q', 8 *np.pi/16, 0.02],
           #['q', 8 *np.pi/16, 0.03],
           #['q', 8 *np.pi/16, 0.04],
           #['q', 8 *np.pi/16, 0.05],
           #['q', 8 *np.pi/16, 0.06],
           #['q', 8 *np.pi/16, 0.07],
           #['q', 8 *np.pi/16, 0.08],
           #['q', 8 *np.pi/16, 0.09],
           #['q', 8 *np.pi/16, 0.10],
           #['q', 8 *np.pi/16, 0.15],
           #['q', 8 *np.pi/16, 0.2],
           #['q', 8 *np.pi/16, 0.3],
           #['q', 8 *np.pi/16, 0.4],
           #['q', 8 *np.pi/16, 0.5],
           #['q', 8 *np.pi/16, 0.75],
           #['q', 8 *np.pi/16, 1],
           ] # ['c'] or ['q', gamma, lamda]
print("Players = {}. Time = {}. Epsilon = {}. Lamda = {}. To = {}. Tf = {}. tau = {}. N_SIZE = {}. a_types = {}.".format(players, time, epsilon, lamda, To, Tf, tau, N_SIZE, a_types))

title_label = [""] * len(a_types)
temperatures =      [None] * len(a_types)
#entanglements =     [None] * len(a_types)
#entanglements_avg = [None] * len(a_types)
rewards =           [None] * len(a_types)
rewards_avg =       [None] * len(a_types)
q_table =           [None] * len(a_types)
act_pro =           [None] * len(a_types)

for x, a_type in enumerate(a_types):
  if a_type[0] == 'q':
    angulos = np.arange(0, 2 * np.pi, 2 * np.pi / np.power(2, N_SIZE))
    all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]
  elif a_type[0] == 'c':
    all_actions = [0, 1]
            
  title_label[x] = "Game type = {}.".format(a_type)
  agents = []
  for i in range(players):
      agents.append(Agent(n_anctions=len(all_actions), epsilon_0=epsilon, Tf=Tf, To=To, tau=tau))
  rewards[x], rewards_avg[x], q_table[x], act_pro[x], temperatures[x] = simulate(agents, time, all_actions, a_type, lamda)

  for i in range(players):
    print("Type = {}. Player {} => Final avg reward = {}.".format(a_types[x], i, rewards_avg[x][i][-1]))

index_q = 1
fig0, axs = plt.subplots(3, 3, figsize=(40,20))
for i in range(players):
    axs[0,0].plot(rewards_avg[0][i], label="Player {}".format(i))
    axs[1,0].plot(q_table[0][i], label="Player {}".format(i))
    axs[2,0].plot(act_pro[0][i], label="Player {}".format(i)) 
    axs[0,1].plot(rewards_avg[index_q][i], label="Player {}".format(i))
    axs[1,1].plot(q_table[index_q][i], label="Player {}".format(i))
    axs[2,1].plot(act_pro[index_q][i], label="Player {}".format(i)) 
    axs[0,2].plot(rewards_avg[index_q][i] / (rewards_avg[0][i] + 0.001), label="Player {}".format(i)) 
    axs[1,2].plot(temperatures[0][i], label="Player {}".format(i))
    axs[2,2].plot(temperatures[1][i], label="Player {}".format(i))
 
axs[0,0].set_title("Classic Average Reward")
axs[0,0].set_xlabel("Episode")
axs[0,0].set_ylabel("Mean Reward")
axs[0,0].legend(loc='upper left')
axs[0,0].set_ylim(0, 10)

axs[1,0].set_title("Q-values for each action")
axs[1,0].set_ylabel("Action Value")
axs[1,0].set_xlabel("Action")
axs[1,0].legend(loc='upper left')
axs[1,0].set_ylim(0, 10)

axs[2,0].set_title("PDF over actions")
axs[2,0].set_ylabel("Probability")
axs[2,0].set_xlabel("Action")
axs[2,0].legend(loc='upper left')
axs[2,0].set_ylim(0, 1)

axs[0,1].set_title("Quantum Average Reward")
axs[0,1].set_xlabel("Episode")
axs[0,1].set_ylabel("Mean Reward")
axs[0,1].legend(loc='upper left')
axs[0,1].set_ylim(0, 10)

axs[1,1].set_title("Q-values for each action")
axs[1,1].set_ylabel("Action Value")
axs[1,1].set_xlabel("Action")
axs[1,1].legend(loc='upper left')
axs[1,1].set_ylim(0, 10)

axs[2,1].set_title("PDF over actions")
axs[2,1].set_ylabel("Probability")
axs[2,1].set_xlabel("Action")
axs[2,1].legend(loc='upper left')
#axs[2,1].set_ylim(0, 1)

axs[0,2].set_title("(Quantum / Classical) Rewards")
axs[0,2].set_xlabel("Episode")
axs[0,2].set_ylabel("Rq/Rc")
"""hl = np.max([np.mean(rewards[index_q][0][5*tau:time])/np.mean(rewards[0][0][5*tau:time]), 
             np.mean(rewards[index_q][1][5*tau:time])/np.mean(rewards[0][1][5*tau:time])])
axs[0,2].hlines(hl, 0, time, color='red', label= 'Rq changes sign')"""
axs[0,2].legend()
#axs[0,2].set_ylim(0, 2)

axs[1,2].set_title("Temperature {}".format(title_label[0]))
axs[1,2].set_xlabel("Episode")
axs[1,2].set_ylabel("T")
axs[1,2].legend(loc='upper right')
#axs[1,2].set_ylim(0, 1)

axs[2,2].set_title("Temperature {}".format(title_label[1]))
axs[2,2].set_xlabel("Episode")
axs[2,2].set_ylabel("T") 
axs[2,2].legend(loc='upper right')
#axs[2,2].set_ylim(0, 1)

plt.show()