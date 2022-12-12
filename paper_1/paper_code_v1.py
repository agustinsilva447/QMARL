import matplotlib.pyplot as plt
import numpy as np
from tqdm import trange

class Agent:
    def __init__(self, n_anctions, epsilon_0=0, Tf=0.125, To=5, tau = 10000):
        self.To = To
        self.Tf = Tf
        self.tau = tau
        self.epsilon_0 = epsilon_0
        self.indices = np.arange(n_anctions)

    def reset(self, q_initial = None):
        if q_initial:
          self.q_estimation = q_initial
        self.q_estimation = np.zeros(len(self.indices)) + 10
        self.action_count = np.zeros(len(self.indices))
        return np.random.choice(self.indices)

    def act(self, t):
        self.Tb = self.Tf + (self.To - self.Tf) * np.power(np.e, -t/self.tau)
        if np.random.rand() < self.epsilon_0:
            return np.random.choice(self.indices)   
        if self.Tb < 0.0125:
          q_best = np.max(self.q_estimation)
          return np.random.choice(np.where(self.q_estimation == q_best)[0])
        exp_est = np.exp(self.q_estimation / self.Tb)
        act_pro = exp_est / np.sum(exp_est)
        return np.random.choice(self.indices, p=act_pro)

    def step(self, action, reward):
        self.action_count[action] += 1      
        self.q_estimation[action] += (reward - self.q_estimation[action]) / self.action_count[action]
    
    def end(self): 
        if self.Tb == 0:
          act_pro = self.q_estimation/np.sum(self.q_estimation)
        else:
          exp_est = np.exp(self.q_estimation / self.Tb)
          act_pro = exp_est / np.sum(exp_est)
        return self.q_estimation, act_pro

def classical_game_Nplayers(rotat):
  output = ""
  for i in rotat:
    output += str(int(i))
  return output, 0

"""
def VQC_QGT_2players(rotat):
  c = np.rint([rotat[0][0] / (np.pi/4), 
               rotat[0][1] / (np.pi/4), 
               rotat[0][2] / (np.pi/4), 
               rotat[1][0] / (np.pi/4), 
               rotat[1][1] / (np.pi/4), 
               rotat[1][2] / (np.pi/4)])
  a1 = int(c[0])
  a2 = int(c[1])
  a3 = int(c[2])
  b1 = int(c[3])
  b2 = int(c[4])
  b3 = int(c[5])
  
  factor_p = 0.015625
  cos_rot = [1, 0.92388, 0.707107, 0.382683, 0, -0.382683, -0.707107, -0.92388, -1, -0.92388, -0.707107, -0.382683, 0, 0.382683, 0.707107, 0.92388]
  sin_rot = [0, 0.382683, 0.707107, 0.92388, 1, 0.92388 , 0.707107, 0.382683, 0, -0.382683, -0.707107, -0.92388, -1, -0.92388 , -0.707107, -0.382683]
  
  aux01 = (b2 - a1 - a3 + a2 + b1 + b3) % 16
  aux02 = (b2 - a1 + a3 - a2 + b1 + b3) % 16
  aux03 = (b2 - a1 + a3 + a2 - b1 + b3) % 16
  aux04 = (b2 - a1 + a3 + a2 + b1 - b3) % 16
  aux05 = (b3 - a1 + a3 + a2 + b1 - b2) % 16
  aux06 = (b3 - a1 + a3 + a2 + b1 + b2) % 16    
  aux07 = (a1 - a3 - a2 - b1 + b3 + b2) % 16
  aux08 = (a1 - a3 - a2 + b1 - b3 + b2) % 16
  aux09 = (a1 - a3 - a2 + b1 + b3 - b2) % 16
  aux10 = (a1 - a3 - a2 + b1 + b3 + b2) % 16
  aux11 = (a1 - a3 + a2 - b1 - b3 + b2) % 16
  aux12 = (a1 - a3 + a2 - b1 + b3 - b2) % 16    
  aux13 = (a1 - a3 + a2 - b1 + b3 + b2) % 16
  aux14 = (a1 - a3 + a2 + b1 - b3 - b2) % 16
  aux15 = (a1 - a3 + a2 + b1 - b3 + b2) % 16
  aux16 = (a1 - a3 + a2 + b1 + b3 - b2) % 16
  aux17 = (a1 - a3 + a2 + b1 + b3 + b2) % 16
  aux18 = (a1 + a3 - a2 - b1 - b3 + b2) % 16    
  aux19 = (a1 + a3 - a2 - b1 + b3 - b2) % 16
  aux20 = (a1 + a3 - a2 - b1 + b3 + b2) % 16
  aux21 = (a1 + a3 - a2 + b1 - b3 - b2) % 16
  aux22 = (a1 + a3 - a2 + b1 - b3 + b2) % 16
  aux23 = (a1 + a3 - a2 + b1 + b3 - b2) % 16
  aux24 = (a1 + a3 - a2 + b1 + b3 + b2) % 16    
  aux25 = (a1 + a3 + a2 - b1 - b3 - b2) % 16
  aux26 = (a1 + a3 + a2 - b1 - b3 + b2) % 16
  aux27 = (a1 + a3 + a2 - b1 + b3 - b2) % 16
  aux28 = (a1 + a3 + a2 - b1 + b3 + b2) % 16
  aux29 = (a1 + a3 + a2 + b1 - b3 - b2) % 16
  aux30 = (a1 + a3 + a2 + b1 - b3 + b2) % 16
  aux31 = (a1 + a3 + a2 + b1 + b3 - b2) % 16
  aux32 = (a1 + a3 + a2 + b1 + b3 + b2) % 16
  aux1 = (a2 - b1 + b3) % 16
  aux2 = (a2 - b1) % 16
  aux3 = (a2 + b1) % 16
  aux4 = (a1 + b2) % 16
  aux5 = (a1 - b2) % 16
  aux6 = (a3 + b2) % 16
  aux7 = (a2 + b1) % 16

  p00_tmp1 = cos_rot[aux01] - cos_rot[aux02] - cos_rot[aux03] + cos_rot[aux04] + cos_rot[aux05] + cos_rot[aux06] - cos_rot[aux07] + cos_rot[aux08];    
  p00_tmp2 = cos_rot[aux16] - cos_rot[aux09] - cos_rot[aux10] - cos_rot[aux11] - cos_rot[aux12] + cos_rot[aux13] + cos_rot[aux14] - cos_rot[aux15];    
  p00_tmp3 = cos_rot[aux17] + cos_rot[aux18] - cos_rot[aux19] + cos_rot[aux20] - cos_rot[aux21] + cos_rot[aux22] + cos_rot[aux23] + cos_rot[aux24];
  p00_tmp4 = cos_rot[aux25] + cos_rot[aux26] - cos_rot[aux27] + cos_rot[aux28] - cos_rot[aux29] + cos_rot[aux30] + cos_rot[aux31] + cos_rot[aux32];
  p00_tmp0 = p00_tmp1 + p00_tmp2 + p00_tmp3 + p00_tmp4;
  p00_tmp  = factor_p * p00_tmp0 * p00_tmp0; 

  p01_tmp1 = sin_rot[aux08] - sin_rot[aux01] + sin_rot[aux02] + sin_rot[aux03] + sin_rot[aux04] - sin_rot[aux05] - sin_rot[aux06] + sin_rot[aux07];    
  p01_tmp2 = sin_rot[aux09] + sin_rot[aux10] - sin_rot[aux11] + sin_rot[aux12] - sin_rot[aux13] + sin_rot[aux14] - sin_rot[aux15] - sin_rot[aux16];    
  p01_tmp3 = sin_rot[aux22] - sin_rot[aux17] + sin_rot[aux18] + sin_rot[aux19] - sin_rot[aux20] - sin_rot[aux21] - sin_rot[aux23] - sin_rot[aux24];
  p01_tmp4 = sin_rot[aux25] + sin_rot[aux26] + sin_rot[aux27] - sin_rot[aux28] - sin_rot[aux29] + sin_rot[aux30] - sin_rot[aux31] - sin_rot[aux32];
  p01_tmp0 = p01_tmp1 + p01_tmp2 + p01_tmp3 + p01_tmp4;
  p01_tmp  = factor_p * p01_tmp0 * p01_tmp0; 

  p10_tmp1 = sin_rot[aux01] + sin_rot[aux02] + sin_rot[aux03] - sin_rot[aux04] - sin_rot[aux05] - sin_rot[aux06] - sin_rot[aux07] + sin_rot[aux08];
  p10_tmp2 = sin_rot[aux16] - sin_rot[aux09] - sin_rot[aux10] - sin_rot[aux11] - sin_rot[aux12] + sin_rot[aux13] + sin_rot[aux14] - sin_rot[aux15];
  p10_tmp3 = sin_rot[aux17] - sin_rot[aux18] + sin_rot[aux19] - sin_rot[aux20] + sin_rot[aux21] - sin_rot[aux22] - sin_rot[aux23] - sin_rot[aux24];
  p10_tmp4 = sin_rot[aux29] - sin_rot[aux25] - sin_rot[aux26] + sin_rot[aux27] - sin_rot[aux28] - sin_rot[aux30] - sin_rot[aux31] - sin_rot[aux32];
  p10_tmp0 = p10_tmp1 + p10_tmp2 + p10_tmp3 + p10_tmp4;
  p10_tmp  = factor_p * p10_tmp0 * p10_tmp0; 

  p11_tmp1 = sin_rot[a1] * sin_rot[a3] * sin_rot[b2] * sin_rot[aux1];
  p11_tmp2 = sin_rot[a1] * sin_rot[b3] * cos_rot[a3] * cos_rot[b2] * cos_rot[aux2];
  p11_tmp3 = sin_rot[a3] * cos_rot[a1] * cos_rot[b3] * cos_rot[b2] * sin_rot[aux3];
  p11_tmp4 = sin_rot[a2] * cos_rot[a3] * cos_rot[b1] * cos_rot[b3] * sin_rot[aux4];
  p11_tmp5 = sin_rot[b1] * cos_rot[a3] * cos_rot[a2] * cos_rot[b3] * sin_rot[aux5];
  p11_tmp6 = sin_rot[b3] * cos_rot[a1] * sin_rot[aux6] * cos_rot[aux7];
  p11_tmp0 = p11_tmp1 - p11_tmp2 - p11_tmp3 + p11_tmp4 - p11_tmp5 - p11_tmp6;
  p11_tmp  = p11_tmp0 * p11_tmp0;   

  pure_state = [p00_tmp, 1j * p01_tmp, 1j * p10_tmp, p11_tmp];
  out_pro = [p00_tmp, p01_tmp, p10_tmp, p11_tmp]
  output = np.random.choice(["00", "01", "10", "11"], p=out_pro / np.sum(out_pro))

  return output, 0
"""

"""
from qiskit import QuantumCircuit, Aer, execute
from qiskit.quantum_info import Operator
from qiskit.extensions import RXGate, RYGate, RZGate
from qiskit.quantum_info import entanglement_of_formation

def Qiskit_QGT_Nplayers(tipo, gamma = 2 *np.pi/16):
    n_players = len(tipo)    
    I = np.array([[1, 0], [0, 1]])
    X = np.array([[0, 1], [1, 0]])
    I_f = I
    X_f = X
    for i in range(n_players-1):
        I_f = np.kron(I_f, I)
        X_f = np.kron(X_f, X)    
    J = Operator(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
    J_dg = J.adjoint()

    circ = QuantumCircuit(n_players, n_players)
    circ.append(J, range(n_players))    
    for i in range(n_players):        
        circ.append(RXGate(tipo[i][0]),[(n_players - 1 - i)])
        circ.append(RYGate(tipo[i][1]),[(n_players - 1 - i)])
        circ.append(RXGate(tipo[i][2]),[(n_players - 1 - i)])     
    circ.append(J_dg, range(n_players))

    backend = Aer.get_backend('statevector_simulator')
    result = backend.run(circ).result()
    outputstate = result.get_statevector(circ)
    ent_of_formation = entanglement_of_formation(outputstate)
    prob = np.power(np.abs(outputstate),2)
    output = np.random.choice(["00", "01", "10", "11"], p=prob)
    return output, ent_of_formation, outputstate, prob
"""

from qiskit.quantum_info import entanglement_of_formation

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

def Numpy_QGT_2players(tipo, gamma = 8 *np.pi/16, lamda = 0):

    init_state = np.matrix([[1], [0], [0], [0]])
    I = np.array([[1, 0], [0, 1]])
    X = np.array([[0, 1], [1, 0]])    
    I_f = np.kron(I, I)
    X_f = np.kron(X, X)    

    J = np.matrix(np.cos(gamma/2) * I_f + 1j * np.sin(gamma/2) * X_f)
    player_0_gate = final_strategy(rX_numpy(tipo[0][0]), rY_numpy(tipo[0][1]), rX_numpy(tipo[0][2]), depolarization(lamda))
    player_1_gate = final_strategy(rX_numpy(tipo[1][0]), rY_numpy(tipo[1][1]), rX_numpy(tipo[1][2]), depolarization(lamda))
    strategies_gate = np.kron(player_0_gate, player_1_gate)
    J_dg = J.H

    outputstate = J_dg * strategies_gate * J * init_state
    ent_of_formation = entanglement_of_formation(outputstate)
    prob = np.power(np.abs(outputstate),2)
    output = np.random.choice(["00", "01", "10", "11"], p=np.asarray(prob).reshape(-1))
    return output, ent_of_formation, outputstate, prob

def minority_variant(output):
    # Minority game variant (only 1s)  
    reward = [0 for i in range(len(output))]
    if (output.count('1') == 1):
        reward[output.find('1')] = 10
    return reward
    
def prisoners_variant(output):
    # Prisoner's variant with rewards
    if output == "00":
      return [6.6, 6.6]
    elif output == "01":
      return [10, 0]
    elif output == "10":
      return [0, 10]
    elif output == "11":
      return [3.3, 3.3]
    
def prisoners_dilemma_1(output):
    # Prisoner's dilemma with rewards
    if output == "00":
      return [6.6, 6.6]
    elif output == "01":
      return [0, 10]
    elif output == "10":
      return [10, 0]
    elif output == "11":
      return [3.3, 3.3]
    
def prisoners_dilemma_2(output):
    # Prisoner's dilemma with rewards
    if output == "00":
      return [5, 5]
    elif output == "01":
      return [-10, 30]
    elif output == "10":
      return [30, -10]
    elif output == "11":
      return [-5, -5]

def disc_game(output):
    #  Discoordination games have no pure Nash equilibria
    if output == "00":
      return [10, 0]
    elif output == "01":
      return [0, 10]
    elif output == "10":
      return [0, 10]
    elif output == "11":
      return [10, 0]

def reward_game(rotat, a_type):
    if a_type[0] == 'q':    
      output, ent, _s, _p = Numpy_QGT_2players(rotat, a_type[1], a_type[2])
      #output, ent, _s, _p = Qiskit_QGT_Nplayers(rotat)
      #output, ent = VQC_QGT_2players(rotat) 
    elif a_type[0] == 'c':
      output, ent = classical_game_Nplayers(rotat)       
    return prisoners_dilemma_2(output), ent   

def game(all_actions, actions, a_type):
    if a_type[0] == 'q':    
      rotat = np.zeros([len(actions), 3])
    elif a_type[0] == 'c':
      rotat = np.zeros([len(actions)])

    for idx, action_i in enumerate(actions):
        rotat[idx] =  all_actions[action_i]            
    reward, ent = reward_game(rotat, a_type)      
    return reward, ent

def simulate(agents, time, all_actions, a_type): 
    q_table =     [0 for i in range(len(agents))] 
    act_pro =     [0 for i in range(len(agents))] 
    actions =     [0 for i in range(len(agents))] 
    reward =      [0 for i in range(len(agents))]
    rewards =     np.zeros((len(agents), time))
    rewards_avg = np.zeros(rewards.shape) 
    entanglements =     np.zeros(time)
    entanglements_avg = np.zeros(entanglements.shape) 

    for t in trange(time):    
        for i, agent in enumerate(agents):
            if t==0:
                actions[i] = agent.reset()
            else:                
                rewards[i, t] = reward[i]  
                rewards_avg[i, t] = np.mean(rewards[i,0:t+1])   
                agent.step(actions[i], reward[i])
                actions[i] = agent.act(t)
        reward, entanglement = game(all_actions, actions, a_type)        
        entanglements[t] = entanglement
        entanglements_avg[t] = np.mean(entanglements[0:t+1])   

    for i, agent in enumerate(agents):
      q_table[i], act_pro[i] = agent.end()
    return rewards, rewards_avg, q_table, act_pro, entanglements, entanglements_avg              


players = 2
a_types = [['c'],
           ['q', 8 *np.pi/16, 0],
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
time = 200000
tau =   30000
To = 5
Tf = 0.125
epsilon = 0.01
N_SIZE = 3

title_label = [""] * len(a_types)
entanglements =     [None] * len(a_types)
entanglements_avg = [None] * len(a_types)
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
            
  title_label[x] = "Game type = {}, epsilon = {}, temperature = {}".format(a_type, epsilon, Tf)
  agents = []
  for i in range(players):
      agents.append(Agent(n_anctions=len(all_actions), epsilon_0=epsilon, Tf=Tf, To=To, tau=tau))
  rewards[x], rewards_avg[x], q_table[x], act_pro[x], entanglements[x], entanglements_avg[x] = simulate(agents, time, all_actions, a_type)

  for i in range(players):
    print("Type = {}. Player {} => Final avg reward = {}.".format(a_types[x], i, rewards_avg[x][i][-1]))
    if x>=1:
      print("Rqc0 = Rq0 / Rc0 = {}/{} = {}".format(np.mean(rewards[x][i][5*tau:time]),np.mean(rewards[0][i][5*tau:time]),np.mean(rewards[x][i][5*tau:time])/np.mean(rewards[0][i][5*tau:time])))
  print("Entanglement final = {}\n".format(entanglements_avg[x][-1]))

"""
angulos = np.arange(0, 2 * np.pi, 2 * np.pi / np.power(2, N_SIZE))
all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]

for x,y in enumerate(all_actions):
  if act_pro[1][0][x] == np.max(act_pro[1][0]):
    s_p0 = y
  if act_pro[1][1][x] == np.max(act_pro[1][1]):
    s_p1 = y

otp_f, ent_f, qst_f, pro_f = Numpy_QGT_2players([s_p0, s_p1])

print("Player 0 best strategy =", s_p0)
print("Player 1 best strategy =", s_p1)
print("Quantum State = [{}, {} ,{} ,{}]".format(qst_f[0], qst_f[1], qst_f[2], qst_f[3]))
print("Probabilities = {}".format(pro_f))
print("Entanglement =", ent_f)
"""

index_q = 1

fig0, axs = plt.subplots(3, 3, figsize=(40,20))
for i in range(players):
    axs[0,0].plot(rewards_avg[0][i], label="Player {}".format(i))
    axs[1,0].plot(q_table[0][i], label="Player {}".format(i))    
    axs[2,0].plot(act_pro[0][i], label="Player {}".format(i))   
    axs[0,1].plot(rewards_avg[index_q][i], label="Player {}".format(i))
    axs[1,1].plot(q_table[index_q][i], label="Player {}".format(i))    
    axs[2,1].plot(act_pro[index_q][i], label="Player {}".format(i)) 
    axs[0,2].plot(rewards_avg[index_q][i] / rewards_avg[0][i], label="Player {}".format(i)) 
 
axs[0,0].set_title("Average reward ({})".format(title_label[0]))
axs[0,0].set_xlabel("Episode")
axs[0,0].set_ylabel("Mean Reward")
axs[0,0].legend(loc='upper right')
#axs[0,0].set_ylim(0, 10)

axs[1,0].set_title("Q-values of players for each action")
axs[1,0].set_ylabel("Action Value")
axs[1,0].set_xlabel("Action")
axs[1,0].legend(loc='upper right')
#axs[1,0].set_ylim(0, 10)

axs[2,0].set_title("Probability distribution over actions")
axs[2,0].set_ylabel("Probability")
axs[2,0].set_xlabel("Action")
axs[2,0].legend(loc='upper right')
#axs[2,0].set_ylim(0, 1)
      
axs[0,1].set_title("Average reward ({})".format(title_label[1]))
axs[0,1].set_xlabel("Episode")
axs[0,1].set_ylabel("Mean Reward")
axs[0,1].legend(loc='upper right')
#axs[0,1].set_ylim(0, 10)

axs[1,1].set_title("Q-values of players for each action")
axs[1,1].set_ylabel("Action Value")
axs[1,1].set_xlabel("Action")
axs[1,1].legend(loc='upper right')
#axs[1,1].set_ylim(0, 10)

axs[2,1].set_title("Probability distribution over actions")
axs[2,1].set_ylabel("Probability")
axs[2,1].set_xlabel("Action")
axs[2,1].legend(loc='upper right')
#axs[2,1].set_ylim(0, 1)
      
axs[0,2].set_title("Quantum Rewards / Classical Rewards ({})".format(title_label[1]))
axs[0,2].set_xlabel("Episode")
axs[0,2].set_ylabel("Rq/Rc")
hl = np.max([np.mean(rewards[index_q][0][5*tau:time])/np.mean(rewards[0][0][5*tau:time]), 
             np.mean(rewards[index_q][1][5*tau:time])/np.mean(rewards[0][1][5*tau:time])])
axs[0,2].hlines(hl, 0, time, color='red', label= 'Rq changes sign')
axs[0,2].legend()
#axs[0,2].set_ylim(-3, 1)

axs[1,2].plot(entanglements[index_q])  
axs[1,2].set_title("Step by Step Entanglement".format(title_label[0]))
axs[1,2].set_xlabel("Episode")
axs[1,2].set_ylabel("Entanglement")
axs[1,2].set_ylim(0, 1)

axs[2,2].plot(entanglements_avg[index_q]) 
axs[2,2].set_title("Entanglement of output state  [Avg]".format(title_label[0]))
axs[2,2].set_xlabel("Episode")
axs[2,2].set_ylabel("Entanglement") 
axs[2,2].set_ylim(0, 1)

plt.show()