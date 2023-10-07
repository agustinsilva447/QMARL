import numpy as np 
import matplotlib.pyplot as plt

<<<<<<< HEAD
"""
n -> cantidad de jugadores
e -> 1 - probabilidad de que todos los jugadores ganen
i -> cantidad de iteraciones necesarias
"""

"""
n = np.arange(2,10)
e = [0.1, 0.01]
i0 = (np.log(e[0]))/(np.log((n-1)/(n)))
i1 = (np.log(e[1]))/(np.log((n-1)/(n)))

print(i0)
print(i1)

plt.plot(n, i0, label = "0.9")
plt.plot(n, i1, label = "0.99")
plt.legend()
plt.show()
"""

"""
players = 2
actions = [0 for i in range(players)] 
rotat = np.zeros([len(actions), 3])
N_SIZE = 4 
A_MAX  = 2*np.pi
angulos = np.arange(0, A_MAX, A_MAX / np.power(2, N_SIZE))
all_actions = [(rx,ry,rz) for rx in angulos for ry in angulos for rz in angulos]
for idx, action_i in enumerate(actions):
    rotat[idx] =  all_actions[action_i]
#rotat2 = [[np.pi * np.random.rand(), np.pi * np.random.rand(), np.pi * np.random.rand()] for i in range(players)]
rotat2 = [[0, 0, 0] for i in range(players)]
print((rotat == rotat2).all())
"""
"""
players = 3
p           = 0.99  # probabilidad de que los N jugadores encuentren su equilibrio de Nash más conveniente, asumiendo que existen N equilibrios de Nash
iterations  = int(np.ceil(np.log(1 - p)/np.log((players - 1)/(players))))
print(p, iterations)

hist  = [[[0, 0], 0] for i in range(players)]
hist2 = [[[0] * players, 0] for i in range(players)]

print(hist)
print(hist2)
print((hist == hist2))
"""

print(np.random.uniform(0, 1, 512))
print(np.ones(512))
=======
def general1qgate(a,b,c):
    u2 = np.matrix([[             np.cos(a/2), -np.exp(1j*c)    *np.sin(a/2)],
                    [np.exp(1j*b)*np.sin(a/2),  np.exp(1j*(b+c))*np.cos(a/2)]])
    return u2

I = general1qgate(0,0,0)
H = general1qgate(np.pi/2,0,np.pi)
Z = general1qgate(0,0,np.pi)
print(I)

players = 3
av_re = 10
perf = 10 * av_re / (players // 2)
print((perf))
>>>>>>> 89c426bc2874484a12b6ba0b5ce0811ab69959e0
