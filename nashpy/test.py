import nashpy as nash
import numpy as np
import matplotlib.pyplot as plt

juego = "MP"

if juego == "PD":
    A = np.array([[6.6, 0],
                  [10,  3.3]])
    B = np.array([[6.6, 10],
                  [0,   3.3]])
    game = nash.Game(A, B)
elif juego == "PV":
    A = np.array([[6.6, 10],
                  [0,   3.3]])
    B = np.array([[6.6, 0],
                  [10,  3.3]])
    game = nash.Game(A, B)
elif juego == "MP":
    A = np.array([[ 10, -10],
                  [-10,  10]])
    B = np.array([[-10, 10],
                  [ 10,-10]])
    game = nash.Game(A, B)

reward_A = []
reward_B = []
iterations = 1000

etha = 0.1
epsilon_bar = 10**-1
play_counts_and_distributions = game.stochastic_fictitious_play(iterations=iterations, etha=etha, epsilon_bar=epsilon_bar)

pA = []
pB = []
for (row_play_counts, col_play_counts), distributions in play_counts_and_distributions:
    if np.sum(row_play_counts) != 0:
        pA.append(row_play_counts / np.sum(row_play_counts))
        pB.append(col_play_counts / np.sum(col_play_counts))
    else: 
        pA.append(row_play_counts + 1 / len(row_play_counts))
        pB.append(col_play_counts + 1 / len(col_play_counts))    
    
fig0, axs = plt.subplots(2, 1, figsize=(8,6))
for number, strategy in enumerate(zip(*pA)):
    axs[0].plot(strategy, label=f"$s_{number}$") 
for number, strategy in enumerate(zip(*pB)):
    axs[1].plot(strategy, label=f"$s_{number}$") 

axs[0].set_ylabel("Probability") 
axs[1].set_ylabel("Probability") 
axs[1].set_xlabel("Iteration") 
axs[0].set_title("Actions taken by player A") 
axs[1].set_title("Actions taken by player B") 
axs[0].legend() 
axs[1].legend() 
plt.show()

"""
play_counts = game.fictitious_play(iterations=iterations)
flag = 0
for row_play_count, column_play_count in play_counts:
    if flag == 0:
        flag = 1
        continue
    play_CC = (row_play_count[0])/(np.sum(row_play_count)) * (column_play_count[0])/(np.sum(column_play_count))
    play_CD = (row_play_count[0])/(np.sum(row_play_count)) * (column_play_count[1])/(np.sum(column_play_count))
    play_DC = (row_play_count[1])/(np.sum(row_play_count)) * (column_play_count[0])/(np.sum(column_play_count))
    play_DD = (row_play_count[1])/(np.sum(row_play_count)) * (column_play_count[1])/(np.sum(column_play_count))
    reward_A.append(play_CC * A[0][0] + play_CD * A[0][1] + play_DC * A[1][0] + play_DD * A[1][1])
    reward_B.append(play_CC * B[0][0] + play_CD * B[0][1] + play_DC * B[1][0] + play_DD * B[1][1])

print("Reward player A =", reward_A[-1])
print("Reward player B =", reward_B[-1])

plt.plot(reward_A, label="Player A")
plt.plot(reward_B, label="Player B")
plt.title("Fictitious Play in PD")
plt.ylabel("Reward")
plt.xlabel("Iteration")
plt.legend()
plt.show()
"""