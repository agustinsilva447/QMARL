import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange

from qiskit import QuantumCircuit, Aer, execute
from qiskit.quantum_info import Operator
from qiskit.extensions import RXGate, RYGate, RZGate   

class Bandit:
    def __init__(self, all_actions, epsilon_0=0.1, e_decay=1, step_size=0.1, sample_averages = False, gradient=False):
        self.all_actions = all_actions
        self.epsilon_0 = epsilon_0
        self.e_decay = e_decay
        self.step_size = step_size
        self.sample_averages = sample_averages
        self.gradient = gradient
        self.indices = np.arange(len(self.all_actions))

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

    def step(self, actions, i):
        rotat = np.zeros([len(actions), 3])
        for idx, action_i in enumerate(actions):
            rotat[idx] =  self.all_actions[action_i]        
        action = actions[i]
        reward = reward_game(rotat[0], rotat[1])[i]
        
        if self.sample_averages:
            self.action_count[action] += 1
            self.step_size = 1 / self.action_count[action]
        if self.gradient:
            one_hot = np.zeros(len(self.all_actions))
            one_hot[action] = 1
            self.time += 1
            self.average_reward += (reward - self.average_reward) / self.time
            baseline = self.average_reward
            self.q_estimation += self.step_size * (reward - baseline) * (one_hot - self.action_prob)
        else:            
            self.q_estimation[action] += self.step_size * (reward - self.q_estimation[action])
        return reward, self.q_estimation

def crear_circuito(tipo0, tipo1):
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
    circ.append(RXGate(tipo0[0]),[0])
    circ.append(RYGate(tipo0[1]),[0])
    circ.append(RZGate(tipo0[2]),[0])   
    circ.append(RXGate(tipo1[0]),[1])
    circ.append(RYGate(tipo1[1]),[1])
    circ.append(RZGate(tipo1[2]),[1])    
    circ.append(J_dg, range(2))
    return circ

def reward_game(rotat0, rotat1):
    circ = crear_circuito(rotat0, rotat1)
    circ.measure(range(2), range(2))  
    backend = Aer.get_backend('qasm_simulator')
    measurement = execute(circ, backend=backend, shots=1).result().get_counts(circ)    
    output = list(measurement.keys())[0]
    if output == '00':
        return [3,2]
    elif output == '01':
        return [0,0]
    elif output == '10':
        return [0,0]
    elif output == '11':
        return [2,3]

def simulate(bandits, time, runs):
    rewards     = np.zeros((len(bandits), runs, time))
    rewards_avg = np.zeros(rewards.shape)  
    reward = []
    actions = []
    q_table = []
    reward_max = []
    actions_max = []
    reward = [0 for i in range(len(bandits))]
    actions = [0 for i in range(len(bandits))] 
    q_table = [0 for i in range(len(bandits))] 
    reward_max = [0 for i in range(len(bandits))] 
    actions_max = [0 for i in range(len(bandits))] 
    for r in range(runs):   
        print("ITERATION n° {}:".format(r+1))
        for i, bandit in enumerate(bandits):
            bandit.reset()
        for t in trange(time):    
            for i, bandit in enumerate(bandits):
                actions[i] = bandit.act()
                
            for i, bandit in enumerate(bandits):
                reward[i], q_table[i] = bandit.step(actions, i)
                if reward[i] > reward_max[i]:
                    actions_max[i] = actions[i]

            for i in range(len(bandits)):
                rewards[i, r, t] = reward[i]  
                rewards_avg[i, r, t] = np.mean(rewards[i,r,0:t+1])    
    mean_rewards = rewards.mean(axis=1)
    mean_rewards_avg = rewards_avg.mean(axis=1)
    return mean_rewards, mean_rewards_avg, actions_max, q_table

def VQC():
    N_SIZE = 3
    angulos = np.arange(0, 2 * np.pi, 2 * np.pi / np.power(2, N_SIZE))
    all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]
    runs = 1
    time = 1000
    epsilon_0 = 0.99
    epsilon_f = 0.01
    e_decay = np.power(epsilon_f/epsilon_0, 1/time)
    bandits = []
    bandits.append(Bandit(all_actions=all_actions, epsilon_0=epsilon_0, e_decay=e_decay, sample_averages=True))  
    bandits.append(Bandit(all_actions=all_actions, sample_averages=True, gradient=True))  
    mean_rewards , mean_rewards_avg, actions_max, q_table = simulate(bandits, time, runs) 
    exp_est = np.exp(q_table)
    probas = exp_est / np.sum(exp_est)

    for i in range(len(bandits)):
        print("Player {} => Final avg reward = {}. Best Action = {}.".format(i, mean_rewards_avg[i][-1], all_actions[actions_max[i]]))
    circ = crear_circuito(all_actions[actions_max[0]], all_actions[actions_max[1]])
    backend = Aer.get_backend('statevector_simulator')
    job = backend.run(circ)
    result = job.result()
    outputstate = result.get_statevector(circ, decimals=5)    
    print("Output State : {}".format(outputstate))   

    fig0, axs = plt.subplots(2, 1, figsize=(20,10))
    labels = ['Estimate Action Values',
            'Stochastic Gradient Ascent']
    for i in range(len(bandits)):
        axs[0].plot(mean_rewards_avg[i], label=labels[i])
        axs[1].plot(probas[i], label="Player {}".format(i))    
    axs[0].set_title("Average reward while learning strategies")
    axs[0].set_xlabel("Episode")
    axs[0].set_ylabel("Mean Reward")
    axs[0].legend(loc='upper right')
    axs[1].set_title("Probabily of players selecting each action")
    axs[1].set_ylabel("Probability")
    axs[1].set_xlabel("Action")
    axs[1].legend(loc='upper right')
    plt.show()

if __name__ == '__main__':
    VQC()