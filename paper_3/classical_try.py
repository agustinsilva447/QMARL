import copy
import numpy as np
import matplotlib.pyplot as plt
from tqdm import trange

# AGENTS
class Agent:
    def __init__(self, n_anctions, alfa):
        self.indices = np.arange(n_anctions)
        self.alfa = alfa
        self.done = 0
    def reset(self):
        self.p_estimation = np.random.uniform(0, 1, len(self.indices))
        self.prob = self.p_estimation / np.sum(self.p_estimation)        
        return np.random.choice(self.indices, p=self.prob)        
    def act(self):
        return np.random.choice(self.indices, p=self.prob)
    def step(self, action, reward):
        if self.done == 0:
            self.prob = (1 - self.alfa * reward) * self.prob
            self.prob[action] += self.alfa * reward
            if np.max(self.prob)>0.999:
                self.done = 1
        return self.done
    def end(self): 
        return self.prob

# GAMES (entre 0 y 10)
def battle_of_sexes():
    mm = np.zeros([4,2])
    mm[0] = [10,  5]
    mm[1] = [ 0 , 0]
    mm[2] = [ 2 , 2]
    mm[3] = [ 5, 10]
    return mm

def chicken():
    mm = np.zeros([4,2])
    mm[0] = [ 5,  5]
    mm[1] = [10,  4]
    mm[2] = [ 4, 10]
    mm[3] = [ 0,  0]
    return mm

def prisoners():
    mm = np.zeros([4,2])
    mm[0] = [ 3,  3]
    mm[1] = [ 0, 10]
    mm[2] = [10,  0]
    mm[3] = [ 6,  6]
    return mm

def platonia():
    mm = np.zeros([4,2])
    mm[0] = [  0,  0]
    mm[1] = [ 10,  0]
    mm[2] = [  0, 10]
    mm[3] = [  0,  0]
    return mm

# MAIN
players     = 2
alfa        = 0.01
t_max       = 1000
window1     = t_max // 100
window2     = t_max
p           = 0.99  # probabilidad de que los N jugadores encuentren su equilibrio de Nash más conveniente, asumiendo que existen N equilibrios de Nash
iterations  = int(np.ceil(np.log(1 - p)/np.log((players - 1)/(players))))
actions     = [0 for i in range(players)]
dones       = [0 for i in range(players)]
rewards     = np.zeros((players, t_max * (iterations+1)))
rewards_avg = np.zeros(rewards.shape)
hist        = [[[0, 0], 0] for i in range(players)]
game        = battle_of_sexes()

t1 = 0
t2 = 0
t3 = []
# Exploration
for it in range(iterations):
    # Initialization
    agents = []
    for i in range(players):
        agents.append(Agent(n_anctions=len(game[0]), alfa=alfa))
        actions[i] = agents[i].reset()

    # First reward
    joint_a = 0
    for j,a in enumerate(actions):
        joint_a += a * 2**j
    reward = game[joint_a]

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
            dones[i] = agents[i].step(actions[i], reward[i])
            actions[i] = agents[i].act()
                
        # Done checking
        t2 += 1
        eq = (dones == np.ones(players)).all()
        if eq or (t2+1 == t_max):
            porc *= (t2+1)/t_max
            t1 += t2
            t2 = 0
            t3.append(t1-1)
            flag = False

        # N rewards
        joint_a = 0
        for j,a in enumerate(actions):
            joint_a += a * 2**j
        reward = game[joint_a]    

    # Synchronization
    for i in range(len(hist)):
        if rewards_avg[i][t1+t2-1]>hist[i][1]:
            hist[i][0] = [np.argmax(agents[k].end()) for k in range(len(hist))]
            hist[i][1] = np.round(rewards_avg[i][t1+t2-1], 4)

    if eq:
        print("{:02d} ---> {} ---> Convergence achieved in {:.4f}%".format(it+1, hist, porc))
    else:
        print("{:02d} ---> {} ---> No convergence achieved".format(it+1, hist))

# Exploitation
k = 0
for t in trange(t_max):
    joint_a = 0
    for j,a in enumerate(hist[k][0]):
        joint_a += a * 2**j
    reward = game[joint_a]

    if k == (players-1):
        k = 0
    else:
        k += 1

    for i in range(players):
        rewards[i,t1+t] = reward[i]
        if t<window2:
            rewards_avg[i,t1+t] = np.mean(rewards[i,t1:t1+t+1])
        else:
            rewards_avg[i,t1+t] = np.mean(rewards[i,t1+t-window2:t1+t+1])

print(t3)
print(hist)

for i in range(players):
    plt.plot(rewards_avg[i][0:t1+t2+t_max], label="Player {}".format(i))
for i in t3:
    plt.axvline(x = i, color = 'black')
plt.ylim(0,11)
plt.legend(loc="upper right")
plt.show()