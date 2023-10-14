import numpy as np
import matplotlib.pyplot as plt

with open('./npy_files/minority_3c_1.npy', 'rb') as f:
    feedback = np.load(f)

n = len(feedback)
x0 = 0
for i in range(n):
  x1 = feedback[i][-1]
  x0 += x1
  print("Performance of player {} = {}.".format(i, x1))
  plt.plot(feedback[i], label="Player {}".format(i))
print("Average performance of all players = {}".format(x0/n))  
#plt.ylim(0, 10)
plt.xlabel("Iterations")
plt.ylabel("Rewards")
plt.legend()
plt.show()