import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange

class Agent:
    def __init__(self, n_anctions, epsilon_0=0.1, e_decay=1):
        self.epsilon_0 = epsilon_0
        self.e_decay = e_decay
        self.indices = np.arange(n_anctions)

    def reset(self):
        self.q_estimation = np.zeros(len(self.indices))
        self.epsilon = self.epsilon_0
        self.action_count = np.zeros(len(self.indices))
        return np.random.choice(self.indices)

    def act(self):
        self.epsilon *= self.e_decay
        if np.random.rand() < self.epsilon:
            return np.random.choice(self.indices)           
        q_best = np.max(self.q_estimation)
        return np.random.choice(np.where(self.q_estimation == q_best)[0])

    def step(self, action, reward):
        self.action_count[action] += 1
        self.step_size = 1 / self.action_count[action]        
        self.q_estimation[action] += (reward - self.q_estimation[action]) / self.action_count[action]
        return self.q_estimation

def reward_game(prob):
    seed = np.random.uniform()
    outc = np.where(seed>prob, 0, 1)
    rewa = [0 for i in range(len(outc))]
    if (np.count_nonzero(outc == 1) == 1):
        rewa = np.where(outc == 1, 1, 0)         # non-cooperative
        #rewa = [1 for i in range(len(outc))]    # cooperative
    return rewa

def game(all_actions, actions):
    prob = np.zeros([len(actions)])
    for idx, action_i in enumerate(actions):
        prob[idx] =  all_actions[action_i]      
    reward = reward_game(prob)      
    return reward        

def simulate(agents, time, all_actions): 
    q_table =     [0 for i in range(len(agents))] 
    actions =     [0 for i in range(len(agents))] 
    actions_max = [0 for i in range(len(agents))] 
    reward =      [0 for i in range(len(agents))]
    reward_max =  [0 for i in range(len(agents))] 
    rewards =     np.zeros((len(agents), time))
    rewards_avg = np.zeros(rewards.shape) 

    for t in trange(time):    
        for i, agent in enumerate(agents):
            if t==0:
                actions[i] = agent.reset()
            else:
                rewards[i, t] = reward[i]  
                rewards_avg[i, t] = np.mean(rewards[i,0:t+1])   
                if reward[i] > reward_max[i]:
                    actions_max[i] = actions[i] 
                q_table[i] = agent.step(actions[i], reward[i])
                actions[i] = agent.act()
        reward = game(all_actions, actions)
    return rewards, rewards_avg, actions_max, q_table        

def Minority():
    players = 2
    all_actions = np.arange(0,1,0.01)
    time = 100000
    epsilon_0 = 0.99
    epsilon_f = 0.01
    e_decay = np.power(epsilon_f/epsilon_0, 1/time)
    agents = []
    for i in range(players):
        agents.append(Agent(n_anctions=len(all_actions)))  
    rewards , rewards_avg, actions_max, q_table = simulate(agents, time, all_actions) 

    """prob = np.random.uniform(size = [players])
    seed = np.random.uniform()
    outc = np.where(seed>prob, 0, 1)
    rewa = [0 for i in range(len(outc))]
    if (np.count_nonzero(outc == 1) == 1):
        rewa = np.where(outc == 1, 1, 0)
    print(prob, seed, outc, rewa)"""

    for i in range(players):
        print("Player {} => Final avg reward = {}. Best Action = {}.".format(i, rewards_avg[i][-1], all_actions[actions_max[i]]))
    
    best_actions = [all_actions[actions_max[i]] for i in range(players)]  
    print("Best Action : {}".format(best_actions))   

    plt.close()
    fig0, axs = plt.subplots(2, 1, figsize=(20,10))
    for i in range(players):
        axs[0].plot(rewards_avg[i], label="Player {}".format(i))
        axs[1].plot(q_table[i], label="Player {}".format(i))    
    axs[0].set_title("Average reward while learning strategies")
    axs[0].set_xlabel("Episode")
    axs[0].set_ylabel("Mean Reward")
    axs[0].legend(loc='upper right')
    axs[1].set_title("Q-table of players for each action")
    axs[1].set_ylabel("Action Value")
    axs[1].set_xlabel("Action")
    axs[1].legend(loc='upper right')
    plt.show()

if __name__ == '__main__':
    Minority()