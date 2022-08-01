import nashpy as nash
import numpy as np

A = np.array([[6.6, 0],
              [10,  3.3]])
B = np.array([[6.6, 10],
              [0,   3.3]])
rps = nash.Game(A, B)

iterations = 100
play_counts = rps.fictitious_play(iterations=iterations)
for row_play_count, column_play_count in play_counts:
    pass

play_CC = (row_play_count[0])/(np.sum(row_play_count)) * (column_play_count[0])/(np.sum(column_play_count))
play_CD = (row_play_count[0])/(np.sum(row_play_count)) * (column_play_count[1])/(np.sum(column_play_count))
play_DC = (row_play_count[1])/(np.sum(row_play_count)) * (column_play_count[0])/(np.sum(column_play_count))
play_DD = (row_play_count[1])/(np.sum(row_play_count)) * (column_play_count[1])/(np.sum(column_play_count))

reward_A = play_CC * A[0][0] + play_CD * A[0][1] + play_DC * A[1][0] + play_DD * A[1][1]
reward_B = play_CC * B[0][0] + play_CD * B[0][1] + play_DC * B[1][0] + play_DD * B[1][1]
print("Reward player A =", reward_A)
print("Reward player B =", reward_B)