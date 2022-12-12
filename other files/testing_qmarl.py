import numpy as np
from tqdm import trange
import matplotlib.pyplot as plt

from qiskit import QuantumCircuit, Aer, execute
from qiskit.quantum_info import Operator
from qiskit.extensions import RXGate, RYGate, RZGate   

class Bandit:
    def __init__(self, all_actions, epsilon_0=0.9, e_decay=0.99, step_size=0.1, gradient=False):
        self.epsilon_0 = epsilon_0
        self.e_decay = e_decay
        self.all_actions = all_actions
        self.indices = np.arange(len(self.all_actions))
        self.gradient = gradient
        self.step_size = step_size

    def reset(self):
        self.q_estimation = np.zeros(len(self.indices))
        self.epsilon = self.epsilon_0
        self.action_count = np.zeros(len(self.indices))
        self.average_reward = 0
        self.time = 0        

    def act(self):
        if self.gradient:
            exp_est = np.exp(self.q_estimation)
            self.action_prob = exp_est / np.sum(exp_est)
            return np.random.choice(self.indices, p=self.action_prob)
        self.epsilon *= self.e_decay
        if np.random.rand() < self.epsilon:
            return np.random.choice(self.indices)            
        q_best = np.max(self.q_estimation)
        return np.random.choice(np.where(self.q_estimation == q_best)[0])

    def step(self, action):
        rotat = self.all_actions[action]
        reward = reward_game(rotat, rotat)
        if self.gradient:
            one_hot = np.zeros(len(self.all_actions))
            one_hot[action] = 1
            self.time += 1
            self.average_reward += (reward - self.average_reward) / self.time
            baseline = self.average_reward
            self.q_estimation += self.step_size * (reward - baseline) * (one_hot - self.action_prob)
        else:
            self.action_count[action] += 1
            self.q_estimation[action] += (reward - self.q_estimation[action]) / self.action_count[action]
        return reward

def crear_circuito(tipo1, tipo2):
    I = np.array([[1, 0],
                  [0, 1]])
    X = np.array([[0, 1],
                  [1, 0]])    
    I_f = np.kron(I, I)
    X_f = np.kron(X, X)
    
    J = Operator(1 / np.sqrt(2) * (I_f + 1j * X_f))    
    J_dg = J.adjoint()
    circ = QuantumCircuit(2,2)
    circ.append(J, range(2))    
    circ.append(RXGate(tipo1[0]),[0])
    circ.append(RYGate(tipo1[1]),[0])
    circ.append(RZGate(tipo1[2]),[0])   
    circ.append(RXGate(tipo2[0]),[1])
    circ.append(RYGate(tipo2[1]),[1])
    circ.append(RZGate(tipo2[2]),[1])    
    circ.append(J_dg, range(2))
    circ.measure(range(2), range(2))  
    return circ

def reward_game(rotat1, rotat2):
    circ = crear_circuito(rotat1, rotat2)
    backend = Aer.get_backend('qasm_simulator')
    measurement = execute(circ, backend=backend, shots=1).result().get_counts(circ)    
    output = list(measurement.keys())[0]
    if output == '00':
        return 3+3
    elif output == '01':
        return 0+5
    elif output == '10':
        return 5+0
    elif output == '11':
        return 1+1

def simulate(bandits, time, runs):
    rewards = np.zeros((len(bandits), runs, time))
    rewards_avg = np.zeros(rewards.shape)  
    for i, bandit in enumerate(bandits):
        for r in range(runs):   
            print("ITERATION n° {}:".format(r))
            r_max = 0
            bandit.reset()
            for t in trange(time):    
                action = bandit.act()
                reward = bandit.step(action)
                if reward > r_max:
                    r_max = reward
                    print("Episode = {}. Max_reward = {}".format(t, r_max))
                rewards[i, r, t] = reward
                rewards_avg[i, r, t] = np.mean(rewards[i,r,0:t+1])   
    mean_rewards = rewards.mean(axis=1)
    mean_rewards_avg = rewards_avg.mean(axis=1)
    return mean_rewards, mean_rewards_avg      

def VQC():
    N_SIZE = 3
    angulos = np.arange(0, 2 * np.pi, 2 * np.pi / np.power(2, N_SIZE))
    all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]
    runs = 2
    time = 1000
    epsilon_0 = 0.99
    epsilon_f = 0.01
    step_size = [0.1]
    e_decay = np.power(epsilon_f/epsilon_0, 1/time)
    bandits = []
    bandits.append(Bandit(all_actions=all_actions, epsilon_0=epsilon_0, e_decay=e_decay))  
    bandits.append(Bandit(all_actions=all_actions, step_size = step_size[0], gradient=True))  
    mean_rewards , mean_rewards_avg = simulate(bandits, time, runs) 
    for i in range(len(bandits)):
        print("Final avg reward = {}.".format(mean_rewards_avg[i][-1]))

    labels = ['e0 = {}, ef = {}, ed = {:.3f}. a = 1/n.'.format(epsilon_0, epsilon_f, e_decay),
              'a = {}, gradient ascent'.format(step_size[0])]

    fig, axs = plt.subplots(2, 1, figsize=(30,20))
    for i in range(len(bandits)):
        axs[0].plot(mean_rewards[i], label=labels[i])
        axs[1].plot(mean_rewards_avg[i], label=labels[i])    
    axs[0].set_title("Learning strategies in Quantum Games (Reward)")
    axs[1].set_title("Learning strategies in Quantum Games (Avg Reward)")
    axs[0].set_ylabel("Reward")
    axs[1].set_ylabel("Mean Reward")
    axs[1].set_xlabel("Episodes")
    axs[1].legend(loc='upper right')
    plt.show()

if __name__ == '__main__':
    VQC()        