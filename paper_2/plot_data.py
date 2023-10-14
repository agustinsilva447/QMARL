import numpy as np
import matplotlib.pyplot as plt

name_figure = "volunteer_5q_1"
with open('./npy_files/{}.npy'.format(name_figure), 'rb') as f:
    feedback = np.load(f)

n = len(feedback)
x0 = 0
for i in range(n):
  x1 = feedback[i][-1]
  x0 += x1
  print("Performance of player {} = {}.".format(i, x1))
  plt.plot(feedback[i], label="Player {}".format(i), linewidth = 2.5)
print("Average performance of all players = {}".format(x0/n))  
plt.ylim(-10.5, 1.5)
plt.xlabel("Iterations")
plt.xticks(fontsize=15)
plt.ylabel("Rewards")
plt.yticks(fontsize=15)
plt.subplots_adjust(top=0.9, bottom=0.1, left=0.2, right=0.8, hspace=0.2, wspace=0.2)
plt.grid()
plt.legend(loc="lower right")
plt.show()